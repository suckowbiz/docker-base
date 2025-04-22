FROM suckowbiz/base
LABEL maintainer="Tobias Suckow <tobias@suckow.biz>"

# A/V rendering requires group membership to access drm and load drivers.
ENV GIVEN_USER_ADDITIONAL_GROUPS="audio,video"

RUN apt-get update && \
    apt-get install --quiet --quiet --no-install-recommends \
    # Advanced Linux Sound Architecture
    alsa-utils \
    dbus-x11 \
    # Light Themes (Ambiance and Radiance)
    light-themes \
    # Layout and rendering of internationalized text
    libpango-1.0-0 \
    # translates GTK+ widgets signals to event sounds. Both versions required.
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
     # GStreamer backend for libcanberra
    libcanberra-gstreamer \
    # PulseAudio backend for libcanberra
    libcanberra-pulse \
    #libgtk2.0-0t64 \
    vim \
    # desktop integration utilities from freedesktop.org
    xdg-utils \
    #  X.Org X server
    xorg
