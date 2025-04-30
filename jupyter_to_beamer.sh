#!/bin/bash

# jupyter_to_beamer.sh - Convert Jupyter notebooks to Beamer presentations
# Usage: ./jupyter_to_beamer.sh input.ipynb

if [ $# -ne 1 ]; then
    echo "Usage: $0 <input.ipynb>"
    exit 1
fi

INPUT_FILE=$1
BASENAME=$(basename "$INPUT_FILE" .ipynb)

# Create tex folder if it doesn't exist
TEX_DIR="tex"
if [ ! -d "$TEX_DIR" ]; then
    echo "Creating directory: $TEX_DIR"
    mkdir -p "$TEX_DIR"
fi

OUTPUT_FILE="${TEX_DIR}/${BASENAME}.tex"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Remove previous TEX file if it exists
if [ -f "$OUTPUT_FILE" ]; then
    echo "Removing existing file: $OUTPUT_FILE"
    rm "$OUTPUT_FILE"
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed. Please install it first."
    echo "On Ubuntu/Debian: sudo apt-get install jq"
    echo "On MacOS: brew install jq"
    exit 1
fi

echo "Converting $INPUT_FILE to $OUTPUT_FILE..."

# Create an empty output file
cat > "$OUTPUT_FILE" << 'EOL'
% Generated slides for Genotype Coding
% Include this file in your main Beamer presentation

EOL

# Create title slide using notebook name (without .ipynb extension)
TITLE=$(echo "$BASENAME" | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')
echo "\\begin{frame}{Section}" >> "$OUTPUT_FILE"
echo "\\centering" >> "$OUTPUT_FILE"
echo "\\Huge{$TITLE}" >> "$OUTPUT_FILE"
echo "\\end{frame}" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Extract markdown cells and save to temporary file
jq -r '.cells[] | select(.cell_type == "markdown") | .source | join("")' "$INPUT_FILE" > temp_markdown.txt

# Function to process Markdown tables to LaTeX tables
convert_table_to_latex() {
    local table_content="$1"
    local lines=()
    local line_count=0
    
    # Read lines into an array, skipping empty lines
    while IFS= read -r line; do
        if [[ -n "$line" && "$line" != *"---"* ]]; then
            lines[$line_count]="$line"
            ((line_count++))
        fi
    done <<< "$table_content"
    
    # Get header line (first line) and data lines
    local header_line="${lines[0]}"
    
    # Count columns based on the header line
    local num_columns=$(echo "$header_line" | grep -o "|" | wc -l)
    num_columns=$((num_columns - 1))  # Adjust for pipe at beginning/end
    
    # Start LaTeX table with resizing to fit the slide width
    echo "\\begin{table}[h]"
    echo "\\centering"
    echo "\\resizebox{\\textwidth}{!}{" # Make table fit slide width
    echo "\\begin{tabular}{|$(printf "%0.s""c|" $(seq 1 $num_columns))}"
    echo "\\hline"
    
    # Process header
    local header_content=$(echo "$header_line" | sed 's/^|//;s/|$//')
    IFS='|' read -ra HEADER_CELLS <<< "$header_content"
    local header_row=""
    for cell in "${HEADER_CELLS[@]}"; do
        # Trim spaces and add to header row
        trimmed_cell=$(echo "$cell" | sed 's/^ *//;s/ *$//')
        # Apply formatting
        trimmed_cell=$(echo "$trimmed_cell" | sed 's/\*\*\([^*]*\)\*\*/\\textbf{\1}/g')  # Bold
        trimmed_cell=$(echo "$trimmed_cell" | sed 's/`\([^`]*\)`/\\texttt{\1}/g')  # Code
        trimmed_cell=$(echo "$trimmed_cell" | sed 's/%/\\%/g')  # Escape percent signs
        header_row="${header_row}${trimmed_cell} & "
    done
    # Remove the trailing " & " and add line ending
    header_row=$(echo "$header_row" | sed 's/ & $//')
    echo "$header_row \\\\ \\hline"
    
    # Process data rows (skip the header)
    for ((i=1; i<${#lines[@]}; i++)); do
        local data_line="${lines[$i]}"
        
        # Extract and process cells
        local row_content=$(echo "$data_line" | sed 's/^|//;s/|$//')
        IFS='|' read -ra DATA_CELLS <<< "$row_content"
        local data_row=""
        for cell in "${DATA_CELLS[@]}"; do
            # Trim spaces and add to data row
            trimmed_cell=$(echo "$cell" | sed 's/^ *//;s/ *$//')
            # Apply formatting
            trimmed_cell=$(echo "$trimmed_cell" | sed 's/\*\*\([^*]*\)\*\*/\\textbf{\1}/g')  # Bold
            trimmed_cell=$(echo "$trimmed_cell" | sed 's/`\([^`]*\)`/\\texttt{\1}/g')  # Code
            trimmed_cell=$(echo "$trimmed_cell" | sed 's/%/\\%/g')  # Escape percent signs
            data_row="${data_row}${trimmed_cell} & "
        done
        # Remove the trailing " & " and add line ending
        data_row=$(echo "$data_row" | sed 's/ & $//')
        echo "$data_row \\\\ \\hline"
    done
    
    # End LaTeX table
    echo "\\end{tabular}}"
    echo "\\end{table}"
}

# Preprocess markdown to identify tables and tag them for later processing
awk -v RS= -v ORS='\n\n' '
    # Process tables (lines that start with | and contain |---|)
    /^\|.*\n\|[-:\| ]+\|/ {
        print "TABLE_START";
        print;
        print "TABLE_END";
        next;
    }
    # Print other blocks unchanged
    {
        print;
    }
' temp_markdown.txt > temp_with_tables.txt

# Now preprocess to identify and tag nested bullet points
awk '
    BEGIN { 
        in_list = 0;
        prev_indent = 0;
        list_level = 0;
        in_table = 0;
    }
    
    # Handle table markers
    /^TABLE_START/ {
        in_table = 1;
        print;
        next;
    }
    
    /^TABLE_END/ {
        in_table = 0;
        print;
        next;
    }
    
    # If in table, print lines as is
    in_table == 1 {
        print;
        next;
    }
    
    # Detect bullet points and their indentation level
    /^[ \t]*-[ \t]/ {
        # Count leading spaces to determine indentation
        match($0, /^[ \t]*/);
        indent = RLENGTH;
        
        # If first bullet point of a list
        if (in_list == 0) {
            in_list = 1;
            prev_indent = indent;
            list_level = 1;
            print "LIST_START_LEVEL_1";
            gsub(/^[ \t]*-[ \t]/, "ITEM_LEVEL_1 ");
            print;
            next;
        }
        
        # Handle nested bullet points
        if (indent > prev_indent) {
            list_level++;
            print "LIST_START_LEVEL_" list_level;
            gsub(/^[ \t]*-[ \t]/, "ITEM_LEVEL_" list_level " ");
        } else if (indent < prev_indent) {
            # Find the correct level to go back to
            while (list_level > 1) {
                list_level--;
                if (indent <= prev_indent) {
                    print "LIST_END_LEVEL_" (list_level + 1);
                    prev_indent = indent;
                } else {
                    break;
                }
            }
            gsub(/^[ \t]*-[ \t]/, "ITEM_LEVEL_" list_level " ");
        } else {
            # Same level as previous item
            gsub(/^[ \t]*-[ \t]/, "ITEM_LEVEL_" list_level " ");
        }
        
        prev_indent = indent;
        print;
        next;
    }
    
    # Empty line - might indicate end of a list
    /^[ \t]*$/ {
        if (in_list == 1) {
            # Close all open list levels
            for (i = list_level; i >= 1; i--) {
                print "LIST_END_LEVEL_" i;
            }
            in_list = 0;
            list_level = 0;
        }
        print;
        next;
    }
    
    # Non-bullet point line
    {
        # If we were in a list but this is not a bullet point, close all levels
        if (in_list == 1) {
            for (i = list_level; i >= 1; i--) {
                print "LIST_END_LEVEL_" i;
            }
            in_list = 0;
            list_level = 0;
        }
        print;
    }
    
    END {
        # Close any open lists at the end of the file
        if (in_list == 1) {
            for (i = list_level; i >= 1; i--) {
                print "LIST_END_LEVEL_" i;
            }
        }
    }
' temp_with_tables.txt > processed_markdown.txt

# Now convert the processed markdown to LaTeX
{
    # Read the processed file line by line
    current_section=""
    current_subsection=""
    capture_section=false
    in_table=false
    table_content=""
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Check for table markers
        if [[ "$line" == "TABLE_START" ]]; then
            in_table=true
            table_content=""
            continue
        elif [[ "$line" == "TABLE_END" ]]; then
            in_table=false
            # Process the table content to LaTeX
            if [ "$capture_section" = true ]; then
                latex_table=$(convert_table_to_latex "$table_content")
                echo "$latex_table" >> "$OUTPUT_FILE"
            fi
            continue
        elif [[ "$in_table" == true ]]; then
            # Collect table content
            table_content="${table_content}${line}
"
            continue
        fi
        
        # Check for main section headers (# Level 1)
        if [[ "$line" =~ ^#[[:space:]]+(.*) ]]; then
            section="${BASH_REMATCH[1]}"
            
            # If we were capturing a section, close the frame
            if [ "$capture_section" = true ]; then
                echo "\\end{frame}" >> "$OUTPUT_FILE"
                echo "" >> "$OUTPUT_FILE"
            fi
            
            # Check if this is one of our target sections
            if [[ "$section" == "Intuitional Description" || 
                  "$section" == "Graphical Summary" || 
                  "$section" == "Key Formula" || 
                  "$section" == "Technical Details" ]]; then
                current_section="$section"
                current_subsection=""
                
                # For Graphical Summary, create the frame immediately
                if [[ "$section" == "Graphical Summary" ]]; then
                    echo "\\begin{frame}{$current_section}" >> "$OUTPUT_FILE"
                    echo "\\includesvg[width=0.8\\textwidth]{./cartoons/${BASENAME}.svg}" >> "$OUTPUT_FILE"
                    echo "\\end{frame}" >> "$OUTPUT_FILE"
                    echo "" >> "$OUTPUT_FILE"
                    capture_section=false
                else
                    # For other sections, wait for content or subsection
                    capture_section=true
                fi
            else
                capture_section=false
            fi
        
        # Check for subsection headers (## Level 2)
        elif [[ "$line" =~ ^##[[:space:]]+(.*) ]] && [ "$capture_section" = true ]; then
            subsection="${BASH_REMATCH[1]}"
            
            # If we were already capturing content, close the previous frame
            if [ -n "$current_subsection" ]; then
                echo "\\end{frame}" >> "$OUTPUT_FILE"
                echo "" >> "$OUTPUT_FILE"
            fi
            
            # Start a new frame with the subsection title
            current_subsection="$subsection"
            echo "\\begin{frame}{$current_section: $current_subsection}" >> "$OUTPUT_FILE"
            
        elif [ "$capture_section" = true ]; then
            # If we encounter content before any subsection in a section
            if [[ -z "$current_subsection" && ! "$line" =~ ^[[:space:]]*$ && ! "$line" == "LIST_START_LEVEL_1" && ! "$line" == "LIST_START_LEVEL_2" && ! "$line" == "LIST_END_LEVEL_1" && ! "$line" == "LIST_END_LEVEL_2" && ! "$line" =~ ^ITEM_LEVEL_ ]]; then
                # Start a frame with just the section title
                echo "\\begin{frame}{$current_section}" >> "$OUTPUT_FILE"
                current_subsection="main" # Mark that we've started the main content
            fi
            
            # Skip image lines in other sections
            if [[ "$line" == *"![genotype]"* ]]; then
                continue
            fi
            
            # Handle list markers
            if [[ "$line" == "LIST_START_LEVEL_1" ]]; then
                echo "\\begin{itemize}" >> "$OUTPUT_FILE"
            elif [[ "$line" == "LIST_START_LEVEL_2" ]]; then
                echo "\\begin{itemize}" >> "$OUTPUT_FILE"
            elif [[ "$line" == "LIST_END_LEVEL_1" ]]; then
                echo "\\end{itemize}" >> "$OUTPUT_FILE"
            elif [[ "$line" == "LIST_END_LEVEL_2" ]]; then
                echo "\\end{itemize}" >> "$OUTPUT_FILE"
            elif [[ "$line" =~ ^ITEM_LEVEL_[0-9]+[[:space:]] ]]; then
                # Extract the item text
                item_text=$(echo "$line" | sed -E 's/^ITEM_LEVEL_[0-9]+[[:space:]]//')
                # Convert formatting
                item_text=$(echo "$item_text" | sed 's/\*\*\([^*]*\)\*\*/\\textbf{\1}/g')  # Convert bold
                item_text=$(echo "$item_text" | sed 's/`\([^`]*\)`/\\texttt{\1}/g')  # Convert inline code
                item_text=$(echo "$item_text" | sed 's/%/\\%/g')  # Escape percent signs
                echo "\\item $item_text" >> "$OUTPUT_FILE"
            else
                # Regular text - convert formatting
                processed_line=$(echo "$line" | sed 's/\*\*\([^*]*\)\*\*/\\textbf{\1}/g')  # Convert bold
                processed_line=$(echo "$processed_line" | sed 's/`\([^`]*\)`/\\texttt{\1}/g')  # Convert inline code
                processed_line=$(echo "$processed_line" | sed 's/%/\\%/g')  # Escape percent signs
                # Only output if not a subsection marker line
                if [[ ! "$processed_line" =~ ^##[[:space:]]+ ]]; then
                    echo "$processed_line" >> "$OUTPUT_FILE"
                fi
            fi
        fi
    done
    
    # Close the last frame if needed
    if [ "$capture_section" = true ]; then
        echo "\\end{frame}" >> "$OUTPUT_FILE"
    fi
    
} < processed_markdown.txt

# Clean up
rm temp_markdown.txt temp_with_tables.txt processed_markdown.txt

echo "Conversion complete! Output saved to $OUTPUT_FILE"