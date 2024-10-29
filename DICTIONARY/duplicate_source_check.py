import re

# Function to process file line by line within each \lx entry, ensuring we stay within an entry block
def find_va_in_sn_above_1_within_lx(file_path):
    current_sn = None  # To track the current subentry number
    within_lx = False  # To track if we are inside an \lx entry
    line_number = 0  # Line counter
    results = []

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            line_number += 1

            # Check if the line starts a new entry \lx
            if re.match(r"\\lx", line):
                within_lx = True
                current_sn = None  # Reset subentry for new entry

            # If we hit an empty line, we are no longer within an \lx entry
            if line.strip() == "":
                within_lx = False

            # Check if we are within an \lx entry and process \sn and \va fields
            if within_lx:
                # Check for \sn field
                sn_match = re.match(r"\\sn\s+(\d+)", line)
                if sn_match:
                    current_sn = int(sn_match.group(1))  # Update the current \sn value

                # If the current \sn is greater than 1, check for \va fields
                if current_sn and current_sn > 1:
                    va_match = re.match(r"(\\va\s<speaker=.*>)", line)
                    if va_match:
                        # Capture the \va field and the corresponding line number
                        va = va_match.group(1)
                        results.append(f"Subentry number {current_sn} has the following \va field on line {line_number}:\n{va}\n")

    return results

# Path to the uploaded file
file_path = 'na.lex'

# Run the function and store the results
results = find_va_in_sn_above_1_within_lx(file_path)

# Output the results
for result in results:
    print(result)

