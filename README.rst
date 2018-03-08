Docker Ffmpeg Compiler 
======================

Docker Ffmpeg Compiler is a zero-set-up solution to install a fully featured ffmpeg binary on your linux system.
If you want to cut right to the chase and install ffmpeg and ffprobe, all at once, simply:

.. code-block:: bash

    bash -c "$(wget https://raw.githubusercontent.com/srwareham/docker-ffmpeg-compiler/master/install.sh -O -)"
    
or

.. code-block:: bash

    bash -c "$(curl -fsSL https://raw.githubusercontent.com/srwareham/docker-ffmpeg-compiler/master/install.sh)"

The above downloads and executes a script that:

#. Downloads a Dockerfile 
#. Build a Docker image, which itself compiles all codecs and ffmpeg (warning, this takes awhile)
#. Copies static binaries for ffmpeg and ffprobe to the current working directory (with the uid / gid of the calling user)
#. Deletes the ~1.2GB Docker image used to compile
#. Leaves behind only the two static binaries mentioned above (each ~22MB)

Codecs and Features
===================

Video
-----

- `x264 <https://www.videolan.org/developers/x264.html>`_
- `x265 <http://x265.org/>`_
- `Theora <https://www.theora.org/>`_ 
- `VP8 <http://www.webmproject.org/>`_ / `VP9 <http://www.webmproject.org/vp9/>`_

Audio
-----
- `fdk-aac <https://github.com/mstorsjo/fdk-aac>`_
- `lame (mp3) <http://lame.sourceforge.net/>`_
- `Vorbis <http://www.vorbis.com/>`_
- `Opus <https://www.opus-codec.org/>`_
 
Other
-----

- `libass <https://github.com/libass/libass>`_
- `freetype <http://www.freetype.org/>`_

Dependencies
============

- Docker: `installation instructions <https://docs.docker.com/engine/installation/>`_
- The install script assumes you have set up docker to be run with `non-root access <https://docs.docker.com/engine/installation/linux/ubuntulinux/#create-a-docker-group>`_. If you would rather not configure this, simply download the install.sh script and execute it as root (you'll then need to manually chown the binaries to that of your user account)

Why Use Docker Ffmpeg Compiler?
===============================

Ffmpeg and many of its constituent components use the GPL license. With only these features enabled, ffmpeg can be distributed in binary form.
The problem becomes that many of its most desired codecs do not use a license that is compatible with the GPL, which means a "fully featured" ffmpeg
cannot be distributed in binary form. If you have googled around to try to find such a binary distribution, you've almost certainly stumbled across 
*the* response: "build it yourself." 

Docker Ffmpeg Compiler steps in to do this for you! Rather than distribute a compiled version of ffmpeg, Docker Ffmpeg Compiler contains instructions
to fetch and compile the source code for ffmpeg and the most popular codecs--no binaries distributed, all licenses respected.

Main Benefits
-------------
 
#. **Beginner friendly:** With Docker Ffmpeg Compiler, no compilation experience is necessary, you simply run one script and you get the ffmpeg version you want! 
#. **Ease of use:** Even if you have experience compiling, finding the source for all the codecs, configuring their compilation with the right flags, and then compiling ffmpeg with all the right flags is a pain
#. **No clutter**: The large number files downloaded and compiled for building ffmpeg are restricted to a docker namespace
#. **Significant size savings:** The above files used to compile ffmpeg end up requiring ~1.2 GB. Using Docker Ffmpeg Compiler allows you to restore this space quickly and easily
#. **Portablity:** You can run this code on any linux distribution with docker and it will work. If for some reason the static binary does not work on your system, you can always fire up another docker container to hold the binary and use it to do any encoding

Notes
=====
The libopus-dev version that comes with ubuntu 16.04 seems to be incompatible with this script, as such the ubuntu version is pinned to 14.04. I may look into this further if needed.

Contributing
============

Contributions are welcome! If you would like to add a feature, improve this README, or improve existing code submit a pull request!
