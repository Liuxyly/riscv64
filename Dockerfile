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
    ../configure --prefix=$RISCV && \
    make -j8 && \
    make install && \
    cd .. && \
    rm -rf build

RUN cd /src && \
    git clone https://github.com/riscv/riscv-isa-sim && \
    cd riscv-isa-sim && \
    ./configure --prefix=$RISCV --with-fesvr=$RISCV && \
    make -j8 && \
    make install

RUN cd /src && \
    git clone --depth 1 https://gitlab.com/barbem/qemu_for_cep.git --branch=xinul &&\
    cd qemu_for_cep &&\
    ./configure --prefix=$RISCV --target-list=riscv64-softmmu | tee $RISCV/qemu-configure-log.txt &&\
    make -j8 &&\
    make install

EXPOSE 1234
