if [ -z "$1" ]
  then
    echo "Informe o Número da PBI"
    exit 1
fi

git checkout master
git pull
git checkout -b features/$1