---
layout: default
title: Musings
---

# Musings

Longer form thoughts and reflections.

<div class="post-list">
{% for post in site.musings reversed %}
  <div class="post-item">
    <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
    <p class="post-meta">{{ post.date | date: "%B %d, %Y" }}</p>
    {% if post.excerpt %}
      <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
    {% endif %}
    {% if post.tags %}
      <div class="tags-inline">
        {% for tag in post.tags %}
          <span class="tag-small">{{ tag }}</span>
        {% endfor %}
      </div>
    {% endif %}
  </div>
{% endfor %}
</div>

<style>
  .post-list {
    margin-top: 2em;
  }

  .post-item {
    margin-bottom: 2em;
    padding-bottom: 1.5em;
    border-bottom: 1px solid #e8e8e8;
  }

  .post-item:last-child {
    border-bottom: none;
  }

  .post-item h3 {
    margin-bottom: 0.3em;
  }

  .post-item h3 a {
    color: #222;
    text-decoration: none;
  }

  .post-item h3 a:hover {
    color: #267CB9;
  }

  .post-meta {
    color: #666;
    font-size: 0.9em;
    margin-bottom: 0.5em;
  }

  .tags-inline {
    margin-top: 0.8em;
  }

  .tag-small {
    display: inline-block;
    background-color: #f0f0f0;
    padding: 3px 10px;
    margin-right: 6px;
    margin-bottom: 6px;
    border-radius: 3px;
    font-size: 0.8em;
    color: #555;
  }
</style>
