
#curl "https://raw.githubusercontent.com/solifd/ph/master/ss" -o ss && chmod 755 ss &&./ss &&  rm -rf ss
yum install epel-release -y
yum install git gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto udns-devel libev-devel wget  -y

wget ftp://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz
tar zxvf autoconf-*.tar.gz
cd autoconf-*
 ./configure --prefix=/usr/
make && make install


export LIBSODIUM_VER=1.0.11
export MBEDTLS_VER=2.4.2
#wget https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-$LIBSODIUM_VER.tar.gz
curl "http://soli-10006287.cos.myqcloud.com/libsodium-1.0.11.tar.gz" -o libsodium-1.0.11.tar.gz
tar xvf libsodium-$LIBSODIUM_VER.tar.gz
pushd libsodium-$LIBSODIUM_VER
./configure --prefix=/usr && make
make install
popd
rm -rf libsodium*
#wget https://tls.mbed.org/download/mbedtls-$MBEDTLS_VER-gpl.tgz
curl "http://soli-10006287.cos.myqcloud.com/mbedtls-2.4.2-gpl.tgz" -o mbedtls-2.4.2-gpl.tgz
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
#wget --no-check-certificate -O shadowsocks.tar.gz https://github.com/shadowsocks/shadowsocks-libev/archive/v3.0.3.tar.gz
cd shadowso*
git submodule update --init --recursive
./autogen.sh && ./configure && make
make install
/usr/local/bin/ss-server -v 
function config_shadowsocks(){
    if [ ! -d /etc/shadowsocks-libev ];then
        mkdir /etc/shadowsocks-libev
    fi
    cat > /etc/shadowsocks-libev/config.json<<-EOF
{
    "server":"0.0.0.0",
    "server_port":${shadowsocksport},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":600,
    "method":"aes-256-cfb"
}
EOF
}
config_shadowsocks
curl "https://raw.githubusercontent.com/solifd/ph/master/shadowsocks/shadowsocks " -o  /etc/init.d/shadowsocks
chmod +x /etc/init.d/shadowsocks
curl "https://raw.githubusercontent.com/solifd/ph/master/shadowsocks/shadowsocks.json" -o  /etc/shadowsocks.json
/etc/init.d/shadowsocks  start
curl "http://soli-10006287.cos.myqcloud.com/functions" -o /etc/rc.d/init.d/functions
curl "https://raw.githubusercontent.com/91yun/shadowsocks_install/master/shadowsocks-libev" -o /etc/init.d/shadowsocks
chmod +x /etc/init.d/shadowsocks
/etc/init.d/shadowsocks  start
