# BitDevs Melbourne - Static Site

A minimal, fast static website built with plain HTML and Tailwind CSS.

## Quick Start

1. **Add a new post**: Create a markdown file in `../_posts/` with format `YYYY-MM-DD-Title.md`
2. **Build the site**: Run `./build.sh`
3. **Deploy**: Upload all files to your web server

## Build System

The `build.sh` script:

- Converts markdown posts to HTML using pandoc
- Uses a simple HTML template for consistent styling

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

### Item 1

Link 1

Link 2

...
```

Then run `cd _posts && python3 create-links.py` to create pretty markdown links.

## Requirements

- pandoc (for markdown to HTML conversion)
- python3 (for post listing generation)
