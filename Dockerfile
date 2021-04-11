FROM phusion/baseimage:18.04-1.0.0-amd64
MAINTAINER d3Xm <d3Xm@protonmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV TZ Europe/Stockholm

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    build-essential \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    gcc \
    ipython \
    python3-dev \
    python3-pip \
    python3-distutils \
    ruby \
    ruby-dev \
    vim \
    net-tools \
    iputils-ping \
    curl \
    wget \
    libffi-dev \
    libssl-dev \
    python-dev \
    tmux \
    glibc-source \
    strace \
    ltrace \
    nasm \
    socat \
    netcat \
    radare2 \
    gdb \
    gdb-multiarch \
    git \
    patchelf \
    gawk \
    file \
    qemu \
    bison --fix-missing \
    gcc-multilib \
    binwalk \
    libseccomp-dev \
    libseccomp2 \
    seccomp \
    rpm2cpio cpio \
    zstd \
    tzdata --fix-missing 


RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata


RUN apt-get -f install -y \
    gcc-5-arm-linux-gnueabi \
    gcc-5-aarch64-linux-gnu \
    gcc-5-powerpc64le-linux-gnu \
    gcc-5-powerpc64-linux-gnu \
    gcc-5-powerpc-linux-gnu \
    gcc-5-mips64el-linux-gnuabi64 \
    gcc-5-mips64-linux-gnuabi64 \
    gcc-5-mipsel-linux-gnu  \
    gcc-5-mips-linux-gnu &&\
    rm -rf /var/lib/apt/list/**


RUN apt-add-repository ppa:brightbox/ruby-ng && \
    apt update &&\
    apt install -y ruby2.6 &&\
    apt install -y ruby2.6-dev



RUN ulimit -c 0
RUN gem install one_gadget 
RUN gem install seccomp-tools 



RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

RUN wget https://bootstrap.pypa.io/pip/2.7/get-pip.py  && \
	python get-pip.py && \
	rm get-pip.py


RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    -i https://pypi.doubanio.com/simple/  \
    --trusted-host pypi.doubanio.com \
    ropper \
    unicorn \
    capstone \
    ropgadget \
    pwntools \
    z3-solver \
    smmap2 \
    apscheduler \
    keystone-engine \
    angr \
    pebble \
    r2pipe

RUN pip install --upgrade setuptools && \
    pip install --no-cache-dir \
    -i https://pypi.doubanio.com/simple/  \
    --trusted-host pypi.doubanio.com \
    ropgadget \
    pwntools \
    zio \
    smmap2 \
    z3-solver \
    apscheduler && \
    pip install --upgrade pwntools

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*


RUN git clone https://github.com/niklasb/libc-database.git libc-database && \
    cd libc-database && ./get || echo "/libc-database/" > ~/.libcdb_path

RUN git clone https://github.com/d3Xm/gdb-peda-pwndbg-gef.git  && \
    cd ~/gdb-peda-pwndbg-gef && ./install.sh 

RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg &&  ./setup.sh \
    cd .. \
    mv pwndbg ~/pwndbg-src \
    echo "source ~/pwndbg-src/gdbinit.py" > ~/.gdbinit_pwndbg


WORKDIR /ctf/work/

COPY --from=skysider/glibc_builder64:2.19 /glibc/2.19/64 /glibc/2.19/64
COPY --from=skysider/glibc_builder32:2.19 /glibc/2.19/32 /glibc/2.19/32

COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64
COPY --from=skysider/glibc_builder32:2.23 /glibc/2.23/32 /glibc/2.23/32

COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64
COPY --from=skysider/glibc_builder32:2.24 /glibc/2.24/32 /glibc/2.24/32

COPY --from=skysider/glibc_builder64:2.26 /glibc/2.26/64 /glibc/2.26/64
COPY --from=skysider/glibc_builder32:2.26 /glibc/2.26/32 /glibc/2.26/32

COPY --from=skysider/glibc_builder64:2.27 /glibc/2.27/64 /glibc/2.27/64
COPY --from=skysider/glibc_builder32:2.27 /glibc/2.27/32 /glibc/2.27/32

COPY --from=skysider/glibc_builder64:2.28 /glibc/2.28/64 /glibc/2.28/64
COPY --from=skysider/glibc_builder32:2.28 /glibc/2.28/32 /glibc/2.28/32

COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64
COPY --from=skysider/glibc_builder32:2.29 /glibc/2.29/32 /glibc/2.29/32

COPY --from=skysider/glibc_builder64:2.30 /glibc/2.30/64 /glibc/2.30/64
COPY --from=skysider/glibc_builder32:2.30 /glibc/2.30/32 /glibc/2.30/32

COPY --from=skysider/glibc_builder64:2.31 /glibc/2.31/64 /glibc/2.31/64
COPY --from=skysider/glibc_builder32:2.31 /glibc/2.31/32 /glibc/2.31/32


COPY linux_server linux_server64  /ctf/
COPY tmux.conf /root/.tmux.conf
COPY checksec /usr/local/sbin
RUN chmod a+x /ctf/linux_server /ctf/linux_server64

RUN echo 'PS1="\[\e[31;1m\]\u\[\e[32;1m\]\[\e[37;2m\](\[\e[32;1m\]\w\[\e[37;1m\])\[\e[31;1m\]> \[\e[0m\]"' >> /root/.bashrc

ENTRYPOINT ["/bin/bash"]
