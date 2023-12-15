import sys
import pathlib

ROOT_DIR = sys.argv[1]

root = pathlib.Path(ROOT_DIR)

list(root.rglob('requirements.txt'))
# recursivley search for requirements.txt files
files = list(root.rglob('requirements.txt'))



# concatonate their contents and return as a string

extracted_requirements = []
for file in files:
    extracted_requirements.extend(file.read_text().split('\n'))

final_requirements = ''

for requirement in set(extracted_requirements):
    if requirement:
        final_requirements += requirement + '\n'

print(final_requirements[:-1])
