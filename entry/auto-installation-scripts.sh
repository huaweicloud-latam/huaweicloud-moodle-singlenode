#!/bin/bash
export OUTLOG="/tmp/auto-installation-log.log"
export DEBIAN_FRONTEND=noninteractive

##### START IF #############################################################################################################################################
if cat /etc/*release | grep ^PRETTY_NAME | grep "Debian GNU/Linux 10" > /dev/null ; then
######## IF THE OS VERSION IS DEBIAN 10, then execute the following commands. ##############################################################################
date > $OUTLOG 2>&1
echo "### File System Start ###" >> $OUTLOG
mkfs -t ext4 /dev/vdb >> $OUTLOG  2>&1
cp /etc/fstab /etc/fstab.bak01 >> $OUTLOG  2>&1
echo "/dev/vdb /var/www/ ext4 defaults 0 2" >> /etc/fstab  2>> $OUTLOG
mkdir /var/www/  >> $OUTLOG 2>&1
mount -a >>$OUTLOG 2>&1
echo "### Filesystem End ###" >>$OUTLOG

echo "### Update & Upgrade Start ###" >>$OUTLOG
apt-get update >> $OUTLOG 2>&1
apt-get -y upgrade >> $OUTLOG 2>&1
echo "### Update & Upgrade End ###" >>$OUTLOG

echo "### Apache2 Start ###" >>$OUTLOG
apt-get -y install apache2 >>$OUTLOG 2>&1 
echo "### Apache2 End ###" >>$OUTLOG

echo "### Update LSB-release Start ###" >>$OUTLOG
apt-get -y install lsb-release apt-transport-https ca-certificates  >>$OUTLOG 2>&1 
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg   >>$OUTLOG 2>&1 
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list >>$OUTLOG 2>&1 
echo "### Update LSB-release End ###" >>$OUTLOG

echo "### PHP7.4 Start ###" >>$OUTLOG
apt-get -y update >>$OUTLOG 2>&1 
apt-get -y install php7.4 php7.4-mysql php7.4-xml php7.4-mbstring php7.4-curl php7.4-zip php7.4-intl php7.4-xmlrpc php7.4-soap php7.4-gd >>$OUTLOG 2>&1 
echo "### PHP7.4 End ###" >>$OUTLOG

echo "### MySQL5.7 Start ###" >>$OUTLOG 
apt-get -y install debconf-utils >>$OUTLOG 2>&1 
apt-get -y install gnupg >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/select-preview select  Disabled" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/preview-component      string" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/repo-codename  select  buster" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/select-tools   select  Enabled" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/select-server  select  mysql-5.7" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/tools-component        string  mysql-tools" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/select-product select  Ok" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/repo-distro    select  debian" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/repo-url       string  http://repo.mysql.com/apt" >>$OUTLOG 2>&1 
debconf-set-selections <<< "mysql-apt-config        mysql-apt-config/unsupported-platform   select  abort" >>$OUTLOG 2>&1 
cd /tmp  >>$OUTLOG 2>&1 
wget -q https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb   >>$OUTLOG 2>&1 
dpkg -i mysql-apt-config*  >>$OUTLOG 2>&1 
apt-get -y update >>$OUTLOG 2>&1 

##MYSQL_ROOT_PASSWORD="L@MP4Md0L3" # SET THIS! Avoid quotes/apostrophes in the password, but do use lowercase + uppercase + numbers + special chars
##echo debconf mysql-server/root_password password $MYSQL_ROOT_PASSWORD | debconf-set-selections >>$OUTLOG 2>&1 
##echo debconf mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD | debconf-set-selections >>$OUTLOG 2>&1 
#debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD" >>$OUTLOG 2>&1
#debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" >>$OUTLOG 2>&1
#apt-get -y install mysql-server >>$OUTLOG 2>&1 

echo "### MySQL5.7 End, please follow the guide to install the mysql-server manually. ###" >>$OUTLOG 

echo "### Moodle 3.11 Start ###" >>$OUTLOG 
cd /var/www >>$OUTLOG 2>&1 
wget -q https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.tgz 1> /dev/null 2>>$OUTLOG 
tar zxvf /var/www/moodle-latest-311.tgz -C /var/www/ 1> /dev/null 2>>$OUTLOG 
mkdir /var/www/moodledata >>$OUTLOG 2>&1 
chown -R www-data:www-data moodle >>$OUTLOG 2>&1 
chown -R www-data:www-data moodledata >>$OUTLOG 2>&1 
chmod -R 755 /var/www/moodle >>$OUTLOG 2>&1 
chmod -R 755 /var/www/moodledata >>$OUTLOG 2>&1 
sed -i "s/\/var\/www\/html/\/var\/www\/moodle/g" /etc/apache2/sites-available/000-default.conf >>$OUTLOG 2>&1 
/etc/init.d/apache2 restart >>$OUTLOG 2>&1 
echo "### Moodle 3.11 End ###" >>$OUTLOG 

##### Otherwise, exit! ###############################################################################################################################
else 
    echo "Please use Debian GNU/Linux 10 to create ECS." 
	exit 1;
fi
##### END IF #########################################################################################################################################
