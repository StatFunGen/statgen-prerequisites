#!/usr/bin/env python3
"""
Script to check if Jupyter notebooks are properly formatted as JSON.
This script will identify problematic notebooks and can attempt to fix common issues.
"""

import os
import sys
import json
import nbformat
from pathlib import Path

def check_notebook(path):
    """Check if a notebook is valid JSON and a valid notebook format."""
    try:
        # First check if it's valid JSON
        with open(path, 'r', encoding='utf-8') as f:
            json_content = json.load(f)
        
        # Then check if it's a valid notebook format
        nbformat.validate(json_content)
        return True, None
    except json.JSONDecodeError as e:
        return False, f"JSON error: {str(e)}"
    except nbformat.ValidationError as e:
        return False, f"Notebook validation error: {str(e)}"
    except Exception as e:
        return False, f"Unknown error: {str(e)}"

def attempt_fix_notebook(path):
    """Attempt to fix common notebook formatting issues."""
    try:
        # Read the file as text
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Try to find the JSON content (sometimes there's leading/trailing whitespace or other text)
        try:
            # Look for the opening bracket of JSON content
            start_idx = content.find('{')
            if start_idx > 0:
                content = content[start_idx:]
            
            # Check if JSON is complete and valid
            json_content = json.loads(content)
            
            # If we get here, we found valid JSON - save it back
            with open(path, 'w', encoding='utf-8') as f:
                json.dump(json_content, f, indent=1)
            
            return True
        except json.JSONDecodeError:
            # More complex issues
            print(f"Could not automatically fix {path}")
            return False
    except Exception as e:
        print(f"Error attempting to fix {path}: {str(e)}")
        return False

def main():
    # Check all ipynb files in the current directory and subdirectories
    problematic_files = []
    
    # Get all notebook files
    notebook_files = list(Path('.').glob('**/*.ipynb'))
    print(f"Found {len(notebook_files)} notebook files to check.")
    
    for path in notebook_files:
        path_str = str(path)
        print(f"Checking {path_str}...", end=' ')
        valid, error = check_notebook(path_str)
        
        if valid:
            print("✓ Valid")
        else:
            print(f"✗ Invalid - {error}")
            problematic_files.append((path_str, error))
    
    # Report results
    if problematic_files:
        print("\nProblematic notebook files:")
        for path, error in problematic_files:
            print(f"- {path}: {error}")
        
        # Ask if we should attempt to fix them
        if input("\nAttempt to fix problematic files? (y/n): ").lower() == 'y':
            fixed_count = 0
            for path, _ in problematic_files:
                print(f"Attempting to fix {path}...", end=' ')
                if attempt_fix_notebook(path):
                    print("Fixed!")
                    fixed_count += 1
                else:
                    print("Could not fix automatically.")
            
            print(f"\nFixed {fixed_count} out of {len(problematic_files)} problematic files.")
            
            if fixed_count < len(problematic_files):
                print("\nFor notebooks that couldn't be fixed automatically, you may need to:")
                print("1. Open them in a text editor and look for obvious issues like extra text")
                print("2. Create new notebooks and copy over the content")
                print("3. Use the template.ipynb as a base and rebuild the content")
    else:
        print("\nAll notebook files are valid! ✓")

if __name__ == "__main__":
    main()
