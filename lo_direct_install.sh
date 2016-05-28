#!/bin/bash
#
# Libreoffice download .deb script
# Autors - Rousk,Chocobo
# http://www.mintlinux.ru/blogs/lin-lichka/ustanovka-openoffice-libreoffice-cherez-terminal.html
# === Changelog ===
# 23/05/16 - v0.1 (First version)
# checking architecture and choice available versions with zenity
#
# 24/05/16 - v0.2 
# added zenity progressbar based on https://gist.github.com/axidsugar/79f284a4d51a0171eac8
#

DOWNLOAD() {
  echo $1
  rand="$RANDOM `date`"
  pipe="/tmp/pipe.`echo '$rand' | md5sum | tr -d ' -'`"
  mkfifo $pipe
  wget -c $1 2>&1 | while read data;do
    if [ "`echo $data | grep '^Length:'`" ]; then
      total_size=`echo $data | grep "^Length:" | sed 's/.*\((.*)\).*/\1/' |  tr -d '()'`
    fi
    if [ "`echo $data | grep '[0-9]*%' `" ];then
      percent=`echo $data | grep -o "[0-9]*%" | tr -d '%'`
      current=`echo $data | grep "[0-9]*%" | sed 's/\([0-9BKMG.]\+\).*/\1/' `
      speed=`echo $data | grep "[0-9]*%" | sed 's/.*\(% [0-9BKMG.]\+\).*/\1/' | tr -d ' %'`
      remain=`echo $data | grep -o "[0-9A-Za-z]*$" `
      echo $percent
      echo "#Скачивается $1\n$current готово ($percent%)\nСкорость : $speed/сек\nОсталось времени : $remain"
    fi
  done > $pipe &

  wget_info=`ps ax |grep "wget.*$1" |awk '{print $1"|"$2}'`
  wget_pid=`echo $wget_info|cut -d'|' -f1 `

  zenity --progress --auto-close --text="Соединение с $1\n\n\n" --width="350" --title="Загрузка"< $pipe
  if [ "`ps -A |grep "$wget_pid"`" ];then
    kill $wget_pid
    zenity --info --text="Выполнена отмена или случилась непредвиденная ошибка.\nРабота инструмента прекращена." --title="Завершение" --width="350"
    exit
  fi
  rm -f $pipe
}


rm -rf /tmp/LO/
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} = 'x86_64' ]; then
  ARCH=x86_64
  ARCH2=x86-64
else
  ARCH=x86
  ARCH2=x86
fi

zenity --info --width=350 --text="Привет!\n\n Сейчас мы будем устанавливать LibreOffice из .deb-пактов c оф.сайта. \n\n Насколько мы сумели определить - подойдёт $ARCH-битная версия. \n\n Давай уже выберем какую именно... "
wget -qO- download.documentfoundation.org/libreoffice/stable/ | grep -o '[0-9]\.[0-9]\.[0-9]' | uniq > /tmp/lo_v_a
VERSION=`cat /tmp/lo_v_a | \
         sed 's/^/FALSE\n/g' | \
         zenity --width=350 --height=250  --list --radiolist --separator=' ' \
                --title="Выбор версии" \
                --text="Пожалуйста выберите версию:" --column="" --column="Files"`
echo $CHECKED

mkdir -p /tmp/LO/{download,deb} && cd /tmp/LO/download
dllink_base=http://download.documentfoundation.org/libreoffice/stable/$VERSION/deb/$ARCH/LibreOffice_$VERSION\_Linux_$ARCH2\_deb.tar.gz
DOWNLOAD "$dllink_base"
dllink_lang=http://download.documentfoundation.org/libreoffice/stable/$VERSION/deb/$ARCH/LibreOffice_$VERSION\_Linux_$ARCH2\_deb_langpack_ru.tar.gz
DOWNLOAD "$dllink_lang"
dllink_help=http://download.documentfoundation.org/libreoffice/stable/$VERSION/deb/$ARCH/LibreOffice_$VERSION\_Linux_$ARCH2\_deb_helppack_ru.tar.gz
DOWNLOAD "$dllink_help"
tar -xvf LibreOffice_$VERSION\_Linux_$ARCH2\_deb.tar.gz 
tar -xvf LibreOffice_$VERSION\_Linux_$ARCH2\_deb_langpack_ru.tar.gz 
tar -xvf LibreOffice_$VERSION\_Linux_$ARCH2\_deb_helppack_ru.tar.gz 
find /tmp/LO/download/ -name *.deb -exec mv -t /tmp/LO/deb/ {} +
cd /tmp/LO/deb/
sudo dpkg --install *.deb
