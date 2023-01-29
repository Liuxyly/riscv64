from ubuntu:jammy

ENV RISCV=/usr/local/riscv64

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${RISCV}/bin

RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests\
        git ca-certificates autoconf automake autotools-dev curl libmpc-dev \
        libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf \
        libtool patchutils bc zlib1g-dev libexpat-dev device-tree-compiler \
        python3 libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev libsdl1.2-dev ninja-build && \
    apt-get autoclean && \
    mkdir -p $RISCV /src

RUN cd /src && \
    git clone https://github.com/riscv/riscv-gnu-toolchain && \
    cd riscv-gnu-toolchain && \
    mkdir -p build && \
    cd build && \
    ../configure --prefix=$RISCV --enable-qemu-system --with-isa-spec=2.2 --with-sim=qemu --without-system-zlib && \
    make -j12 && \
    make install && \
    cd .. && \
    rm -rf build

EXPOSE 1234
