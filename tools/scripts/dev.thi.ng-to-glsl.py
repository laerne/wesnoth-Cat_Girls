# Coefficients have the form [[0.590 0.590 0.590] [0.500 0.608 0.500] [0.500 0.358 0.500] [0.500 0.518 0.788]]
# See http://dev.thi.ng/gradients

import itertools
import re
dev_thi_ng_re = re.compile(R'''
\s*
\[
    \s*
    \[
        \s* ([-+]?[0-9]+\.[0-9]+) \s* ([-+]?[0-9]+\.[0-9]+) \s* ([-+]?[0-9]+\.[0-9]+) \s*
    \]
    \s*
    \[
        \s* ([-+]?[0-9]+\.[0-9]+) \s* ([-+]?[0-9]+\.[0-9]+) \s* ([-+]?[0-9]+\.[0-9]+) \s*
    \]
    \s*
    \[
        \s* ([-+]?[0-9]+\.[0-9]+) \s* ([-+]?[0-9]+\.[0-9]+) \s* ([-+]?[0-9]+\.[0-9]+) \s*
    \]
    \s*
    \[
        \s* ([-+]?[0-9]+\.[0-9]+) \s* ([-+]?[0-9]+\.[0-9]+) \s* ([-+]?[0-9]+\.[0-9]+) \s*
    \]
    \s*
\]
\s*
''', re.X)

def parseGradientCoefficients(coefficientString : str):
    coefficientMatch = dev_thi_ng_re.match(coefficientString)
    return {
        "offset.red":      coefficientMatch.group(1),
        "offset.green":    coefficientMatch.group(2),
        "offset.blue":     coefficientMatch.group(3),
        "amplitude.red":   coefficientMatch.group(4),
        "amplitude.green": coefficientMatch.group(5),
        "amplitude.blue":  coefficientMatch.group(6),
        "frequency.red":   coefficientMatch.group(7),
        "frequency.green": coefficientMatch.group(8),
        "frequency.blue":  coefficientMatch.group(9),
        "phase.red":       coefficientMatch.group(10),
        "phase.green":     coefficientMatch.group(11),
        "phase.blue":      coefficientMatch.group(12),
    }

def formatGLSL(coefficients):
    vec3Strings = {}
    for parameterName in ["offset", "amplitude", "frequency", "phase"]:
        vec3Strings[parameterName] = f"vec3({coefficients[parameterName + '.red']}, {coefficients[parameterName + '.green']}, {coefficients[parameterName + '.blue']})"
    return f"colorGradient(t, {vec3Strings['offset']}, {vec3Strings['amplitude']}, {vec3Strings['frequency']}, {vec3Strings['phase']})"
        

def main(coefficientString):
    coefficients = parseGradientCoefficients(coefficientString)
    codeline = formatGLSL(coefficients)
    print(codeline)

if __name__ == '__main__':
    import sys
    if len(sys.argv) <= 1:
        print("No string to convert!", file=sys.stderr)
    for coefficientString in sys.argv[1:]:
        main(coefficientString)

