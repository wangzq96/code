#!/bin/bash
cd /usr/local/php56/etc/
sed -i '10c user = nginx' php-fpm.conf
sed -i '11c group = nginx' php-fpm.conf
sed -i '10c user = nginx' php-fpm2.conf
sed -i '11c group = nginx' php-fpm2.conf
sed -i '10c user = nginx' php-fpm3.conf
sed -i '11c group = nginx' php-fpm3.conf
sed -i '10c user = nginx' php-fpm4.conf
sed -i '11c group = nginx' php-fpm4.conf
sed -i '10c user = nginx' php-fpm5.conf
sed -i '11c group = nginx' php-fpm5.conf
sed -i '10c user = nginx' php-fpm6.conf
sed -i '11c group = nginx' php-fpm6.conf
sed -i '10c user = nginx' php-fpm7.conf
sed -i '11c group = nginx' php-fpm7.conf
sed -i '10c user = nginx' php-fpm8.conf
sed -i '11c group = nginx' php-fpm8.conf
cd /usr/local/src/php-5.6.35/ext/soap/
/usr/local/php56/bin/phpize
./configure -with-php-config=/usr/local/php56/bin/php-config -enable-soap
echo $?
killall php-fpm
make && make install
cd /usr/local/
chmod -R 755 php56/
killall php-fpm
/usr/local/php56/sbin/php-fpm -y /usr/local/php56/etc/php-fpm.conf
/usr/local/php56/sbin/php-fpm -y /usr/local/php56/etc/php-fpm2.conf
/usr/local/php56/sbin/php-fpm -y /usr/local/php56/etc/php-fpm3.conf
/usr/local/php56/sbin/php-fpm -y /usr/local/php56/etc/php-fpm4.conf
/usr/local/php56/sbin/php-fpm -y /usr/local/php56/etc/php-fpm5.conf
/usr/local/php56/sbin/php-fpm -y /usr/local/php56/etc/php-fpm6.conf
/usr/local/php56/sbin/php-fpm -y /usr/local/php56/etc/php-fpm7.conf
/usr/local/php56/sbin/php-fpm -y /usr/local/php56/etc/php-fpm8.conf

sed -i '734c extension_dir = ""/usr/local/php56/lib/php/extensions/no-debug-non-zts-20131226/'/usr/local/php56/etc/php.ini
/usr/local/php56/lib/php/extensions/no-debug-non-zts-20131226/
extension=soap.so