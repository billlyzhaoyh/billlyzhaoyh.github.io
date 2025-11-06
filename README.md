# Personal Website

Built with Jekyll and hosted on GitHub Pages using the minimal theme.

## Structure

### Collections

The site has three content collections:

- **Musings** (`_musings/`) - Long-form thoughts and reflections
- **Tidbits** (`_tidbits/`) - Short-form thoughts and quick insights
- **Hacks** (`_hacks/`) - Projects and technical explorations

### Adding New Posts

Create new posts in the appropriate collection directory with this format:

```markdown
---
title: "Your Post Title"
date: 2025-01-15
tags: [AI agent, machine learning, python]
excerpt: "A brief description that appears in listings and SEO."
---

Your content goes here...
```

#### Filename Convention
Posts should be named: `YYYY-MM-DD-title-with-dashes.md`

Example: `2025-01-15-my-new-post.md`

### Tags for SEO

Tags in the frontmatter serve multiple purposes:
1. **Organization** - Categorize your content
2. **SEO** - Jekyll's SEO plugin uses tags as meta keywords
3. **Discoverability** - Help readers find related content

Common tags you might use:
- `AI agent`
- `machine learning`
- `web development`
- `productivity`
- `python`, `javascript`, etc.

### Local Development

```bash
bundle install
bundle exec jekyll serve
```

Visit http://127.0.0.1:4000 to preview your site.

### Deployment

Push to the `main` branch and GitHub Pages will automatically build and deploy your site.

## File Structure

```
.
├── _config.yml              # Site configuration
├── _layouts/
│   ├── default.html         # Main layout with navigation
│   └── post.html           # Post layout with tags display
├── _musings/               # Long-form posts
├── _tidbits/               # Short-form posts
├── _hacks/                 # Project posts
├── musings.md              # Musings index page
├── tidbits.md              # Tidbits index page
├── hacks.md                # Hacks index page
├── about.md                # About page
├── contact.md              # Contact page
└── index.md                # Homepage
```

## Navigation

The navigation menu is in `_layouts/default.html` and automatically highlights the active page/section.
