#!/bin/bash

#/ [ Variables ]

API="https://raw.githubusercontent.com/00life/bash/refs/heads/master/raspberrypi_remote.sh";
URL_PI="http://192.168.2.24:8112/json"
CODE=$(mktemp); curl -sL $API -o ${CODE};
PATH_LOG=${HOME}/github.log;
CURL_COOKIE=$(mktemp --suffix=".txt");
EVAL=$(mktemp);

MAGNET='magnet:?xt=urn:btih:0C391E8771FCD44AB344CBCE74666C51D50166C2&dn=Glorious.2022.720p.AMZN.WEBRip.800MB.x264-GalaxyRG&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.tiny-vps.com%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Fexplodie.org%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.cyberia.is%3A6969%2Fannounce&tr=udp%3A%2F%2Fipv4.tracker.harry.lu%3A80%2Fannounce&tr=udp%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.birkenwald.de%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.moeking.me%3A6969%2Fannounce&tr=udp%3A%2F%2Fopentor.org%3A2710%2Fannounce&tr=udp%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2970%2Fannounce&tr=https%3A%2F%2Ftracker.foreverpirates.co%3A443%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=http%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce&tr=udp%3A%2F%2Fopentracker.i2p.rocks%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.internetwarriors.net%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.leechers-paradise.org%3A6969%2Fannounce&tr=udp%3A%2F%2Fcoppersurfer.tk%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.zer0day.to%3A1337%2Fannounce';
TORRENT='';
PATH_TOR='/tmp/torrent.txt';


#/ [ Index Arrays ]

ARR_MAG=("core.add_torrent_magnet" [\"$MAGNET\",{}]);
ARR_TOR=("core.web.get_torrent_files" [\"$TORRENT\"]);
ARR_CONN=("web.connected" []);
ARR_ADD=("web.add_torrents" [[{"path":\"$PATH_TOR\","options":null}]]);


#/ [ Trap Cleanup ]

trap "$(cat << 'EOF'
  sudo rm -rf /tmp/*;
  unset API URL_PI CODE PATH_LOG CURL_COOKIE MAGNET EVAL;
EOF
)" EXIT INT TERM;


#/ [ Get Auth.Login Cookie ]

curl -c $CURL_COOKIE --compressed -H "Content-Type: application/json" -d '{"method": "auth.login", "params": ["pi"], "id": 1}' ${URL_PI};


#/ [ Functions ]

func_command() {
  local STR_TYPE=$1;
  local ARR_PARAM=$2;

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
  local MSG=$(cat $1| sed 's/  */ /g' | sed "s/[\'\"\r\t]//g");

  local REQ=$(cat << EOF | tr '\n' ' '|sed 's/  */ /g'
     curl -X POST
	 -H "Content-Type: application/json" 
     -H "Accept: application/json"
	 -d '{"Email": "pawn88@live.com", "Subject": "RASPBERRYPI_REMOTE_OUTPUT", "Message": "$MSG"}'
	 https://script.google.com/macros/s/AKfycbzzVxX1O0UTSzHBe7UElCNwnVPZrU3GqE98pmrivrQajqqM8QEe477O6MEl8gbhimozCg/exec
EOF
)
  eval $REQ
};


func_main() {
  if [[ ! -f $PATH_LOG ]]; then
    echo > $PATH_LOG;
	exit 1

  elif cmp -s "$CODE" "$PATH_LOG"; then
    exit 1

  else
    cat $CODE > $PATH_LOG;
    local OUT="$(func_command ${ARR_MAG[0]} ${ARR_MAG[1]})";
	eval $OUT 2>&1 | tee $EVAL ;
	func_email $EVAL;
	exit 0
  fi
};


#/ [ Run Main Function ]
func_main
