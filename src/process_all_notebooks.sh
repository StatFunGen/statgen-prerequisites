#!/bin/bash

# Loop through all ipynb files in the current directory
for notebook in *.ipynb; do
    # Skip template.ipynb, Notations.ipynb, and any notebooks starting with "unfinished"
    if [[ "$notebook" != "template.ipynb" && "$notebook" != "Notations.ipynb" && "$notebook" != unfinished* ]]; then
        echo "Processing $notebook..."
        ./jupyter_to_beamer.sh "$notebook"
    fi
done

echo "All notebooks processed!"
