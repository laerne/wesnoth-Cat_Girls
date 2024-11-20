import os
import sys
import itertools
import re
from dataclasses import dataclass, field

#from krita import *
#_krita = Krita.instance()


@dataclass
class IntDomain:
    subranges : list[range] = field(default_factory=list)
    @staticmethod
    def from_string(domain_string : str):
        ranges = []
        range_strings = domain_string.replace(" ", "").split(",")
        for range_string in range_strings:
            if not range_string:
                continue
            left_bound_string, _, right_bound_string = range_string.partition('-')
            left_bound = int(left_bound_string)
            if right_bound_string:
                right_bound = int(right_bound_string) + 1
            else:
                right_bound = left_bound + 1
            assert left_bound < right_bound
            ranges.append(range(left_bound, right_bound))
        return IntDomain(ranges)
    
    def __contains__(self, x : int):
        return any(x in subrange for subrange in self.subranges)
    
    def __iter__(self):
        return itertools.chain(*self.subranges)


@dataclass
class StrDomain:
    subvalues : list[str] = field(default_factory=list)
    @staticmethod
    def from_string(domain_string : str):
        result = StrDomain()
        for token in delimiter_tokenize(domain_string, ","):
            if token != ",":
                result.subvalues.append(token)
        return result

    def __contains__(self, x : str):
        return x in self.subvalues
    
    def __iter__(self):
        return iter(self.subvalues)
    

Domain = None | IntDomain | StrDomain
    

def make_domain(domain_string : str) -> Domain:
    if not domain_string:
        return None
    if re.fullmatch(" *[0-9]+ *([,-] *[0-9]+ *)*", domain_string):
        return IntDomain.from_string(domain_string)
    else:
        return StrDomain.from_string(domain_string)


def delimiter_tokenize(name, token_delimiters):
    tokens = []
    current_token = ""
    to_be_escaped = False
    for c in name:
        if to_be_escaped:
            if c.isalnum() or c.isspace() or c == '_':
                current_token += '\\' + c
            else:
                current_token += c
            to_be_escaped = False
        else:
            if c in token_delimiters:
                if current_token:
                    tokens.append(current_token)
                tokens.append(c)
                current_token=""
            elif c == "\\":
                to_be_escaped = True
            else:
                current_token += c
    if current_token:
        tokens.append(current_token)
    return tokens


def tags_to_replacement_symbols(tags):
    return {tag : (tag if value is None else value) for tag, value in tags.items()}


def join_names(*names, separator="-"):
    if not names:
        return ""
    joined_name = names[0]
    for name in itertools.islice(names, 1, None):
        if not name:
            continue
        if not joined_name:
            joined_name = name
        elif joined_name.endswith("/") or name.startswith("/"):
            joined_name += name
        else:
            joined_name += separator + name
    return joined_name


_unintential_identifier_re = re.compile(
    """
    (Copy\ of\ .*) # This layer is a copy that kept its name...
    |
    (
        (
            (Paint|Clone|Vector|Filter|Fill|File)\ Layer    # This layer kept its default name...
            |
            (Transparency|Filter|Colorize|Transform)\ Mask  # This is a mask with its default name...
            |
            Group                                           # This is a group with its default name...
            |
            Selection                                       # This is a local selection with its default name...
        )\ [0-9]+(\ .*)?)                                   # Default name always have a number after them, then possibly some garbaged separated by a whitespace
    |
    (.*\.(png|jpe?g|gif|ora|kra))\~?                        # This is an imported layer with its default name.
    """
    , re.X)

@dataclass
class IdentifierSubInfo:
    formattable_name : str = ""
    tags             : dict[str, Domain] = field(default_factory=dict)

    def empty(self):
        return not self.formattable_name and not self.tags
    
    def match_tags(self, tags : dict[str, int | str]):
        for tag_name in self.tags:
            if tag_name not in tags:
                return False
            domain = self.tags[tag_name]
            if domain is None:
                continue
            value = tags[tag_name]
            if value is None:
                return False
            if value not in domain:
                return False
        return True
    
    def _make_name(self, tags, replacement_symbols):
        if not self.match_tags(tags):
            return ""
        if _unintential_identifier_re.fullmatch(self.formattable_name):
            return ""
        print(f"      SubInfo will convert {self.formattable_name} to {self.formattable_name.format(**replacement_symbols)}")
        print(f"      It has tags {tags}.")
        return self.formattable_name.format(**replacement_symbols)

    def make_name(self, tags):
        if isinstance(tags, dict):
            replacement_symbols = tags
        else:
            replacement_symbols = tags_to_replacement_symbols(tags)
        return self._make_name(tags, replacement_symbols)

@dataclass
class IdentifierInfo:
    input_name : str = ""
    subinfos   : list[IdentifierSubInfo] = field(default_factory=list)

    def match_tags(self, tags : dict[str, int | str]):
        return not self.subinfos or any(subinfo.match_tags(tags) for subinfo in self.subinfos)
    
    def _make_name(self, tags, replacement_symbols):
        subnames = [subinfo._make_name(tags, replacement_symbols) for subinfo in self.subinfos]
        print(f"    Info will join {subnames} to {repr(join_names(*subnames))}")
        return join_names(*subnames)

    def make_name(self, tags):
        if isinstance(tags, dict):
            replacement_symbols = tags
        else:
            replacement_symbols = tags_to_replacement_symbols(tags)
        return self._make_name(tags, replacement_symbols)


def parse_identifier_name(name):
    tokens = delimiter_tokenize(name, frozenset("[]{}=;\n"))
    #print("tokens:", end = "\n  ")
    #print('\n  '.join(tokens))

    square_brace_count = 0
    curly_brace_count = 0
    k = 0
    formattable_tokens = []
    is_defining_range = False
    current_tag = ""
    current_range = ""

    current_identifier_sub_info = IdentifierSubInfo()
    identifier_info = IdentifierInfo()
    identifier_info.input_name = name

    def is_hidden():
        return square_brace_count > 0
    
    def is_defining_tag():
        return curly_brace_count > 0
    
    def commit_current_tag():
        nonlocal current_tag
        nonlocal current_range
        if current_tag:
            current_identifier_sub_info.tags[current_tag] = make_domain(current_range)
        current_tag = ""
        current_range = ""
    
    def commit_current_identifier_sub_info():
        nonlocal current_identifier_sub_info
        if not current_identifier_sub_info.empty():
            identifier_info.subinfos.append(current_identifier_sub_info)
        current_identifier_sub_info = IdentifierSubInfo()

    for k in range(len(tokens)):
        token = tokens[k]
        match token:
            case '[':
                square_brace_count += 1
            case ']':
                assert is_hidden()
                square_brace_count -= 1
            case '{':
                assert not is_defining_tag()
                curly_brace_count += 1
            case '}':
                assert is_defining_tag()
                is_defining_range = False
                curly_brace_count -= 1
                if curly_brace_count <= 0 and current_tag:
                    commit_current_tag()
            case '=':
                assert is_defining_tag()
                is_defining_range = True
                pass
            case ';' | '\n':
                if is_defining_tag():
                    commit_current_tag()
                else:
                    commit_current_identifier_sub_info()
            case word:
                if is_defining_tag():
                    if not is_defining_range:
                        if not is_hidden():
                            current_identifier_sub_info.formattable_name += token
                        current_tag += token
                    else:
                        if not is_hidden():
                            current_identifier_sub_info.formattable_name += "{" + current_tag + "}"
                        current_range += token
                else:
                    if not is_hidden():
                        current_identifier_sub_info.formattable_name += token

    assert not is_defining_tag()
    assert not is_hidden()

    commit_current_identifier_sub_info()
            
    return identifier_info


@dataclass
class IterationCartesianProductInfo:
    tags: dict[str, Domain] = field(default_factory=dict)

    def empty(self):
        return bool(self.tags)

@dataclass
class IterationInfo:
    # The list represent a disjoined union of of cartesian products of 'axes'.
    # Each cartesian product is a dictionary from the axis label to a 1D Domain of that axis.
    cartesian_products: list[IterationCartesianProductInfo] = field(default_factory=list)

    def __iter__(self):
        def make_possible_tags(tag_name, tag_domain):
            if tag_domain is None:
                return [(tag_name, None)]
            else:
                return [(tag_name, value) for value in tag_domain]

        for cartesian_product_info in self.cartesian_products:
            unidimensional_tags = [make_possible_tags(tag_name, tage_domain) for tag_name, tage_domain in cartesian_product_info.tags.items()]
            for tag_name_value_pairs in itertools.product(*unidimensional_tags):
                yield dict(tag_name_value_pairs)


def parse_iteration_instruction(instruction):
    tokens = delimiter_tokenize(instruction, frozenset("=*;\n"))
    #print("tokens:", end = "\n  ")
    #print('\n  '.join(tokens))

    current_tag = ""
    current_range = ""
    is_defining_range = False
    current_cartesian_product = IterationCartesianProductInfo()
    iteration_info = IterationInfo()

    def commit_axis():
        nonlocal current_tag
        nonlocal current_range
        nonlocal is_defining_range
        nonlocal current_cartesian_product
        if current_tag:
            current_cartesian_product.tags[current_tag] = make_domain(current_range)
        is_defining_range = False
        current_tag = ""
        current_range = ""

    def commit_cartesian_product():
        nonlocal current_tag
        nonlocal current_range
        nonlocal is_defining_range
        nonlocal current_cartesian_product
        nonlocal iteration_info
        if current_cartesian_product.tags:
            iteration_info.cartesian_products.append(current_cartesian_product)
        is_defining_range = False
        current_tag = ""
        current_range = ""
        current_cartesian_product = IterationCartesianProductInfo()

    for k in range(len(tokens)):
        token = tokens[k]
        match token:
            case '=':
                is_defining_range = True
            case '*':
                commit_axis()
            case ';' | '\n':
                commit_axis()
                commit_cartesian_product()
            case word:
                if not is_defining_range:
                    current_tag += word
                else:
                    current_range += word
    commit_axis()
    commit_cartesian_product()
    return iteration_info
    

def functional_test():
    from pprint import pprint
    layer_name = "[base{k=0}];{stand;[k]=1-4}"
    identifier_info = parse_identifier_name(layer_name)
    print(f'{identifier_info.input_name = }')
    print("identifier_info.subinfos = ", end='')
    pprint(identifier_info.subinfos)

    iteration_instruction = "base*k=0;stand*k=1-4,6;complicated*i=0-2*j=alpha,beta"
    iteration_info = parse_iteration_instruction(iteration_instruction)
    pprint(iteration_info.cartesian_products)
    for tags in iteration_info:
        print(f"{tags = }")
        print(f"{identifier_info.match_tags(tags) = }")

    print(parse_identifier_name("base\[k\=0\]"))
    #print(parse_iteration_instruction("base*k=0"))

if __name__ == '__main__':
    functional_test()