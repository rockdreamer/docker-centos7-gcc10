FROM centos:7

LABEL maintainer="Claudio Bantalouaks <cbantaloukas@ccdc.cam.ac.uk>"
# Based on conan-io/gcc_7-centos6 by
# LABEL maintainer="Luis Martinez de Bartolome <luism@jfrog.com>"

ENV PATH=/opt/rh/rh-python38/root/usr/local/bin:/opt/rh/rh-python38/root/usr/bin:/opt/rh/devtoolset-10/root/usr/bin:/opt/rh/rh-perl530/root/usr/local/bin:/opt/rh/rh-perl530/root/usr/bin:/opt/rh/rh-git29/root/usr/bin:${PATH:+:${PATH}} \
    MANPATH=/opt/rh/rh-python38/root/usr/share/man:/opt/rh/devtoolset-10/root/usr/share/man:/opt/rh/rh-perl530/root/usr/share/man:/opt/rh/rh-git29/root/usr/share/man:${MANPATH:+:${MANPATH}} \
    INFOPATH=/opt/rh/devtoolset-10/root/usr/local/share/info${INFOPATH:+:${INFOPATH}} \
    PCP_DIR=/opt/rh/devtoolset-10/root \
    PERL5LIB=/opt/rh/devtoolset-10/root/usr/lib64/perl5/vendor_perl:/opt/rh/devtoolset-10/root/usr/lib/perl5:/opt/rh/devtoolset-10/root//usr/share/perl5/vendor_perl:/opt/rh/rh-git29/root/usr/share/perl5/vendor_perl${PERL5LIB:+:${PERL5LIB}} \
    LD_LIBRARY_PATH=/opt/rh/devtoolset-10/root/usr/lib64:/opt/rh/devtoolset-10/root/usr/lib:/opt/rh/devtoolset-10/root/usr/lib64/dyninst:/opt/rh/devtoolset-10/root/usr/lib/dyninst:/opt/rh/rh-python38/root/usr/lib64:/opt/rh/rh-perl530/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} \
    PKG_CONFIG_PATH=/opt/rh/rh-python38/root/usr/lib64/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}} \
    XDG_DATA_DIRS="/opt/rh/rh-python38/root/usr/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}" \
    CXX=/opt/rh/devtoolset-10/root/usr/bin/g++ \
    CC=/opt/rh/devtoolset-10/root/usr/bin/gcc

ADD oracle-centos7-softwarecollections.repo /etc/yum.repos.d/

RUN curl -SL https://yum.oracle.com/RPM-GPG-KEY-oracle-ol7 > /etc/pki/rpm-gpg/RPM-GPG-KEY-oracle \
    && yum upgrade -y \
    && yum install -y \
       sudo \
       wget \
       make \
       glibc-devel \
       glibc-devel.i686 \
       libgcc.i686 \
       gmp-devel \
       mpfr-devel \
       libmpc-devel \
       nasm \
       m4 \
       libffi-devel \
       openssl-devel \
       openssl-static \
       pkgconfig \
       subversion \
       zlib-devel \
       xz \
       curl \
       xz-devel \
       tar \
       help2man \
       autoconf-archive \
    && yum install -y \
       devtoolset-10-toolchain \
       devtoolset-10-libasan-devel \
       devtoolset-10-liblsan-devel \
       devtoolset-10-libtsan-devel \
       devtoolset-10-libubsan-devel \
       devtoolset-10-valgrind \
       rh-python38 \
       rh-python38-python-pip \
       rh-perl530 \
       rh-git29 \
    && yum clean all \
    && wget -O /tmp/autoconf-2.69.tar.gz --no-check-certificate --quiet https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz \
    && tar -zxf /tmp/autoconf-2.69.tar.gz -C /tmp \
    && pushd /tmp/autoconf-2.69 \
    && ./configure --prefix=/usr \
    && make -s \
    && make install \
    && popd \
    && rm -rf /tmp/autoconf-2.69* \
    && wget -O /tmp/automake-1.16.tar.gz --no-check-certificate --quiet https://ftp.gnu.org/gnu/automake/automake-1.16.tar.gz \
    && tar -zxf /tmp/automake-1.16.tar.gz -C /tmp \
    && pushd /tmp/automake-1.16 \
    && ./configure --prefix=/usr \
    && sed -i "s/'none';/'reduce';/g" bin/automake.in \
    && make -s \
    && make install \
    && popd \
    && rm -rf /tmp/automake-1.16* \
    && wget -O /tmp/cmake-3.21.4-Linux-x86_64.sh --no-check-certificate --quiet 'https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4-linux-x86_64.sh' \
    && bash /tmp/cmake-3.21.4-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir \
    && rm /tmp/cmake-3.21.4-Linux-x86_64.sh \
    && pip install -q --upgrade --no-cache-dir pip \
    && pip install --no-cache-dir 'conan>=1.34.1,<2.0' conan_package_tools
