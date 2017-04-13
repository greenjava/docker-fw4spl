FROM ubuntu:16.04

ARG FW4SPL_BUILDTYPE=Release
ARG FW4SPL_BRANCH=11.0.5
ARG FW4SPL_HOME=/home/Dev/

LABEL Name="FW4SPL"
LABEL Version=$FW4SPL_BRANCH-$FW4SPL_BUILDTYPE-ubuntu_16.04
LABEL Description="FW4SPL Docker image"

# Might want to bust cache here if looking to upgrade the distribution
RUN apt-get update && apt-get upgrade -y

# Install build dependencies
RUN apt-get update && apt-get install -y checkinstall \
                                         curl \
                                         make \
                                         ninja-build \
                                         gcc \
                                         clang \
                                         git \
                                         libcppunit-dev \
                                         libglm-dev \
                                         libboost-all-dev \
                                         qtbase5-dev \
                                         qttools5-dev \
                                         qttools5-dev-tools \
                                         libvtk6-dev \
                                         libvtk6-qt-dev \
                                         libgdcm2-dev \
                                         libvtkgdcm2-dev \
                                         libinsighttoolkit4-dev \
                                         libxml2-dev \
                                         libvxl1-dev \
                                         && apt-get clean

# Install CMake 3.7
RUN curl -s https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz | tar xzf - -C /usr/local --strip-components=1 > /dev/null

# Install camp
RUN curl -sSL https://github.com/fw4spl-org/camp/archive/0.7.1.5.tar.gz | tar -xzC /tmp \
              && cd /tmp/camp-0.7.1.5 \
              && mkdir build && cd build \
              && cmake -DBUILD_SHARED_LIBS=ON -DBUILD_TEST=OFF .. \
              && make \
              && checkinstall -Dy --nodoc --pkgname=camp --pkgversion=0.7.1.5 \
              && rm -rf /tmp/camp-0.7.1.5

# Install lib-iconv
RUN curl -sSL https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz | tar -xzC /tmp \
              && cd /tmp/libiconv-1.15 \
              && ./configure \
              && make \
              && checkinstall -Dy --nodoc --pkgname=libiconv --pkgversion=1.15 \
              && rm -rf /tmp/libiconv-1.15

# Create workspace
RUN bash -c "mkdir -p $FW4SPL_HOME/{Build,Src,Install}"

# Clone fw4spl
RUN cd $FW4SPL_HOME/Src && git clone --depth 1 -b $FW4SPL_BRANCH https://github.com/fw4spl-org/fw4spl.git fw4spl

# Apply patch to fix fw4splk build with system lib
ADD patches/system_lib.diff $FW4SPL_HOME/system_lib.diff
RUN cd $FW4SPL_HOME/Src/fw4spl/ && git apply $FW4SPL_HOME/system_lib.diff 

WORKDIR $FW4SPL_HOME/Build

# Configure project
RUN cmake $FW4SPL_HOME/Src/fw4spl \
          -G Ninja \
          -DCMAKE_INSTALL_PREFIX=$FW4SPL_HOME/Install \
          -DCMAKE_BUILD_TYPE=$FW4SPL_BUILDTYPE \
          -DBUILD_TESTS=OFF \
          -DUSE_SYSTEM_LIB=ON \
          -DBUILD_DOCUMENTATION=OFF \
          -DENABLE_PCH=ON

RUN ninja all

CMD ["/bin/bash"]
