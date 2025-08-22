FROM squidfunk/mkdocs-material:latest
RUN pip install --no-cache-dir \
    mkdocs-awesome-pages-plugin \
    mkdocs-exclude \
    mkdocs-minify-plugin \
    mkdocs-git-revision-date-localized-plugin