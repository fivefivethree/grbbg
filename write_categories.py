"""
Edits the label class of each .txt YOLO annotation file in a directory.
"""

import os

# Setting up constants
INPUT_DIRECTORY = 'completed/delivery_tiled/valid/labels/'      # File input directory
OUTPUT_DIRECTORY = 'completed/delivery_valid_labels_edited/'   # File output directory
OLD_LABEL = '2'                                 # Label to replace (X for all)
NEW_LABEL = '5'                                 # New label to write 

# Read all text files in input directory
files = [f for f in os.listdir(INPUT_DIRECTORY) if f.endswith('.txt')]

# Go through each file and change the label marker
for file in files:
    with open(INPUT_DIRECTORY + file, 'r') as f:
        lines = f.readlines()
        for i in range(len(lines)):
            if OLD_LABEL == 'X' or OLD_LABEL == lines[i][0]:
                line = NEW_LABEL + lines[i][1:]
                lines[i] = line
    with open(OUTPUT_DIRECTORY + file + '.tmp', 'w') as f:
        for line in lines:
            f.write(line)
    os.rename(OUTPUT_DIRECTORY + file + '.tmp', OUTPUT_DIRECTORY + file)