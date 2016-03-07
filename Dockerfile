FROM debian:sid

# Might want to bust cache here if looking to upgrade the distribution
RUN apt-get update && apt-get upgrade -y

# Install build dependencies
RUN apt-get install -y cmake \
                       checkinstall \
                       curl \
                       make \
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
                       libgdcm2-dev \
                       libvtkgdcm2-dev \
                       libinsighttoolkit4-dev \
                       libvxl1-dev \
                       && apt-get clean

# Install camp
RUN curl -sSL https://github.com/fw4spl-org/camp/archive/0.7.1.4.tar.gz | tar -xzC /tmp \
              && cd /tmp/camp-0.7.1.4 \
              && mkdir build && cd build \
              && cmake -DBUILD_SHARED_LIBS=ON -DBUILD_TEST=OFF .. \
              && make \
              && checkinstall -Dy --nodoc --pkgname=camp --pkgversion=0.7.1.4

ENV FW4SPL_HOME=/home/fw4spl/
ENV FW4SPL_VERSION=0.11.0
ENV FW4SPL_BUILDTYPE=Release

# Create workspace
RUN bash -c "mkdir -p $FW4SPL_HOME/{Build,Src,Install}"

# Clone fw4spl
RUN cd $FW4SPL_HOME/Src && git clone --depth=1 -b fw4spl_$FW4SPL_VERSION https://github.com/fw4spl-org/fw4spl.git

# Patch fw4spl
COPY system_lib.patch /tmp/system_lib.patch
RUN cd $FW4SPL_HOME/Src/fw4spl && git apply /tmp/system_lib.patch

WORKDIR $FW4SPL_HOME/Build

# Configure project
RUN cmake $FW4SPL_HOME/Src/fw4spl \
          -DCMAKE_INSTALL_PREFIX=$FW4SPL_HOME/Install \
          -DCMAKE_BUILD_TYPE=$FW4SPL_BUILDTYPE \
          -DBUILD_TESTS=OFF \
          -DUSE_SYSTEM_LIB=ON \
          -DBUILD_DOCUMENTATION=OFF

RUN make VRRender

CMD ["/bin/bash"]
