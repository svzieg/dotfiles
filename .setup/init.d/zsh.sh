
function clone {
    echo "installing oh-my-zsh"
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    echo "changing shell to zsh"
    chsh -s /bin/zsh
}

if [ -f ~/.zshrc ]
then
  echo "backup zshrc"
  mv ~/.zshrc ~/.zshrc.bak
fi

if [ -d ~/.oh-my-zsh ]
then
  # aktuelles Verzeichniss speichern
  cwd=$(pwd) 
  
  cd ~/.oh-my-zsh

  # wenn bereits das aktuelle Verzeichniss ein Git-Repo ist, dann sind wir hier fertig
  if [[ ! $(git pull) ]]
  then
    # Ansonsten liegen hier nur Templates oder überschriebene Funktionen drin, also müssen diese
    # gesichert werden
    echo "~/.oh-my-zsh exists, but is not a git repository, backup"
    mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
    clone
    echo "copy backuped files back to ~/oh-my-zsh"
    mv ~/.oh-my-zsh.bak ~/.oh-my-zsh

  else 
    echo "git repository found, updated oh-my-zsh config"
  fi


  cd "$cwd"
else 
  clone
fi


if [ -f ~/.zshrc.bak ]
then
  echo "revert zshrc"
  mv ~/.zshrc.bak ~/.zshrc
fi
