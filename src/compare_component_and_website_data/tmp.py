"""Compare"""
def clean(ls):
    """Reads lines and cleans out common issues"""
    return set([
        x.replace('\\u00a0', '')
        .replace('\xa0', '')
        .replace('\n', '')
        for x in ls])


with open('comp2.txt', 'r') as f:
    c_lines = f.readlines()  # 5,781
    c_set = clean(c_lines)  # 2,331

with open('json2.txt', 'r') as f:
    j_lines = f.readlines()  # 5,781
    j_set = clean(j_lines)  # 2,331

source_diff = c_lines != j_lines  # True
i = c_set.intersection(j_set)  # 2,332 100%
c_diff = c_set.difference(j_set)  # 0
j_diff = j_set.difference(c_set)  # 0
print()
