# Script to remove extra lines introduced in the XML annotation files when they were  processed in the 2010s. One and the same line of contents was broken into several lines, resulting in troublesome breaks inside a tag.
import xml.etree.ElementTree as ET
import re

# Load and parse the XML content
tree = ET.parse("input.xml")
root = tree.getroot()

# Tags to process
tags_to_process = {"FORM", "TRANSL", "NOTE"}

# Function to clean line breaks and tabs from text within specified tags
def clean_text(text):
    if text:
        # Replace line breaks with a single space and remove tabs
        return text.replace('\n', ' ').replace('\t', '').strip()
    return text

# Iterate through all elements in the XML tree
for elem in root.iter():
    # Check if the element tag is one of those specified
    if elem.tag in tags_to_process:
        # Clean up the element text
        elem.text = clean_text(elem.text)

# Convert the XML tree to a string
xml_string = ET.tostring(root, encoding="utf-8", method="xml").decode("utf-8")

# Remove the unwanted space before self-closing tags
xml_string = re.sub(r'\s+/>', '/>', xml_string)

# Write the modified XML string back to a file
with open("output.xml", "w", encoding="utf-8") as file:
    file.write(xml_string)

print("Line breaks and tabs removed within specified tags, and extra space in self-closing tags fixed.")
