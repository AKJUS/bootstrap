#!/bin/bash


TOGGLE=false
STATUS=false

# Shift through args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --toggle)
      TOGGLE=true
      shift
      ;;
    --status)
      STATUS=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [[ $STATUS == true ]]; then 
    if [[ -n $(wg show) ]]; then 
        echo "%{F#00FF00}ON%{F-}"; 
    else
        echo "%{F#FF0000}OFF%{F-}";
    fi
fi

if [[ $TOGGLE == true ]]; then
    
    resolvconf -u
    
    if [[ -n $(wg show) ]]; then 
        wg-quick down no
    else
        wg-quick up no
    fi

fi

