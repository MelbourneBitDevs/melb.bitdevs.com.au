# BitDevs Melbourne - Static Site

A minimal, fast static website built with plain HTML and Tailwind CSS.

## Features

- **No dependencies**: Just HTML, CSS, and a simple build script
- **Mobile responsive**: Tailwind CSS for mobile-first design  
- **Fast**: No JavaScript frameworks, minimal JS for post listings
- **Easy content management**: Markdown posts converted to HTML

## Quick Start

1. **Add a new post**: Create a markdown file in `../_posts/` with format `YYYY-MM-DD-Title.md`
2. **Build the site**: Run `./build.sh`
3. **Deploy**: Upload all files to your web server

## Build System

The `build.sh` script:
- Converts markdown posts to HTML using pandoc
- Generates post listings automatically
- Uses a simple HTML template for consistent styling
- Copies static assets

## File Structure

```
├── index.html          # Homepage
├── about.html          # About page  
├── posts.html          # All posts listing
├── posts/              # Generated post HTML files
├── template.html       # Post template for pandoc
├── build.sh           # Build script
└── assets/            # Static assets
```

## Adding New Posts

Create markdown files in `../_posts/` with this frontmatter:

```markdown
---
layout: post
type: socratic
date: "2025-XX-XX 19:00:00"
title: "Month Year"
---

Your content here...
```

## Requirements

- pandoc (for markdown to HTML conversion)
- python3 (for post listing generation)

## Customization

- **Colors**: Edit the Tailwind config in each HTML file
- **Fonts**: Change the Google Fonts imports
- **Layout**: Modify `template.html` for post layout
- **Styling**: All styling is done with Tailwind classes