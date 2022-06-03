#!/bin/bash

# имя пользователя, владельца службы
_user=user1234

# проверка наличия работающей службы в системе ----------------------

service="ce"
s=$(sudo systemctl is-active $service)
if [ "$s" == "active" ] 
then
echo "the service $service is already installed and running"
if read -p "do you want to reinstall the service? (y/n)" answer
then
if [ ${answer^} != "Y" ] 
then
echo "The installation was interrupted by the user..."
exit
else
sudo systemctl stop $service
echo "the service $service is stopped"
fi
fi
fi

# проверка наличия пользователя в системе ----------------------

NeedCreateUser=true

if grep $_user /etc/passwd
then
if read -p "The user $_user already exists in the system. Continue the installation on his behalf? (y/n)" answer
then
NeedCreateUser=false
if [ ${answer^} != "Y" ] 
then
echo "The installation was interrupted by the user..."
exit
fi
fi
fi

# создание пользователя в системе, если это требуется ---------- 

# Пользователя с пустым паролем можно создать следующей командой
# sudo useradd $_user -s /bin/bash -m -p U6aMy0wojraho
# U6aMy0wojraho - это хэш пароля ввиде пустой строки (Tested on Ubuntu 18.04.)

if $NeedCreateUser
then
if sudo useradd $_user --system --no-create-home # пользователь без пароля, оболочки и домашней папки
then
echo "User $_user created!"
else
echo "User $_user not created!"
exit
fi
fi

# установка CE ввиде сервиса

echo "copy ./ce to /usr/local/bin/" 
if sudo cp --force ./ce /usr/local/bin/
then
if sudo chown $_user /usr/local/bin/ce
then
echo "copy ./ce.service to /lib/systemd/system/" 
if sudo cp --force ./ce.service  /lib/systemd/system/
then
echo "adding a service $service to startup"
if sudo systemctl enable ce.service
then
echo "launching the service $service"
if sudo systemctl start ce.service
then
echo "Congratulations! The service $service has been successfully installed and started!"
fi
fi
fi
fi
fi






