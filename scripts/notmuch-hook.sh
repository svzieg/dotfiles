#!/bin/sh
notmuch new
# retag all "new" messages "inbox" and "unread"
notmuch tag +inbox +unread -new -- tag:new

# retag wrong tagged tags (comment in)
# notmuch tag -inbox -unread -sent +new -- tag:sent

# tag all messages from "me" as sent and remove tags inbox and unread
notmuch tag -new -inbox +sent -- from:svzieg@gmx.de or from:sven.ziegler@scheer-group.com or from:sven.ziegler@svenziegler.photography or from:ziggo1879@gmail.com
# tag newsletters, but dont show them in inbox
notmuch tag +newsletters +unread -new -- from:newsletter@example.org or subject:'newsletter*'

