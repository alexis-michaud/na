import re

# Function to check that every example \xv has corresponding \xe, \xn, and \xf translations, skipping comments \xc
def check_example_translations(file_path):
    line_number = 0  # Line counter
    missing_translations = []  # List to store any cases with missing translations
    current_xv = None  # To track the current example line and number

    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    while line_number < len(lines):
        line = lines[line_number].strip()

        # Check if the line contains an example \xv
        if re.match(r"\\xv", line):
            current_xv = {'line': line_number + 1, 'xv': line, 'xe': False, 'xn': False, 'xf': False}

            # Look for \xe, \xn, and \xf in the subsequent lines, skipping comments \xc
            next_line_number = line_number + 1
            while next_line_number < len(lines):
                next_line = lines[next_line_number].strip()

                # If a new \xv is encountered, stop checking this example
                if re.match(r"\\xv", next_line):
                    break

                # Skip comments \xc
                if re.match(r"\\xc", next_line):
                    next_line_number += 1
                    continue

                # Check for translations \xe, \xn, and \xf
                if re.match(r"\\xe", next_line):
                    current_xv['xe'] = True
                elif re.match(r"\\xn", next_line):
                    current_xv['xn'] = True
                elif re.match(r"\\xf", next_line):
                    current_xv['xf'] = True

                # Stop once all translations are found
                if current_xv['xe'] and current_xv['xn'] and current_xv['xf']:
                    break

                next_line_number += 1

            # Check if any of the translations are missing
            if not (current_xv['xe'] and current_xv['xn'] and current_xv['xf']):
                missing_translations.append(f"Example on line {current_xv['line']} is missing one or more translations: {current_xv}")

        line_number += 1  # Move to the next line

    # Output the results
    if missing_translations:
        for issue in missing_translations:
            print(issue)
    else:
        print("No issue found.")

# Path to the updated file
file_path = 'na.lex'  # Make sure the correct file path is used

# Run the function to check for missing translations
check_example_translations(file_path)
