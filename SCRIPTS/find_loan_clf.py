import re

def find_entries(text):
    """
    Finds all entries (\lx) that have the information 'clf' in the \ps field
    and also contain the information \bw <langue="cmn"> inside that entry.

    Args:
        text: The input text containing the entries.

    Returns:
        A list of strings, where each string is an entry that matches the criteria.
    """

    entries = text.split('\n\n')  # Split into entries based on blank lines
    matching_entries = []

    for entry in entries:
        if re.search(r'\\ps\s+clf', entry) and re.search(r'\\bw\s*<langue="cmn">', entry):
            matching_entries.append(entry)

    return matching_entries


# Example usage:
with open('na.txt', 'r', encoding='utf-8') as f:
    text = f.read()

matching_entries = find_entries(text)

if matching_entries:
    print("Matching entries:\n")
    for entry in matching_entries:
        print(entry + "\n\n")
else:
    print("No matching entries found.")
