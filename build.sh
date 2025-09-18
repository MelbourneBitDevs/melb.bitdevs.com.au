#!/bin/bash

# Build script for BitDevs Melbourne site
# Converts markdown posts to HTML using pandoc and formats with prettier

echo "🚀 Building BitDevs Melbourne site..."

# Create posts directory if it doesn't exist
mkdir -p posts

# Convert all markdown posts
echo "📝 Converting markdown posts to HTML..."
for md_file in _posts/*.md; do
    if [[ -f "$md_file" ]]; then
        # Extract filename without path and extension
        filename=$(basename "$md_file" .md)
        
        # Skip template file
        if [[ "$filename" == "2023-01-01-template" ]]; then
            continue
        fi
        
        echo "   Converting $filename.md..."
        
        # Extract title and date from frontmatter
        title=$(grep '^title:' "$md_file" | sed 's/title: *"\?\([^"]*\)"\?/\1/')
        date=$(grep '^date:' "$md_file" | sed 's/date: *"\?\([^"]*\)"\?.*/\1/' | cut -d' ' -f1)
        
        # Fallback if no frontmatter found
        if [[ -z "$title" ]]; then
            title="$filename"
        fi
        if [[ -z "$date" ]]; then
            date="${filename%%-*}-${filename#*-}"
        fi
        
        # Convert with pandoc using our template
        pandoc "$md_file" \
            --template=template.html \
            --metadata title="$title" \
            --metadata date="$date" \
            -o "posts/$filename.html"
    fi
done

# Generate post list for JavaScript files
echo "📋 Generating post list..."
python3 << 'EOF'
import os
import glob
import json
import re
from datetime import datetime

posts = []
for md_file in glob.glob('_posts/*.md'):
    filename = os.path.basename(md_file)[:-3]  # Remove .md
    if filename == '2023-01-01-template':
        continue
        
    # Extract title and date from frontmatter
    with open(md_file, 'r') as f:
        content = f.read()
    
    title_match = re.search(r'^title:\s*["\']?([^"\']*)["\']?', content, re.MULTILINE)
    date_match = re.search(r'^date:\s*["\']?([^"\']*)["\']?', content, re.MULTILINE)
    
    if title_match:
        title = title_match.group(1).strip()
    else:
        title = filename
        
    if date_match:
        date_str = date_match.group(1).split()[0]  # Take just the date part
    else:
        date_str = filename[:10]  # YYYY-MM-DD from filename
    
    posts.append({
        'date': date_str,
        'title': title,
        'url': f'posts/{filename}.html'
    })

# Sort by date descending
posts.sort(key=lambda x: x['date'], reverse=True)

# Update index.html (all posts)
with open('index.html', 'r') as f:
    content = f.read()

js_all_posts = json.dumps(posts, indent=8)
pattern = r'const allPosts = \[.*?\];'
replacement = f'const allPosts = {js_all_posts};'
content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open('index.html', 'w') as f:
    f.write(content)

print(f"Generated {len(posts)} posts")
EOF

# Format all HTML files with prettier
echo "✨ Formatting with prettier..."
if command -v npx >/dev/null 2>&1; then
    npx prettier --write "*.html" "posts/*.html" 2>/dev/null || echo "   Prettier formatting skipped (not available)"
else
    echo "   Prettier not available, skipping formatting"
fi

# Clean up any temp files
rm -f posts.html 2>/dev/null

echo "✅ Build complete! Generated $(ls posts/*.html | wc -l) posts"
echo "📁 Open index.html in a browser to view the site"