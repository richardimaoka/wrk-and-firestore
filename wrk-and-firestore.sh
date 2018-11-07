#!/bin/bash
# WRK performance test script

PROGNAME="wrk"

connections=4
duration=3
threads=2

#In the ISO 8601 format of '2018-10-21T15:59:45+09:00'
current_time=$(date -Iseconds)

# parse options, not that whitespace is needed (e.g. -c 4) between an option and the option argument
#  -c, --connections <N>  Connections to keep open
#  -d, --duration    <T>  Duration of test        
#  -t, --threads     <N>  Number of threads to use 
for OPT in "$@"
do
    case "$OPT" in
        '-c'|'--connections' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option -c or --connections requires an argument -- $1" 1>&2
                exit 1
            fi
            connections="$2"
            shift 2
            ;;
        '-d'|'--duration' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option -d or --duration requires an argument -- $1" 1>&2
                exit 1
            fi
            duration="$2"
            shift 2
            ;;
        '-t'|'--threads' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option -t or --threads requires an argument -- $1" 1>&2
                exit 1
            fi
            threads="$2"
            shift 2
            ;;
        -*)
            echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            exit 1
            ;;
        *)
            if [[ -n "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                TARGET_URL="$1"
                break
            fi
            ;;
    esac
done

# Executing WRK_CMD creates result:wq!_intermediate.json    
WRK_CMD="wrk -t ${threads} -c ${connections} -d ${duration} -s wrk_json.lua ${TARGET_URL}"
echo ${WRK_CMD}
${WRK_CMD} 

# Augment the result with metadata
echo "{ \
  \"metadata\": { \
    \"execution_time\":   \"$current_time\", \
    \"connections\":      $connections, \
    \"duration_seconds\": $duration, \
    \"num_threads\":      $threads \
  } \
}" > result_metadata.json
jq -s '.[0] * .[1]' result_metadata.json result_intermediate.json > result.json

node upload-to-firestore.js
