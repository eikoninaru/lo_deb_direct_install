Скрипт **lo_direct_install.sh** появился во время обсуждения темы в личном блоге на [mintlinux.ru](http://www.mintlinux.ru/blogs/lin-lichka/ustanovka-openoffice-libreoffice-cherez-terminal.html) и он поможет вам установить самую свежую версию офисного пакета прямо с сайта разработчиков, одновременно определив разрядность вашей системы.
## Установка
### Зависимости
Перед установкой, убедитесь, что в вашей системе установлен пакет *zenity*, введя в терминале `zenity --version`. Если пакет установлен, вы увидете его версию, в противном случае, его необходимо будет установить, введя в терминале `apt install -y zenity`
### Получение и установка
Получить и установить скрипт можно разными способами, здесь рекомендуем использовать утилиту `curl` или `wget`
#### Используя curl
~~~
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Chocbo/lo_deb_direct_install/master/lo_direct_install.sh)"
~~~
#### Используя wget
~~~
 sh -c "$(wget https://raw.githubusercontent.com/Chocbo/lo_deb_direct_install/master/lo_direct_install.sh -O -)"
~~~
Далее, следуйте подсказкам в появившемся окне.