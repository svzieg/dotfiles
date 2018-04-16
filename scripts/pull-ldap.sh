#!/bin/sh
# Inspired by https://github.com/svend/home-bin/blob/master/mutt-uw-search
# This can then be used by mutt in the following way:
#    set query_command = "echo; grep -i '%s' ~/.mutt/book"
# Note: echoing the empty line is necessary for mutt.

host=localhost
port=1389
bindDN=SCHEER\\u500132
pw=$(secret-tool lookup user sven.ziegler@scheer-group.com)
base='ou=people'
sort_by=givenName
max=100

print_results()
{
  mail=
  name=
  title=

  while read s; do
    case "$s" in
    dn:*)
      # New entry
      if [ -n "$mail" -a -n "$name" ]; then
        echo -e "$mail\t$name\t$title"
      fi

      # Clear all variables
      mail=
      name=
      title=
      ;;
    mail:*)
      mail=${s#mail:[   ]*}
      ;;
    cn:*)
      name=${s#cn:[   ]*}
      ;;
    title:*)
      title=${s#title:[   ]*}
      ;;
    esac
  done

  # Catch last entry
  if [ -n "$mail" -a -n "$name" ]; then
    echo -e "$mail\t$name\t$title"
  fi
}

if [ "$1" == "" ]; then
  pattern="*";
else 
  pattern="*$1*"
fi

filter="(|(objectClass=person)(objectClass=group))"
filter="mail=$pattern"
ldapsearch -h $host -p $port -x -D $bindDN -w $pw -b "$base" -LLL -E pr=10/noprompt "$filter" mail cn title | print_results | sort | uniq

