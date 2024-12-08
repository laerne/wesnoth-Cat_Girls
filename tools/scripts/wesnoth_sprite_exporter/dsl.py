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
        for token in domain_string.split(","):
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


def tags_to_replacement_symbols(tags):
    return {tag : (tag if value is None else value) for tag, value in tags.items()}

@dataclass
class IdentifierSubInfo:
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

@dataclass
class IdentifierInfo:
    input_name : str = ""
    subinfos   : list[IdentifierSubInfo] = field(default_factory=list)

    def match_tags(self, tags : dict[str, int | str]):
        return not self.subinfos or any(subinfo.match_tags(tags) for subinfo in self.subinfos)


_tag_re = re.compile(R"""\{(?P<id> *[a-zA-Z0-9_ ',+-]+)( *= *(?P<domain>[^{}]*))? *\}""")
_separator_re = re.compile(R"""[;\n]""")
def parse_identifier_name(name):
    identifier_info = IdentifierInfo()

    for subname in _separator_re.split(name):
        if not subname.strip():
            continue
        identifier_sub_info = IdentifierSubInfo()
        for tag in _tag_re.finditer(subname):
            tag_id = tag.group("id")
            domain = make_domain(tag.group("domain"))
            identifier_sub_info.tags[tag_id] = domain
        identifier_info.subinfos.append(identifier_sub_info)
    return identifier_info


@dataclass
class IterationCartesianProductInfo:
    formattable_name : str = ""
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
                tags = dict(tag_name_value_pairs)
                replacements = tags_to_replacement_symbols(tags)
                name = cartesian_product_info.formattable_name.format(**replacements)
                yield name, dict(tag_name_value_pairs)

_comment_re = re.compile(R"""(?<!\\)#.*$""")
def parse_iteration_instruction(instruction):
    iteration_info = IterationInfo()
    for line in instruction.splitlines():
        instruction_line = _comment_re.sub("", line)
        if not instruction_line:
            continue
        for subinstruction in instruction_line.split(";"):
            cartesian_product_info = IterationCartesianProductInfo()
            cartesian_product_info.formattable_name = _tag_re.sub(R"{\g<id>}", subinstruction.partition(':')[0].strip())
            for tag in _tag_re.finditer(subinstruction):
                tag_id = tag.group("id")
                domain = make_domain(tag.group("domain"))
                cartesian_product_info.tags[tag_id] = domain
            iteration_info.cartesian_products.append(cartesian_product_info)
    return iteration_info    

def functional_test():
    from pprint import pprint
    layer_name = "base{stand}{k=0};stand{stand}{k=1-15}"
    idi1 = parse_identifier_name(layer_name)
    print(f"{idi1 = }")

    iteration_instruction = """\
units/feu-ra/chakram-warriors/{chakram-thrower}                  : {stand} {se} {k=0} # Default sprite
units/feu-ra/chakram-warriors/{chakram-thrower}-{ne}             : {stand} {k=0}
units/feu-ra/chakram-warriors/{chakram-thrower}-{stand}-{k=1-15} : {se}
units/feu-ra/chakram-warriors/{chakram-thrower}-{run}-{k=0-5}    : {se}
"""
    iti1 = parse_iteration_instruction(iteration_instruction)
    print(f"{iti1 = }")
    for name, tags in iter(iti1):
        print(f"{name = } :: {tags = }")

if __name__ == '__main__':
    functional_test()