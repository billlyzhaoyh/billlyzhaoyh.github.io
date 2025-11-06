---
title: "Building a Personal Site with Jekyll and GitHub Pages"
date: 2025-01-10
tags: [web development, Jekyll, GitHub Pages, static site]
excerpt: "How I set up this personal website using Jekyll, the minimal theme, and GitHub Pages for free hosting."
---

This site is built with Jekyll and hosted on GitHub Pages - a powerful combination for creating fast, secure, and maintainable personal websites.

## Why Jekyll?

Jekyll is a static site generator that converts markdown files into HTML. Benefits include:

- **Fast**: No database queries, just static HTML
- **Secure**: No server-side code to exploit
- **Free hosting**: GitHub Pages provides free hosting with custom domains
- **Version controlled**: Your entire site is in git

## The Setup

The basic structure includes:

```
_config.yml          # Site configuration
_layouts/            # HTML templates
_musings/            # Long-form posts
_tidbits/            # Short-form posts
_hacks/              # Project posts
```

## Collections for Content Types

Instead of using a single blog, I created three collections (musings, tidbits, hacks) to organize different types of content. Each collection can have its own permalink structure and default layout.

## Tags and SEO

Using Jekyll's frontmatter, each post includes tags that help with:
- Organization and discoverability
- SEO through meta tags
- Filtering and searching content

Check out the [source code](https://github.com/billlyzhaoyh/billlyzhaoyh.github.io) to see how it all works!
