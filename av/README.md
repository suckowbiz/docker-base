![Ubuntu Linux](https://img.shields.io/badge/tested-ubuntu-green.svg) [![](https://images.microbadger.com/badges/image/suckowbiz/base-av.svg)](https://microbadger.com/images/suckowbiz/base-av "Get your own image badge on microbadger.com")

# base-av

Common base for audio/video applications.

```
       +------+
       |      |
       | base |
       |      |
       +^-----+
        |
        |
    +---++
    |    |
    | av |
    |    |
    +-^--+
      |
      |
+-----+-------------------+
|                         |
| audio video using image |
|                         |
+-------------------------+
```

To run audio video applications this Docker Image includes packages to play sound and integrate video capabilies required for GUI based applications like e.g. a web browser.