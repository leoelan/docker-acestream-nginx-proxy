#!/bin/bash

process=$1
PID_FILE="/var/run/acestream.pid"
case $process in
    start)
        echo "STARTING acestream media"
        nohup /opt/acestream/start-engine --client-console > /dev/null 2>1&
        echo $! > $PID_FILE
        sleep 2
        ;;

    stop)
        kill -9 $(cat $PID_FILE)
        rm $PID_FILE
        killall -KILL STM-Downloader
        killall -KILL STM-Agent
        ;;

    *)
        echo "INVALID OPTION"
        ;;
esac
