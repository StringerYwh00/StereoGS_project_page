# StereoGS — Project Page

Official project page for **StereoGS: Sparse-View 3D Gaussian Splatting via Stereo Priors** (ECCV 2026).

- Paper: [PDF](static/pdfs/stereogs_paper.pdf) (replace with your compiled `main.pdf`)
- Supplementary: [PDF](static/pdfs/stereogs_supp.pdf)
- Code: <https://github.com/StringerYwh00/StereoGS>

This page is built on top of the [Academic Project Page Template](https://github.com/eliahuhorwitz/Academic-project-page-template).

## File layout

```
Academic-project-page-template/
├── index.html              # main content
├── README.md
└── static/
    ├── css/
    │   ├── bulma.min.css
    │   ├── bulma-carousel.min.css
    │   ├── bulma-slider.min.css
    │   ├── fontawesome.all.min.css
    │   └── index.css       # base template styles + StereoGS custom styles
    ├── js/
    │   ├── bulma-carousel.min.js
    │   ├── bulma-slider.min.js
    │   ├── fontawesome.all.min.js
    │   └── index.js
    ├── images/             # all figures used in the page (jpg / svg / ico)
    └── pdfs/               # paper.pdf / supp.pdf (placeholders)
```

## How to preview locally

```bash
cd Academic-project-page-template
python3 -m http.server 8000
# open http://127.0.0.1:8000
```

## How to deploy to GitHub Pages

1. Create a repo (e.g. `stereogs.github.io`).
2. Push everything in this folder to the `main` branch.
3. In *Settings → Pages*, choose *Deploy from a branch → `main` / root*.
4. (Optional) Add a `CNAME` file if you use a custom domain.

## How to update

| To change…                     | Edit…                                                    |
| ------------------------------ | -------------------------------------------------------- |
| Title / authors / venue        | `index.html` → `<section class="hero">`                  |
| Abstract text                  | `index.html` → `<section class="section hero is-light">` (the abstract block) |
| Method descriptions            | `index.html` → `<section class="section method-section">` |
| Quantitative numbers           | `index.html` → `<section class="section quant-section">` |
| BibTeX                         | `index.html` → `<section id="BibTeX">`                   |
| Page colors / brand gradient   | `static/css/index.css` → `/* StereoGS Custom Styles */`   |
| Favicon                        | Replace `static/images/favicon.ico` and `favicon.svg`    |
| Social preview (OG image)      | Replace `static/images/overview.jpg` (1200×630+)         |
| Add a new figure               | Put the file in `static/images/`, add an `<img>` tag     |

## Re-converting PDF figures to JPG

The figures in `static/images/` are JPGs converted from PDF using macOS `sips`:

```bash
cd <repo-root>/paper_latex/StereoGS/fig
sips -s format jpeg -s formatOptions 90 -Z 1800 some_figure.pdf \
     --out <repo-root>/project_page/Academic-project-page-template/static/images/some_figure.jpg
```

`-Z 1800` sets the maximum edge to 1800 px while keeping aspect ratio.

## License

This website is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).
