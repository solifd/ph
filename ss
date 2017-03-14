
#curl "https://raw.githubusercontent.com/solifd/ph/master/ss" -o ss && chmod 755 ss &&./ss &&  rm -rf ss
yum install epel-release -y
yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto udns-devel libev-devel wget  -y

export LIBSODIUM_VER=1.0.11
export MBEDTLS_VER=2.4.0
wget https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-$LIBSODIUM_VER.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
make install
popd
rm -rf libsodium*
wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
tar xvf mbedtls-$MBEDTLS_VER-gpl.tgz
pushd mbedtls-$MBEDTLS_VER
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
popd
rm -rf mbedtls*
ldconfig
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
./autogen.sh && ./configure && make
make install
