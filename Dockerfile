FROM ubuntu

# Container for compiling ffmpeg and copying ffmpeg, ffprobe, and ffserver to the host operating system.
# If the host OS is not linux, another container could instead use the binary.

# Example build
# docker build -t ffmpeg-compiler .

# Example run
# docker run --rm -it -v $(pwd):/host ffmpeg-compiler bash -c "cp /root/bin/ffmpeg /root/bin/ffprobe /root/bin/ffserver /host && chown $(id -u):$(id -g) /host/ffmpeg && chown $(id -u):$(id -g) /host/ffprobe && chown $(id -u):$(id -g) /host/ffserver"

MAINTAINER srwareham

# Get the dependencies
RUN apt-get update \
; apt-get -y --force-yes install wget curl autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev \
; mkdir ~/ffmpeg_sources \
; sudo apt-get -y --force-yes install yasm \
; cd ~/ffmpeg_sources \
; wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz \
; tar xzvf yasm-1.3.0.tar.gz \
; cd yasm-1.3.0 \
; ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" \
; make \
; make install \
 make distclean \
; apt-get -y --force-yes install libx264-dev \
; apt-get -y --force-yes install cmake mercurial \
; cd ~/ffmpeg_sources \
; hg clone https://bitbucket.org/multicoreware/x265 \
; cd ~/ffmpeg_sources/x265/build/linux \
; PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source \
; make \
; make install \
; make distclean \
; cd ~/ffmpeg_sources \
; wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master \
; tar xzvf fdk-aac.tar.gz \
; cd mstorsjo-fdk-aac* \
; autoreconf -fiv \
; ./configure --prefix="$HOME/ffmpeg_build" --disable-shared \
; make \
; make install \
; make distclean \
; install libmp3lame \
; apt-get -y --force-yes install libmp3lame-dev \
; sudo apt-get -y --force-yes install libopus-dev \
; cd ~/ffmpeg_sources \
; wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.4.0.tar.bz2 \
; tar xjvf libvpx-1.4.0.tar.bz2 \
; cd libvpx-1.4.0 \
; PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests \
; PATH="$HOME/bin:$PATH" make \
; make install \
; make clean

#install ffmpeg
RUN cd ~/ffmpeg_sources \
; wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 \
; tar xjvf ffmpeg-snapshot.tar.bz2 \
; cd ffmpeg \
; PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-libs=-static \
  --extra-cflags=--static \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
; PATH="$HOME/bin:$PATH" make \
; make install \
; make distclean \
; hash -r
