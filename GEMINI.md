# GEMINI.md

This file provides workspace context, architecture guidelines, and run/build instructions for Gemini CLI when working with this repository.

## Project Overview

This repository hosts the static website for **ИП "Мороз Н.К."** (a Russian sole proprietorship selling electrical equipment such as electro-osmotic drying devices).
- **Core Technology**: Jekyll 3.8.6, Ruby, and the Minima theme.
- **Plugins**: `jekyll-feed` (RSS), `jekyll-sitemap` (Sitemap generation).
- **Local Dev Environment**: Docker / Docker Compose based.
- **Deployment**: Deployed automatically to GitHub Pages via GitHub Actions on push to `master`.

---

## Directory Structure & Architecture

All source code and content for Jekyll resides in the `site/` subdirectory.

```
/ (Project Root)
├── site/                     # Subdirectory containing the entire Jekyll site
│   ├── _config.yml           # Jekyll configuration (contacts, metadata, etc.)
│   ├── Gemfile               # Ruby gem dependencies
│   ├── _items/               # Jekyll collection containing product Markdown pages
│   ├── _includes/            # Jekyll partials (header, footer, head, etc.)
│   ├── _layouts/             # Layout templates (default, item, items, etc.)
│   ├── assets/               # CSS and images
│   │   ├── style.css         # Custom CSS overrides
│   │   └── photo/            # Product photos (JPEG format)
│   └── index.md, about.md... # Pages of the website
├── build.sh                  # Docker-based static build script
└── run.sh                    # Docker-based local development runner
```

- **Site Configuration (`site/_config.yml`)**: Contains global variables such as company email, phone numbers, postal address, and SEO defaults. Access them in templates via `{{ site.email }}`, `{{ site.phone }}`, etc.
- **Product Collection (`site/_items/`)**: Product pages are managed as a Jekyll collection called `items`. Each product file is a Markdown (`.md`) file.
- **SEO & Tracking**:
  - Automatically generates a sitemap at `/sitemap.xml` using `jekyll-sitemap`.
  - Configures Yandex Metrika (ID `110389050`) in `head.html`.
  - Layout `item.html` contains `application/ld+json` structured product schema markup.

---

## Building and Running

Since Jekyll and Ruby versions can be difficult to manage across different operating systems, the repository uses Docker Compose to containerize the build and dev environments. Both scripts automatically detect `docker-compose` (v1) or `docker compose` (v2 plugin).

### Local Development
To run the local server with live-reloading (mounts `site/` as a volume to allow writing directly to host):
```bash
./run.sh
```
- Local URL: **`http://localhost:4000`**
- *Note*: Refresh the browser manually after saving files (no Webpack-style hot reloading is configured, but the backend auto-generates changes).
- *Warning*: Changes to `site/_config.yml` require restarting `./run.sh`.

### Static Build Only
To build the site static assets into `site/_site/`:
```bash
./build.sh
```

---

## Development Conventions

### Adding or Updating a Product
When adding a new product:
1. **Prepare Photo**: Place a high-quality product photo in `site/assets/photo/<name>.jpeg`.
2. **Create Markdown File**: Place a new markdown file in `site/_items/<slug>.md`.
3. **Configure Frontmatter**: The markdown file **must** contain Jekyll frontmatter at the top:
   ```yaml
   ---
   layout: item
   categories: items
   short_title: "<Short Name, e.g., УЭСИ>"
   title: "<Full detailed product title/name>"
   photo: /assets/photo/<name>.jpeg
   order: <integer display order>
   description: >-
     <SEO description used as a meta tag and in Product Structured Data schema>
   ---
   ```
4. **Body Content**: Use standard Markdown for sections like `# НАЗНАЧЕНИЕ` and `# ТЕХНИЧЕСКИЕ ХАРАКТЕРИСТИКИ`.
5. The product will automatically appear in `/items/` list and get its own canonical `/items/<slug>` URL.

### Modifying Company Info
If contact info (phone, email, address) changes:
- Edit the corresponding fields in `site/_config.yml` under `phone`, `phone_plain`, `email`, or `post`. Do not hardcode these values in the layouts or includes.

### Deployment Strategy
- **Deploy Trigger**: Automatically on any push or merge to the `master` branch.
- **Platform**: GitHub Actions runs `build.sh` as `sudo` to generate the artifact, which is then deployed to GitHub Pages via `actions/deploy-pages`.
