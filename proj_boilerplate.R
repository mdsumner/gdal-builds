label <- c("6.0.0", "6.1.0", "6.1.1", "6.2.0", "6.2.1", "6.3.0", "6.3.1",
"6.3.2", "7.0.0", "7.0.1", "7.1.0", "7.1.1", "7.2.0", "7.2.1",
"8.0.0", "8.0.1", "8.1.0", "8.1.1", "8.2.0", "8.2.1", "9.0.0",
"9.0.1", "9.1.0", "9.1.1", "9.2.0", "9.2.1", "9.3.0", "9.3.1", "latest", "devel")

yamlfile_path   <- ".github/workflows/docker-%s.yml"
dockerfile_path <- "dockerfiles/proj_%s.Dockerfile"

yaml_text <-
"name: Docker Image CI - %s
on:
  workflow_dispatch: null
  push:
    paths: ['dockerfiles/proj_%s.Dockerfile', '.github/workflows/docker-%s.yml', 'install_cmake_version_proj.sh']
jobs:
  build:
    runs-on: ubuntu-latest
    permissions: write-all
    steps:
      - uses: actions/checkout@v3
      - name: Login to GitHub Container Registry
        if: github.repository == 'mdsumner/proj-builds'
        uses: docker/login-action@v1
        with:
          registry: ghcr.io
          username: ${{github.actor}}
          password: ${{secrets.GITHUB_TOKEN}}
      - name: Build the (%s) Docker image
        if: github.repository == 'mdsumner/proj-builds'
        run: docker build -f dockerfiles/proj_%s.Dockerfile . --tag ghcr.io/mdsumner/proj-builds:%s
      - name: Publish (%s)
        if: github.repository == 'mdsumner/proj-builds'
        run: docker push ghcr.io/mdsumner/proj-builds:%s
"

docker_text <-
'FROM rocker/r2u:22.04

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \\
      org.opencontainers.image.source="https://github.com/mdsumner/proj-builds" \\
      org.opencontainers.image.vendor="Hypertidy Project" \\
      org.opencontainers.image.description="A build of PROJ %s for use on ubuntu" \\
      org.opencontainers.image.authors="Michael Sumner <mdsumner@gmail.com>"

ENV PROJ_VERSION=%s

COPY install_cmake_version_proj.sh /scripts/install_cmake_version_proj.sh

RUN /scripts/install_cmake_version_proj.sh
'

tx1 <- sprintf(docker_text, label, label)
tx2 <- sprintf(yaml_text, label, label, label, label, label, label, label, label)
p1 <- sprintf(dockerfile_path, label)
p2 <- sprintf(yamlfile_path, label)
for (i in seq_along(label)) {
    writeLines(tx1[i], p1[i])
    writeLines(tx2[i], p2[i])

}
