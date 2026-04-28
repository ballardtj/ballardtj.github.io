# Adding a New Blog Post

Follow these steps each time a new blog post is added. The post text should be kept exactly as provided — do not edit, rephrase, or rewrite any of the content.

## 1. Prepare the image

- Place the image in `assets/images/`.
- Rename if needed (remove spaces, "copy" suffixes, etc.) to a clean filename like `my_image_name.png`.
- Verify the image file exists before proceeding.

## 2. Create the blog post HTML

- Create a new file in `blog/` with a descriptive slug, e.g. `blog/my-post-slug.html`.
- Use an existing recent post as a template (read one of the most recent posts in `blog/` to get the current structure).
- Fill in:
  - `<title>` — post title + " — Tim Ballard, PhD"
  - `<meta name="description">` — short summary for SEO
  - `og:title`, `og:description`, `og:image`, `og:url` — Open Graph meta tags
  - Post tags in `<div class="post-tags">` (e.g. Mental Health, Psychosocial Safety)
  - `<h1>` — post title
  - `<div class="post-meta">` — date (e.g. "28 April 2026") and estimated read time (e.g. "3 min read")
  - Post content in `<div class="post-content">` — keep text **exactly** as provided, just wrap in appropriate HTML tags (`<p>`, `<ul>/<li>`, `<strong>`, `<em>`, `<a>`, etc.)
  - Image in a `<div class="post-figure">` with descriptive alt text
- Post navigation (`<div class="post-nav">`):
  - Left link: `← All posts` pointing to `/blog.html` (this is the newest post)
  - Right link: `Next post →` pointing to the previous newest post
- Content formatting notes:
  - Do **not** change any wording. Do not rephrase, rewrite, or edit the provided text.
  - If the user says "link in comments" or similar social-media-specific language, ask which post to link to and replace that phrase with a hyperlink.
  - Numbered lists in the text (e.g. "1)", "2)", "3)") should stay as separate `<p>` tags with the numbers as-is — do not convert emoji numbers (1️⃣) to plain numbers unless told to.
  - The first line of the provided text is typically the post title — do not repeat it as a `<p>` in the post content unless it serves as an introductory sentence distinct from the `<h1>`.

## 3. Update the previous newest post's navigation

- Open the blog post that was previously the newest (the one this new post's "Next post →" links to).
- Change its left nav link from `← All posts` / `/blog.html` to `← Previous post` / `/blog/new-post-slug.html`.

## 4. Update `blog.html`

- Add a new post card at the **top** of `<div class="blog-grid">`, before all existing cards.
- Format: single `<a>` element with class `post-card` and appropriate `data-tags` (lowercase, hyphenated, e.g. `mental-health,psychosocial-safety`).
- Include: thumbnail image, tags, title (`<h3>`), short excerpt, and meta (month/year + read time, e.g. "Apr 2026 · 3 min").
- Choose `data-tags` from the available filter categories listed below. A post can have multiple tags. If the post doesn't fit any existing category, ask the user whether to add a new filter button or map to existing tags.

## 5. Update `sitemap.xml`

- Add a new `<url><loc>` entry for the post before the existing blog post entries.

## 6. Check for cross-tagging opportunities

- After adding the post, consider whether any existing posts should also receive the new post's tags (e.g. when a new filter category is added, check if older posts fit it too).
- Ask the user before adding tags to existing posts.

## Reference: available `data-tags` for filtering

These are the current filter categories in `blog.html`: `mental-health`, `working-hours`, `job-satisfaction`, `psychosocial-safety`, `retention`, `flexible-work`, `methods`.
