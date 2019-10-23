#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#sudo apt-get install -y nodejs
mkdir /mnt/windev
add-apt-repository ppa:gencfsm
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
apt update
apt -y install guake
apt -y install sshfs
apt -y install libaio1 libaio-dev
apt -y install virtualbox-qt
apt -y install vim
apt -y install keepassx
apt -y install insync
apt -y install dropbox
apt -y install gnome-encfs-manager
apt -y install telegram 
apt -y install p7zip-full
apt -y install rclone
wget https://go.skype.com/skypeforlinux-64.deb /tmp
dpkg -i /tmp/skypeforlinux-64.deb
