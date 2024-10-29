import re

# Function to process the file line by line and include line numbers
def find_va_in_sn_above_1_with_line_numbers(file_path):
    current_sn = None  # To track the current subentry number
    line_number = 0  # Line counter

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            line_number += 1

            # Check if the line contains a subentry number (\sn)
            sn_match = re.match(r"\\sn\s+(\d+)", line)
            if sn_match:
                current_sn = int(sn_match.group(1))  # Update the current \sn value

            # If the current \sn is greater than 1, check for \va fields
            if current_sn and current_sn > 1:
                va_match = re.match(r"(\\va\s<speaker=.*>)", line)
                if va_match:
                    # Print the \va field and the corresponding line number
                    va = va_match.group(1)
                    print(f"Subentry number {current_sn} has the following \va field on line {line_number}:\n{va}\n")

# Call the function with the uploaded file
file_path = 'na.lex'
find_va_in_sn_above_1_with_line_numbers(file_path)
