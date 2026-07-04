# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Static website for ИП "Мороз Н.К." (a Russian sole proprietorship selling electrical equipment). Built with Jekyll 3.8 and the Minima theme, deployed to GitHub Pages via the `gh-pages` branch.

## Commands

**Local development** (auto-regenerates on file changes; refresh browser manually):
```bash
./run.sh
# Site available at http://localhost:4000
```

**Build only** (outputs to `site/_site/`):
```bash
./build.sh
```

Both scripts use `docker-compose` (v1 standalone). Both services mount `./site` as a volume so Jekyll writes output to the local filesystem. `Gemfile.lock` is written locally on first run and git-ignored.

## Architecture

All Jekyll source lives in `site/`. The build output goes to `site/_site/` (git-ignored).

**Key directories:**
- `site/_items/` — Jekyll collection of product pages. Each `.md` file has frontmatter: `layout: item`, `short_title`, `title`, `photo` (path to image), `order` (display order), `description` (used as `<meta name="description">` and in Schema.org JSON-LD).
- `site/_layouts/` — custom layouts: `item.html` (product page with optional photo), `items.html` (product list using `item-list.html` include), `home.html`, `page.html`, `post.html`, all extending `default.html`.
- `site/_includes/` — partials: `header.html`, `footer.html`, `head.html`, `contacts.html`, `item-list.html`, `social.html`.
- `site/assets/` — `style.css` (custom CSS overriding Minima), `photo/` (product images).

**Site config** (`site/_config.yml`): contact info (email, phone, postal address) is stored as site variables accessed in templates via `{{ site.email }}`, `{{ site.phone }}`, etc. The `items` collection has `output: true` so each item gets its own page at `/items/<slug>`.

**Deployment:** GitHub Actions (`.github/workflows/release.yml`) runs `sudo ./build.sh` (uses `docker-compose` + the `builder` service), then deploys `site/_site/` to the `gh-pages` branch via `peaceiris/actions-gh-pages`. Deployment only happens on push to `master`; PRs only build. The `--exit-code-from builder` flag ensures the CI step fails if Jekyll fails.

## SEO

- **Sitemap** — generated automatically at `/sitemap.xml` by the `jekyll-sitemap` plugin.
- **Meta descriptions** — `head.html` renders `page.description` if set, otherwise falls back to `site.description` from `_config.yml`. Always set `description` in item frontmatter.
- **Structured data** — `_layouts/item.html` injects a `<script type="application/ld+json">` block with `schema.org/Product` (name, description, brand, image). No changes needed in templates when adding products; just populate `description` and `photo` in frontmatter.
- **Language** — `lang: ru` is set in `_config.yml`; `default.html` picks it up via `{{ site.lang }}`.
- **Analytics** — Yandex Metrika (ID 110389050) is loaded in `head.html` on every page.

## Adding a product

1. Add a photo to `site/assets/photo/<name>.jpeg`.
2. Create `site/_items/<slug>.md` with frontmatter including `description` and Markdown body.
3. The item will automatically appear in the items list (`/items/`) and get its own page with meta description and Schema.org markup.
