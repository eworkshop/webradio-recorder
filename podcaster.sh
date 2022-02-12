#!/bin/sh

# You MUST replace these variables according to your needs

$PODCAST_ROOT=<your directory>/;
$STREAMING_SERVER=http://<streaming host>:<port>/<mount point>

if [ $# -ne 2 ]; then
        echo 1>&2 Usage: $0 Record_Name Recording_Time_In_Seconds
        exit 127
fi

# The script relies on MPlayer in a *standard* location, so better check it's present
# This may change depending on the Unix/Linux flavor you use.

test -x /usr/bin/mplayer || exit 127

# Dump file is created according to the following pattern : $1-DD-MM-YYY

record_date=`eval date +%d-%m-%Y`
dumpfile=$1-$record_date

mplayer -nocache -nolirc -playlist $STREAMING_SERVER -dumpaudio -dumpfile /tmp/$dumpfile.mp3 &
player_pid=$!
sleep $2
kill -9 $player_pid

if [ ! -d $PODCAST_ROOT/$1 ]
then
	mkdir $PODCAST_ROOT/$1
fi

mv $PODCAST_ROOT/$dumpfile.mp3 $PODCAST_ROOT/$1/

# All Done !
exit 0
