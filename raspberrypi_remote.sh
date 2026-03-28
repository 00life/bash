#!/bin/bash

#/ [ Variables ]

API="https://raw.githubusercontent.com/00life/bash/refs/heads/master/raspberrypi_remote.sh";
URL_PI="http://192.168.2.24:8112/json"
CODE=$(mktemp); curl -sL $API -o ${CODE};
PATH_LOG=${HOME}/github.log;
CURL_COOKIE=$(mktemp --suffix=".txt");

MAGNET='magnet:?xt=urn:btih:e78d93a0f235565a83301ac7a82b5b3a62d6eb4c&dn=%5BSubsPlease%5D%20Fate%20Strange%20Fake%20-%2013%20%28480p%29%20%5B3CD81DDD%5D.mkv&tr=http%3A%2F%2Fnyaa.tracker.wf%3A7777%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&tr=udp%3A%2F%2Fexodus.desync.com%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce';
TORRENT='';
PATH_TOR='/tmp/torrent.txt';


#/ [ Index Arrays ]

ARR_MAG=("core.add_torrent_magnet" ["$MAGNET",{}]);
ARR_TOR=("core.web.get_torrent_files" ["$TORRENT"]);
ARR_CONN=("web.connected" []);
ARR_ADD=("web.add_torrents" [[{"path":"$PATH_TOR","options":null}]]);

trap func_clean EXIT INT TERM

#/ [ Get Auth.Login Cookie ]
curl -c $CURL_COOKIE --compressed -H "Content-Type: application/json" -d '{"method": "auth.login", "params": ["pi"], "id": 1}' ${URL_PI};


#/ [ Functions ]

func_command() {
  STR_TYPE=$1;
  ARR_PARAM=$2;

  cat << EOF | tr '\n' ' '|bash
   curl -b "$CURL_COOKIE"
    -X POST
    -H "Content-Type: application/json" 
    -H "Accept: application/json"
    -d '{"method": "$STR_TYPE", "params": $ARR_PARAM, "id": 1}'
    --compressed 
    $URL_PI
EOF
};


func_email() {
  local COMMAND_OUTPUT=$1;

  cat << EOF | tr '\n' ' ' | bash 
      curl -X POST
      -H "Content-Type: application/json" 
      -H "Accept: application/json"
      -d '{"Email":"pawn88@live.com", "Subject":"RASPBERRYPI_REMOTE_OUTPUT", "Message":"$COMMAND_OUTPUT"}'
      https://script.google.com/macros/s/AKfycbzzVxX1O0UTSzHBe7UElCNwnVPZrU3GqE98pmrivrQajqqM8QEe477O6MEl8gbhimozCg/exec
EOF
};


func_clean() {
  sudo rm -rf /tmp/*;
  unset API URL_PI CODE PATH_LOG CURL_COOKIE MAGNET COMMAND OUTPUT;
};


func_compare() {
  if [[ ! -f $PATH_LOG ]]; then
    echo > $PATH_LOG;
	exit 1

  elif cmp -s "$CODE" "$PATH_LOG"; then
    exit 1

  else
    cat $CODE > $PATH_LOG;
    func_command ${ARR_MAG[0]} ${ARR_MAG[1]} | func_email;
	exit 0
  fi
};

echo test7

#/ [ Run Main Function ]
func_compare;
