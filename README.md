# base

[![CI](https://github.com/suckowbiz/docker-base/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/suckowbiz/docker-base/actions/workflows/build-and-push.yml)

The parent Images for all my Container Images. It contains a core entrypoint script that is common for all child Images.

- Base Image for CLI apps [./base](./base)
- Base Image for GUI apps [./av](./av)

## Build

```bash
docker-compose build
```

## License

Licensed under MIT to allow doing anything with proper attribution and without warranty.

## Code Conventions

- Shell <https://google.github.io/styleguide/shell.xml>
- Docker <https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/>
