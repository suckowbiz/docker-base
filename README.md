# base

![Docker Hub Publish](https://github.com/suckowbiz/docker-base/actions/workflows/build-and-push.yml/badge.svg?event=schedule)

The parent Docker Images for all my Dockerfiles. It contains a core entrypoint script that is common for all child Docker Images.

- Base Dockerimage for CLI apps [./base](./base)
- Base Dockerimage for GUI apps [./av](./av)

## Build

```bash
docker-compose build
```

## License

Licensed under MIT to allow doing anything with proper attribution and without warranty.

## Code Conventions

- Shell <https://google.github.io/styleguide/shell.xml>
- Docker <https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/>