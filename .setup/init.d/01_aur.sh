# install yaourt
if [ $(which yaourt) ]
then
  echo "Yaourt ist bereits installiert, update Yaourt"
  yaourt -S --noconfirm yaourt
else 
  echo "Yaourt ist nicht installiert, installiere es"
  git clone https://aur.archlinux.org/package-query.git
  cd package-query
  makepkg -si
  cd ..
  git clone https://aur.archlinux.org/yaourt.git
  cd yaourt
  makepkg -si
  cd ..
fi



if [ $(which yaourt) ]
then
  yaourt -S --noconfirm autoenv
else 
  >&2 echo "ACHTUNG: YAOURT nicht gefunden"
fi
