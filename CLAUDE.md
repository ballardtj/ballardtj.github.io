# Adding a New Blog Post

Follow these steps each time a new blog post is added. The post text should be kept exactly as provided — do not edit, rephrase, or rewrite any of the content.

## 1. Prepare the image

- Place the image in `assets/images/`.
- Rename if needed (remove spaces, "copy" suffixes, etc.) to a clean filename like `my_image_name.png`.

## 2. Create the blog post HTML

- Create a new file in `blog/` with a descriptive slug, e.g. `blog/my-post-slug.html`.
- Use an existing recent post (e.g. `blog/copsoq-gender-differences.html`) as a template.
- Fill in:
  - `<title>` — post title + " — Tim Ballard, PhD"
  - `<meta name="description">` — short summary for SEO
  - `og:title`, `og:description`, `og:image`, `og:url` — Open Graph meta tags
  - Post tags in `<div class="post-tags">` (e.g. Mental Health, Psychosocial Safety)
  - `<h1>` — post title
  - `<div class="post-meta">` — date (e.g. "31 March 2026") and estimated read time (e.g. "3 min read")
  - Post content in `<div class="post-content">` — keep text exactly as provided, just wrap in appropriate HTML tags (`<p>`, `<ul>/<li>`, `<strong>`, `<em>`, `<a>`, etc.)
  - Image in a `<div class="post-figure">` with descriptive alt text
- Post navigation (`<div class="post-nav">`):
  - Left link: `← All posts` pointing to `/blog.html` (this is the newest post)
  - Right link: `Next post →` pointing to the previous newest post

## 3. Update the previous newest post's navigation

- Open the blog post that was previously the newest (the one this new post's "Next post →" links to).
- Change its left nav link from `← All posts` / `/blog.html` to `← Previous post` / `/blog/new-post-slug.html`.

## 4. Update `blog.html`

- Add a new post card at the **top** of `<div class="blog-grid">`, before all existing cards.
- Format: single `<a>` element with class `post-card` and appropriate `data-tags` (lowercase, hyphenated, e.g. `mental-health,psychosocial-safety`).
- Include: thumbnail image, tags, title (`<h3>`), short excerpt, and meta (month/year + read time, e.g. "Mar 2026 · 3 min").

## 5. Update `sitemap.xml`

- Add a new `<url><loc>` entry for the post before the existing blog post entries.

## Reference: available `data-tags` for filtering

These are the current filter categories in `blog.html`: `mental-health`, `working-hours`, `job-satisfaction`, `psychosocial-safety`, `retention`, `methods`.
