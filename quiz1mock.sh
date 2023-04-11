#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No arguments supplied\ncorrect commond sh mock.sh s4xxxxxxx zone-id \ne.g. sh quiz1mock.sh s4123456"
    exit 1
fi
echo 'Create Quiz Folder.'
cd /var/www/htdocs/ 
apt-get install --no-install-recommends --no-install-suggests -q -y zip wget
rm -rf /var/www/htdocs/mock
mkdir mock
cd mock
wget --no-check-cert https://www.dropbox.com/s/7gkbfzzgpn52y1v/quiz1.zip
unzip quiz1.zip
rm quiz1.zip
echo 'Setting Quiz Environment.'
sudo sed -i 's/#default         \"allow\:user\:\*\"/default             \"allow\:user\:\*\" /g' /etc/nginx/conf.d/auth.conf
sudo sed -i 's/default          \"allow\:\*\"/#default          \"allow\:\*\"/g' /etc/nginx/conf.d/auth.conf
sudo sed -i 's/index index.php index.htm index.html;/index index.php index.htm index.html;\n\nlocation \/mock {\n\t try_files \$uri \$uri\/ \/mock\/public\/index.php\$is_args\$args;\n\t index public\/index.php;\n}/g' /etc/nginx/frameworks-enabled/php.conf 
sudo sed -i 's/string $baseURL.*/string $baseURL = '"\'https:\/\/"$(hostname | cut -d '.' -f 1)".uqcloud.net\/mock\/\';"'/' /var/www/htdocs/mock/app/Config/App.php
sudo systemctl reload nginx
echo 'Enable VSCode.'
sudo webprojctl enable vscode
echo 'sudo systemctl enable code-server@'$1
echo 'Mock quiz environment has been set up properly.'