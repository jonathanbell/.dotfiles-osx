#!/usr/bin/env bash

# Stop and "uninstall" the default Apache
sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null
# Not sure if we need to stop Apache first or "unload" it first.
# On my original system, this only had effect while Apache was running, so run
# this stop command after unloading.
sudo apachectl stop

# Use Homebrew Apache vs sfock Apache
brew install httpd
sudo brew services start httpd
brew install php@7.1

# Edit the main Apache file to suit our needs.
# About `sed`:
# https://askubuntu.com/questions/20414/find-and-replace-text-within-a-file-using-commands

APACHE_FILE=/usr/local/etc/httpd/httpd.conf # Default is /etc/apache2/httpd.conf (This is Homebrew's path)
WHOAMINOW=$(whoami)
MODULE_DIR=lib/httpd/modules

# DocumentRoot
sudo sed -i "" "s|/usr/local/var/www|/Users/$WHOAMINOW/Sites|" $APACHE_FILE

# User and Group
sudo sed -i '' "s|User _www|User $WHOAMINOW|" $APACHE_FILE
sudo sed -i '' "s|Group _www|Group staff|" $APACHE_FILE

# Mod ReWrite
sudo sed -i '' "s|#LoadModule rewrite_module $MODULE_DIR/mod_rewrite.so|LoadModule rewrite_module $MODULE_DIR/mod_rewrite.so|" $APACHE_FILE

# ServerName
sudo sed -i '' "s|#ServerName www.example.com:8080|ServerName localhost|" $APACHE_FILE

# .htaccess and open permissions
sudo sed -i '' "s|AllowOverride None|AllowOverride all|" $APACHE_FILE
sudo sed -i '' "s|FollowSymLinks|FollowSymLinks Multiviews Indexes Includes|" $APACHE_FILE

# PHP
sudo sed -i '' "s|DirectoryIndex index.html|DirectoryIndex index.html index.php|" $APACHE_FILE
sudo sed -i '' "s|#LoadModule include_module $MODULE_DIR/mod_include.so|LoadModule include_module $MODULE_DIR/mod_include.so|" $APACHE_FILE
# Load PHP7 module
sudo sed -i '' "s|#LoadModule dav_fs_module lib/httpd/modules/mod_dav_fs.so|LoadModule php7_module /usr/local/opt/php@7.1/lib/httpd/modules/libphp7.so|" $APACHE_FILE
# Ensure PHP engine is run for PHP files
echo '<FilesMatch \.php$>' >> $APACHE_FILE
echo '    SetHandler application/x-httpd-php' >> $APACHE_FILE
echo '</FilesMatch>' >> $APACHE_FILE

# SSL
sudo sed -i '' "s|#LoadModule socache_shmcb_module $MODULE_DIR/mod_socache_shmcb.so|LoadModule socache_shmcb_module $MODULE_DIR/mod_socache_shmcb.so|" $APACHE_FILE
sudo sed -i '' "s|#LoadModule ssl_module $MODULE_DIR/mod_ssl.so|LoadModule ssl_module $MODULE_DIR/mod_ssl.so|" $APACHE_FILE
sudo sed -i '' "s|#Include /usr/local/etc/httpd/extra/httpd-ssl.conf|Include /usr/local/etc/httpd/extra/httpd-ssl.conf|" $APACHE_FILE
sudo sed -i '' "s|Listen 8443|Listen 443|" /usr/local/etc/httpd/extra/httpd-ssl.conf
sudo sed -i '' "s|_default_:8443|_default_:443|" /usr/local/etc/httpd/extra/httpd-ssl.conf

echo
echo
echo 'Configuring self-signed SSL certificate (see note below).......'
echo '********************* NOTE: Enter "localhost" when asked for your "Common Name". *********************'
echo
echo
cd /usr/local/etc/httpd
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout server.key -out server.crt
cd -

# Ports
sudo sed -i '' "s/Listen 8080/Listen 127.0.0.1:443/g" $APACHE_FILE # Listen over SSL only

# Other Apache modules
sudo sed -i '' "s|#LoadModule authz_core_module $MODULE_DIR/mod_authz_core.so|LoadModule authz_core_module $MODULE_DIR/mod_authz_core.so|" $APACHE_FILE
sudo sed -i '' "s|#LoadModule authz_host_module $MODULE_DIR/mod_authz_host.so|LoadModule authz_host_module $MODULE_DIR/mod_authz_host.so|" $APACHE_FILE

# Vhosts
sudo sed -i '' "s|#Include /usr/local/etc/httpd/extra/httpd-vhosts.conf|Include /usr/local/etc/httpd/extra/httpd-vhosts.conf|" $APACHE_FILE
read -p "Destroy current copy of httpd-vhosts.conf? [Choose y if this is your first time running this script] (Y/n) " RESP
if [ "$RESP" = "y" ]; then
  sudo echo '# Place your VirtualHosts configurations here.' > /usr/local/etc/httpd/extra/httpd-vhosts.conf
  sudo echo '# Examples can be found at: https://getgrav.org/blog/macos-mojave-apache-ssl' >> /usr/local/etc/httpd/extra/httpd-vhosts.conf
else
  echo "Not altering current copy of httpd-vhosts.conf. You may notice errors below if this is your first time running this script."
fi

# Hide server tokens
echo 'ServerTokens Prod' >> $APACHE_FILE
echo 'ServerSignature Off' >> $APACHE_FILE

# Restart Apache
echo 'Restarting Apache...'
sudo apachectl -k restart

echo
echo 'Checking Apache config (do you see errors below this line?)....'
sudo apachectl configtest

# Add a test file to the Sites directory
mkdir $HOME/Sites
echo '<h1>You did it!</h1><?php phpinfo(); ?>' > /Users/$WHOAMINOW/Sites/index.php
mkdir /Users/$WHOAMINOW/Sites/cgi-bin
chmod -R 775 $HOME/Sites/

echo
echo 'Apache main site is configured. You can check it out at https://localhost however, you now may want to configure VirtualHosts in order to use seperate sites on the same system.'
echo 'See: https://getgrav.org/blog/macos-mojave-apache-ssl'
echo 'To edit your hosts file and your VirtualHosts use the command:'
echo 'sudo nano /etc/hosts && sudo nano /usr/local/etc/httpd/extra/httpd-vhosts.conf'
echo
