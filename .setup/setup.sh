


# führe initialisierungsscripte aus
for file in init.d/*
do
  echo "execute initscript: $file"
  sh "$file"
  echo "executed initscript: $file"
done
