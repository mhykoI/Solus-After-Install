#!/bin/bash

##### remove sudo reauthentication timeout
sudo sed -i.bak -e '$a\' -e 'Defaults timestamp_timeout=-1' -e '/Defaults timestamp_timeout=.*/d' /etc/sudoers

YESIL='\033[0;32m'
MAVI='\033[0;34m'
RENKSIZ='\033[0m'

control () {
    echo
        echo -e "${MAVI} .................. Paketler Kontrol Ediliyor ................. ${RENKSIZ}"
    echo
        sudo eopkg rebuild-db && sudo eopkg check -y
}

update () {
    echo
        echo -e "${MAVI} .................. Güncelleme Başlatılıyor ................. ${RENKSIZ}"
    echo
        sudo eopkg update-repo && sudo eopkg upgrade && sudo flatpak update -y
}

remove () { 
    echo
        echo -e "${MAVI} ..................... Uygulamalar Kaldırılıyor ..................... ${RENKSIZ}"
    echo
        sudo eopkg remove --purge firefox hexchat rhythmbox thunderbird libreoffice-common seahorse gparted onboard -y
}

fontinstall () {
    echo
        echo -e "${MAVI} ..................... Renkli Emoji Fontu Yükleniyor ..................... ${RENKSIZ}"
    echo
        unzip NotoColorEmoji-unhinted.zip
        mkdir ~/.fonts
        mv NotoColorEmoji.ttf ~/.fonts
        mv fonts.conf .fonts.conf
        sudo mv .fonts.conf /home/$USER
        sudo fc-cache -fv
        cd
    echo
        echo -e "${MAVI} ..................... Font Yükleme Tamamlandı ..................... ${RENKSIZ}"
}

install () { 
    echo
        echo -e "${MAVI} ..................... Uygulamalar Yükleniyor ..................... ${RENKSIZ}"
    echo
        sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/network/web/browser/google-chrome-stable/pspec.xml && sudo eopkg it google-chrome-*.eopkg;sudo rm google-chrome-*.eopkg && sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/multimedia/music/spotify/pspec.xml && sudo eopkg it spotify*.eopkg;sudo rm spotify*.eopkg && sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/programming/sublime-text-3/pspec.xml && sudo eopkg it sublime*.eopkg;sudo rm sublime*.eopkg && sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/desktop/font/mscorefonts/pspec.xml && sudo eopkg it mscorefonts*.eopkg;sudo rm mscorefonts*.eopkg && sudo snap install authy && sudo eopkg it discord && sudo eopkg it plank -y
}

cleaning () {
    echo
        echo -e "${MAVI} ..................... Temizleniyor ..................... ${RENKSIZ}"
    echo
        sudo eopkg rmo && sudo eopkg dc && sudo eopkg clean && sudo eopkg cp -y
    echo
        echo -e "${MAVI} ..................... Hepsi Bitti ..................... ${RENKSIZ}"
}

options (){
    if [[ $answer == 'r' ]]
        then
        reboot
    elif [[ $answer == 'p' ]]
        then
        poweroff
    else
        echo -e "${MAVI} ---------------------------------------------------- ${RENKSIZ}"
        echo
    fi
}

echo ""
echo "------------------------------"
echo ""
echo "      CHROME GÜNCELLEME"
echo ""
echo "------------------------------"
sleep 3

# Veriler
#######################################

GRAB=`sudo eopkg bi --ignore-safety https://raw.githubusercontent.com/getsolus/3rd-party/master/network/web/browser/google-chrome-stable/pspec.xml`
NEW=`curl https://raw.githubusercontent.com/getsolus/3rd-party/master/network/web/browser/google-chrome-stable/pspec.xml 2>1 /dev/null | grep deb | cut -d "/" -f11 | cut -d "_" -f2 | cut -d "-" -f1`
CURRENT="$(google-chrome-stable --version | cut -d ' ' -f3)"

#######################################

echo ""
echo "Chrome'un en son sürümünü kontrol ediliyor..."
echo ""
$NEW
sleep 3

echo "Sürümlerin karşılaştırılması..."
echo ""
echo "Geçerli sürüm ${CURRENT}"
echo ""
echo "En son sürüm ${NEW}"

if [ ${NEW} != ${CURRENT} ]
then
    echo "Sürüm $NEW kurulum için kullanılabilir!"
    sleep 3
    echo ""
    echo "Sürüm indirme ve derleme $NEW..."
    echo ""
    $GRAB
    sleep 3
    sudo eopkg it google-chrome-*.eopkg;sudo rm google-chrome-*.eopkg
    echo ""
    rm $HOME/1
else
    echo ""
    echo "Sürüm $CURRENT güncel..."
    echo ""
    sleep 3
    sudo rm $HOME/google-chrome-*.eopkg
    rm $HOME/1
fi
echo ""
echo "Chrome Güncelleme Bitti."
echo "------------------------------"

#Bazı Sistem Ayarları
# gedit ayarları
gsettings set org.gnome.gedit.preferences.editor scheme 'oblivion'
gsettings set org.gnome.gedit.preferences.editor create-backup-copy false
gsettings set org.gnome.gedit.preferences.editor tabs-size "uint32 4"
gsettings set org.gnome.gedit.preferences.editor auto-indent true
gsettings set org.gnome.gedit.preferences.editor insert-spaces true
# budgie ayarları
gsettings set com.solus-project.budgie-panel dark-theme true
# terminal ayarları
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
# bazı gereksiz servisleri kapatma
sudo systemctl stop accounts-daemon.service avahi-daemon.service debug-shell.service ModemManager.service
sudo systemctl disable accounts-daemon.service avahi-daemon.service debug-shell.service ModemManager.service
sudo systemctl mask accounts-daemon.service avahi-daemon.service debug-shell.service ModemManager.service
# günlüğü sınırlama
sudo systemctl disable systemd-journal-flush
sudo systemctl mask systemd-journal-flush

#### son bir temizlik
sudo eopkg rmo -y && sudo eopkg clean -y && sudo eopkg cp -y

sleep 3

echo -e "${MAVI} ---------------------------------------------------- ${RENKSIZ}"
echo
echo -e "${YESIL}
    Bundan Sonra Ne Yapacaksınız ?
    ${RENKSIZ}Yeniden Başlatmak${YESIL}: için ${RENKSIZ}r${YESIL} yazın ve ${RENKSIZ}Enter${YESIL};
    ${RENKSIZ}Bilgisayarı Kapatmak${YESIL}: için ${RENKSIZ}p${YESIL} yazın ve ${RENKSIZ}Enter${YESIL};
    ${RENKSIZ}Paneli Kapatmak${YESIL}: için sadece ${RENKSIZ}Enter${YESIL};
    ${RENKSIZ}"
echo -e "${MAVI} ---------------------------------------------------- ${RENKSIZ}"
read answer;

options