#!/bin/bash

trap 'jobs -p | xargs kill >&2 2> /dev/null' EXIT

INTERMEDIATES_DIR="_log"
SYGUS_EXT=".sl"
Z3_PATH="_dep/z3.bin"

MIN_STATES=63
MIN_TIMEOUT=5
MAX_STATES=1024

RECORD="./Record.native"
INFER="./Infer.native"
VERIFY="./Verify.native"

FORKS=2
STATES=512

TIMEOUT=60
REC_TIMEOUT=3s

RECORD_LOG=""
INFER_LOG=""
VERIFY_LOG=""

RECORD_ARGS=""
INFER_ARGS=""
VERIFY_ARGS=""

DO_LOG="no"
DO_CLEAN="no"
DO_VERIFY="no"

DO_INTERACTIVE="no"
ERASE_STATUS="\b\b\b\b\b\b\b\b\b\b"

usage() {
  echo -en "
Usage: $0 [flags] <benchmark.sl>

Flags:
    [--clean-intermediates, -c]
    [--interactive, -i]
    [--verify, -v]

Configuration:
    [--intermediates-path, -p <path>] (_log)
    [--logging, -l <mode>]            (none)\t{none|rec|inf|all}
    [--max-states, -m <count>]        ($MAX_STATES)\t{> 0}
    [--record-states, -s <count>]     ($STATES)\t{> $MIN_STATES}
    [--timeout, -t <seconds>]         ($TIMEOUT)\t{> $MIN_TIMEOUT}
    [--z3-path, -z <path>]            (_dep/z3.bin)

Arguments to Internal Programs:
    [--Record-args, -R \"<args>\"]    for ${RECORD}
    [--Infer-args, -I \"<args>\"]     for ${INFER}
    [--Verify-args, -V \"<args>\"]    for ${VERIFY}
" 1>&2 ;
  exit 1 ;
}

OPTS=`getopt -n 'parse-options' -o :R:I:V:vip:l:cs:m:t:z: --long Record-args:,Infer-args:,Verify-args:,verify,interactive,intermediate-path:,logging:,clean-intermediates,record-states:,max-states:,timeout:,z3-path: -- "$@"`
if [ $? != 0 ] ; then usage ; fi

eval set -- "$OPTS"

while true ; do
  case "$1" in
    -R | --Record-args )
         RECORD_ARGS="$2"
         shift ; shift ;;
    -I | --Infer-args )
         INFER_ARGS="$2"
         shift ; shift ;;
    -V | --Verify-args )
         VERIFY_ARGS="$2"
         shift ; shift ;;

    -i | --interactive )
         DO_INTERACTIVE="yes" ; shift ;;
    -c | --clean-intermediates )
         DO_CLEAN="yes" ; shift ;;
    -v | --verify )
         DO_VERIFY="yes" ; shift ;;

    -l | --logging )
         [ "$2" == "none" ] || [ "$2" == "rec" ] || \
         [ "$2" == "inf" ] || [ "$2" == "all" ] || usage
         DO_LOG="$2"
         shift ; shift ;;
    -m | --max-states )
         [ "$2" -gt "0" ] || usage
         MAX_STATES="$2"
         shift ; shift ;;
    -p | --intermediates-path )
         [ -d "$2" ] || usage
         INTERMEDIATES_DIR="$2"
         shift ; shift ;;
    -s | --record-states )
         [ "$2" -gt "$MIN_STATES" ] || usage
         STATES="$2"
         shift ; shift ;;
    -t | --timeout )
         [ "$2" -gt "$MIN_TIMEOUT" ] || usage
         TIMEOUT="$2"
         shift ; shift ;;
    -z | --z3-path )
         [ -f "$2" ] || usage
         Z3_PATH="$2"
         shift ; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

TESTCASE="$1"
[ -f "$TESTCASE" ] || usage

TESTCASE_NAME="`basename "$TESTCASE" "$SYGUS_EXT"`"
TESTCASE_PREFIX="$INTERMEDIATES_DIR/$TESTCASE_NAME"
TESTCASE_INVARIANT="$TESTCASE_PREFIX.inv"

TESTCASE_LOG="$TESTCASE_PREFIX.log"
TESTCASE_REC_LOG="$TESTCASE_PREFIX.rlog"
TESTCASE_REC_LOG_PATTERN="$TESTCASE_REC_LOG"?

TESTCASE_STATE="$TESTCASE_PREFIX.s"
TESTCASE_STATE_PATTERN="$TESTCASE_STATE"?
TESTCASE_ALL_STATES="$TESTCASE_PREFIX.states"

RECORD="$RECORD -z $Z3_PATH"
INFER="$INFER -z $Z3_PATH"
VERIFY="$VERIFY -z $Z3_PATH"

TIMEOUT="${TIMEOUT}s"

if [ "$DO_LOG" == "all" ] ; then
  RECORD_LOG="-l $TESTCASE_REC_LOG"
  INFER_LOG="-l $TESTCASE_LOG"
  VERIFY_LOG="-l $TESTCASE_LOG"
elif [ "$DO_LOG" == "rec" ] ; then
  RECORD_LOG="-l $TESTCASE_REC_LOG"
elif [ "$DO_LOG" == "inf" ] ; then
  INFER_LOG="-l $TESTCASE_LOG"
fi

mkdir -p "$INTERMEDIATES_DIR"
rm -rf $TESTCASE_STATE_PATTERN
if [ "$DO_LOG" != "none" ] ; then
  echo -en '' > "$TESTCASE_LOG"
fi

if [ "$DO_INTERACTIVE" = "yes" ]; then
  echo -en "(@ record)"
fi

for i in `seq 0 $FORKS` ; do
  if [ -n "$RECORD_LOG" ] ; then LOG_PARAM="$RECORD_LOG$i" ; else LOG_PARAM="" ; fi
  (timeout --kill-after=$REC_TIMEOUT $REC_TIMEOUT \
           $RECORD -s $STATES -r "seed$i" -o $TESTCASE_STATE$i $LOG_PARAM \
                   $RECORD_ARGS $TESTCASE) >&2 &
done
wait

grep -hv "^[[:space:]]*$" $TESTCASE_STATE_PATTERN | sort -u | shuf \
  | head -n $MAX_STATES > $TESTCASE_ALL_STATES

if [ -n "$RECORD_LOG" ] ; then cat $TESTCASE_REC_LOG_PATTERN > $TESTCASE_LOG ; fi

if [ "$DO_INTERACTIVE" = "yes" ]; then
  echo -en "${ERASE_STATUS}(@ infer) "
fi

(timeout --kill-after=$TIMEOUT $TIMEOUT \
         $INFER -s $TESTCASE_ALL_STATES -o $TESTCASE_INVARIANT $TESTCASE \
                $INFER_ARGS $INFER_LOG) >&2 &
wait
INFER_RESULT_CODE=$?

if [ "$DO_INTERACTIVE" = "yes" ]; then
  echo -en "${ERASE_STATUS}          ${ERASE_STATUS}"
fi

if [ "$DO_VERIFY" = "yes" ]; then
  if [ $INFER_RESULT_CODE == 124 ] || [ $INFER_RESULT_CODE == 137 ] ; then
    echo > $TESTCASE_INVARIANT ; echo -n "[TIMEOUT] "
  fi

  $VERIFY -i $TESTCASE_INVARIANT $VERIFY_LOG $VERIFY_ARGS $TESTCASE &
  wait
  RESULT_CODE=$?
elif [ $INFER_RESULT_CODE == 0 ] ; then
  cat $TESTCASE_INVARIANT ; echo
  RESULT_CODE=0
fi

if [ "$DO_CLEAN" == "yes" ]; then
  rm -rf $TESTCASE_STATE_PATTERN $TESTCASE_REC_LOG_PATTERN
  if [ $INFER_RESULT_CODE == 0 ] || [ $INFER_RESULT_CODE == 2 ]; then
    rm -rf $TESTCASE_ALL_STATES
  fi
fi

exit $RESULT_CODE
