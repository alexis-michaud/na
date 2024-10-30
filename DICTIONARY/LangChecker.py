import re
from langdetect import detect, DetectorFactory
from langdetect.lang_detect_exception import LangDetectException

# To make language detection deterministic
DetectorFactory.seed = 0

# Function to check language consistency in fields
def check_language_consistency(file_path):
    # Patterns for matching fields and their expected languages
    language_patterns = {
        r"\\de": "en",  # English
        r"\\xe": "en",  # English
        r"\\df": "fr",  # French
        r"\\xf": "fr",  # French
        r"\\dn": "zh-cn",  # Chinese
        r"\\xn": "zh-cn"   # Chinese
    }

    # Detecting if the content is Chinese (Mandarin) based on characters
    def is_chinese(text):
        return bool(re.search(r'[\u4e00-\u9fff]', text))

    # Function to restrict detection to only English, French, and Chinese
    def restricted_language_detect(text):
        try:
            detected_lang = detect(text)
            # Override langdetect results for short fields or edge cases
            if is_chinese(text):
                return 'zh-cn'
            elif detected_lang in ['en', 'fr', 'zh-cn']:
                return detected_lang
            else:
                return 'unknown'  # If detected language is not relevant or unsure
        except LangDetectException:
            return 'unknown'  # Unable to detect language

    issues = []  # To store any mismatches found
    line_number = 0  # Line counter

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            line_number += 1
            line = line.strip()

            # Check for lines that match the specific tags (\de, \xe, etc.)
            for pattern, expected_lang in language_patterns.items():
                if re.match(pattern, line):
                    field_content = line.split(' ', 1)[1] if ' ' in line else ""

                    # Detect language, restricting to only the relevant languages
                    detected_lang = restricted_language_detect(field_content)

                    # Ignore cases where detection fails (i.e., returns 'unknown')
                    if detected_lang == 'unknown':
                        continue

                    # Compare detected language with the expected language
                    if detected_lang != expected_lang:
                        issues.append(
                            f"Line {line_number}: Expected {expected_lang} but detected {detected_lang} in field '{pattern}' - content: {field_content}"
                        )

    # Output the results
    if issues:
        for issue in issues:
            print(issue)
    else:
        print("No language mismatches found.")

# Path to the updated file
file_path = 'na.lex'  # Make sure the correct file path is used

# Run the function to check language consistency
check_language_consistency(file_path)
