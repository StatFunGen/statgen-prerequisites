
# Setting Up Jupyter Book with GitHub Pages for ColocBoost manuscript


## 1. Installation and Environment Setup

Install Jupyter Book and related tools

```bash
pixi global install jupyter-book ghp-import
```

## 2. Set Up Book Structure

The created template will have:
- `_config.yml`: Configuration for the book
- `_toc.yml`: Table of contents structure
- Sample content files

## 3. Build the Book


```bash
jupyter-book build . --config website/_config.yml --toc website/_toc.yml
```

This will generate the HTML files in the `_build/html` directory.

## 4. Deploy to GitHub Pages

Use `ghp-import` to publish your book:

```bash
ghp-import -n -p -f _build/html
```

This will:
- Copy the contents of `_build/html` to a branch called `gh-pages`
- Push this branch to GitHub
- Configure it as a GitHub Pages source

## 5. Set Up GitHub Pages in Repository Settings

1. Go to your repository on GitHub
2. Navigate to Settings > Pages
3. Ensure the source is set to the `gh-pages` branch and the folder is `/ (root)`
4. Save the settings

The site should be live at: https://statfungen.github.io/statgen-prerequisites/

## 6. Optional: Set Up GitHub Actions for Automatic Deployment

Create a file `.github/workflows/deploy-book.yml`:

```yaml
name: deploy-book

on:
  push:
    branches:
      - main

jobs:
  deploy-book:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2

    - name: Set up Python 3.9
      uses: actions/setup-python@v2
      with:
        python-version: 3.9

    - name: Install dependencies
      run: |
        pip install jupyter-book
        pip install ghp-import

    - name: Build the book
      run: |
        jupyter-book build . --config website/_config.yml --toc website/_toc.yml

    - name: GitHub Pages action
      uses: peaceiris/actions-gh-pages@v3.6.1
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        publish_dir: ./_build/html
```

This will automatically rebuild and publish your book whenever you push changes to the main branch.
