# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Static website for ИП "Мороз Н.К." (a Russian sole proprietorship selling electrical equipment). Built with Jekyll 3.8 and the Minima theme, deployed to GitHub Pages via the `gh-pages` branch.

## Commands

**Local development (with live reload):**
```bash
./run.sh
# Site available at http://localhost:4000
```

**Build only (outputs to `site/_site/`):**
```bash
./build.sh
```

Both scripts use Docker Compose. The `run.sh` script forces a full rebuild with `--force-recreate`. The `builder` service mounts `./site` as a volume for incremental builds; the `site` service copies files into the image.

## Architecture

All Jekyll source lives in `site/`. The build output goes to `site/_site/` (git-ignored).

**Key directories:**
- `site/_items/` — Jekyll collection of product pages. Each `.md` file has frontmatter: `layout: item`, `short_title`, `title`, `photo` (path to image), `order` (display order).
- `site/_layouts/` — custom layouts: `item.html` (product page with optional photo), `items.html` (product list using `item-list.html` include), `home.html`, `page.html`, `post.html`, all extending `default.html`.
- `site/_includes/` — partials: `header.html`, `footer.html`, `head.html`, `contacts.html`, `item-list.html`, `social.html`.
- `site/assets/` — `style.css` (custom CSS overriding Minima), `photo/` (product images).

**Site config** (`site/_config.yml`): contact info (email, phone, postal address) is stored as site variables accessed in templates via `{{ site.email }}`, `{{ site.phone }}`, etc. The `items` collection has `output: true` so each item gets its own page at `/items/<slug>`.

**Deployment:** GitHub Actions (`.github/workflows/release.yml`) builds the site on every push/PR and deploys to the `gh-pages` branch on pushes to `master`.

## Adding a product

1. Add a photo to `site/assets/photo/<name>.jpeg`.
2. Create `site/_items/<slug>.md` with the appropriate frontmatter and Markdown body.
3. The item will automatically appear in the items list (`/items/`) and get its own page.
