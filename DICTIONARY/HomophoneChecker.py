import re
from collections import defaultdict

# Function to check the consistency of homophone numbers for each form (\lx)
def check_homophones(file_path):
    current_lx = None
    forms = defaultdict(list)  # Dictionary to store form and its homophone numbers
    line_number = 0  # Line counter
    issues = []  # List to store any issues found

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            line_number += 1
            line = line.strip()

            # Check if the line contains a new form \lx
            lx_match = re.match(r"\\lx (.+)", line)
            if lx_match:
                current_lx = lx_match.group(1)  # Capture the form
                continue

            # Check if the line contains a homophone number \hm
            hm_match = re.match(r"\\hm (\d+)", line)
            if hm_match and current_lx:
                hm_number = int(hm_match.group(1))  # Capture the homophone number
                forms[current_lx].append(hm_number)

    # Now check the consistency of homophone numbers for each form
    for form, homophones in forms.items():
        unique_homophones = sorted(set(homophones))
        expected_homophones = list(range(1, len(homophones) + 1))

        # Check if the homophone numbers are consecutive and complete
        if unique_homophones != expected_homophones:
            issues.append(f"Form '{form}' has inconsistent homophone numbers: {unique_homophones}, expected: {expected_homophones}")

    # Output the results
    if issues:
        for issue in issues:
            print(issue)
    else:
        print("No homophone issues found.")

# Path to the updated file
file_path = 'na.lex'  # Make sure the correct file path is used

# Run the function to check homophones
check_homophones(file_path)
