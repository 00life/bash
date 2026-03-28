#!/bin/bash

#/ [ Variables ]

API="https://raw.githubusercontent.com/00life/bash/refs/heads/master/raspberrypi_remote.sh";
URL_PI="http://192.168.2.24:8112/json"
CODE=$(mktemp); curl -sL $API -o ${CODE};
PATH_LOG=${HOME}/github.log;
CURL_COOKIE=$(mktemp --suffix=".txt");

MAGNET='magnet:?xt=urn:btih:259D1D91F906F0991DB5E3123FDE0FA301C7EDD4&dn=Monarch.Legacy.of.Monsters.S02E05.1080p.x265-ELiTE&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Fopen.demonii.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.fnix.net%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.qu.ax%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.renfei.net%3A8080%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=http%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fcoppersurfer.tk%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.zer0day.to%3A1337%2Fannounce';
TORRENT='';
PATH_TOR='/tmp/torrent.txt';


#/ [ Index Arrays ]

ARR_MAG=("core.add_torrent_magnet" [\"$MAGNET\",{}]);
ARR_TOR=("core.web.get_torrent_files" [\"$TORRENT\"]);
ARR_CONN=("web.connected" []);
ARR_ADD=("web.add_torrents" [[{"path":\"$PATH_TOR\","options":null}]]);

trap func_clean EXIT INT TERM

#/ [ Get Auth.Login Cookie ]
curl -c $CURL_COOKIE --compressed -H "Content-Type: application/json" -d '{"method": "auth.login", "params": ["pi"], "id": 1}' ${URL_PI};


#/ [ Functions ]

func_command() {
  STR_TYPE=$1;
  ARR_PARAM=$2;

  cat << EOF | tr '\n' ' '
   curl -b "$CURL_COOKIE"
    -H "Content-Type: application/json" 
    -H "Accept: application/json"
    -d '{"method": "$STR_TYPE", "params": $ARR_PARAM, "id": 1}'
    --compressed 
    $URL_PI
EOF
};


func_email() {
  local MSG=$1;

  cat << EOF | tr '\n' ' ' | bash 
      curl -X POST
      -H "Content-Type: application/json" 
      -H "Accept: application/json"
      -d '{"Email":"pawn88@live.com", "Subject":"RASPBERRYPI_REMOTE_OUTPUT", "Message":"$MSG"}'
      https://script.google.com/macros/s/AKfycbzzVxX1O0UTSzHBe7UElCNwnVPZrU3GqE98pmrivrQajqqM8QEe477O6MEl8gbhimozCg/exec
EOF
};


func_clean() {
  sudo rm -rf /tmp/*;
  unset API URL_PI CODE PATH_LOG CURL_COOKIE MAGNET;
};


func_compare() {
  if [[ ! -f $PATH_LOG ]]; then
    echo > $PATH_LOG;
	exit 1

  elif cmp -s "$CODE" "$PATH_LOG"; then
    exit 1

  else
    cat $CODE > $PATH_LOG;
    OUT="$(func_command ${ARR_MAG[0]} ${ARR_MAG[1]})"
	echo
	echo
	MSG="$(eval $OUT)";
	echo
	echo $MSG;
	echo
	echo
	func_email "$MSG";
	exit 0
  fi
};

echo test12

#/ [ Run Main Function ]
func_compare;
