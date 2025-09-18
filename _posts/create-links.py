### Searches for
###
### ### Item Name
### LINK
###
### markdown and stylizes (links properly, etc)

import re
from pathlib import Path

def clean_line(line):
    """Remove extra formatting characters and whitespace."""
    return re.sub(r'\*+', '', line).strip()

def process_markdown_file(file_path):
    """
    Process a markdown file to format links properly.
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        # Split content into lines
        lines = content.split('\n')
        processed_lines = []
        current_heading = None
        urls_for_heading = []

        i = 0
        while i < len(lines):
            line = clean_line(lines[i])
            
            # Skip empty lines
            if not line:
                processed_lines.append('')
                i += 1
                continue

            # If line is a heading
            if line.startswith('#'):
                # Process previous heading's URLs if they exist
                if current_heading and urls_for_heading:
                    processed_lines.pop()  # Remove the last heading line
                    processed_lines.append(format_heading_with_links(current_heading, urls_for_heading))
                
                # Check if this heading is already formatted as a link
                if '[' in line and '](' in line:
                    processed_lines.append(line)
                else:
                    current_heading = line
                    urls_for_heading = []
                    processed_lines.append(line)

                # Look ahead for URLs
                next_idx = i + 1
                while next_idx < len(lines) and not clean_line(lines[next_idx]).startswith('#'):
                    next_line = clean_line(lines[next_idx])
                    if next_line.startswith('http'):
                        urls_for_heading.append(next_line)
                    next_idx += 1
                
                if urls_for_heading:
                    processed_lines.pop()  # Remove the unformatted heading
                    processed_lines.append(format_heading_with_links(current_heading, urls_for_heading))
                    i = next_idx - 1  # Skip the URLs we've processed
                
                current_heading = None
                urls_for_heading = []
            else:
                # If it's not a URL and not a heading, keep it as is
                if not line.startswith('http'):
                    processed_lines.append(lines[i])
            
            i += 1

        # Join lines back together
        processed_content = '\n'.join(processed_lines)

        # Write the processed content back to the file
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(processed_content)

        return True

    except Exception as e:
        print(f"Error processing file {file_path}: {str(e)}")
        return False

def format_heading_with_links(heading, urls):
    """
    Format a heading with its associated URLs into proper markdown links.
    """
    # Extract heading text (remove #s and leading/trailing whitespace)
    heading_text = re.sub(r'^#+\s*', '', heading).strip()
    
    new_text = f"### {heading_text}\n"

    for url in urls:
        new_text += f"- [{url}]({url})\n"

    return new_text

def process_directory(directory_path):
    """
    Process all markdown files in a directory.
    """
    directory = Path(directory_path)
    markdown_files = list(directory.glob('*.md'))
    
    if not markdown_files:
        print(f"No markdown files found in {directory_path}")
        return

    for file_path in markdown_files:
        print(f"Processing {file_path}...")
        if process_markdown_file(file_path):
            print(f"Successfully processed {file_path}")
        else:
            print(f"Failed to process {file_path}")

# Example usage
if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        directory_path = sys.argv[1]
    else:
        directory_path = "."  # Current directory if no path provided
        
    process_directory(directory_path)
