mcd() {mkdir -pv $1; cd $1 ;}

lock() {
  loginctl lock-session 1
  xset -display :0 dpms force off
}

unlock() {
  loginctl unlock-session 1
  xset -display :0 dpms force on
}

cisco-tty() {
  sudo screen /dev/ttyUSB0 9600
}

unifi-tty() {
  sudo screen /dev/ttyUSB0 115200
}