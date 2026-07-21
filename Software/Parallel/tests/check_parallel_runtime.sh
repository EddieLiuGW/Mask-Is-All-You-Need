#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "usage: $0 PARALLEL_RUNTIME_TEST_BINARY [LOG_FILE]" >&2
    exit 2
fi

binary=$1
log_file=${2:-parallel-runtime-test.log}
max_threads=0
max_runnable=0
declare -A previous_ticks=()
declare -A active_tids=()

OMP_NUM_THREADS=4 OMP_DYNAMIC=FALSE OMP_WAIT_POLICY=PASSIVE "$binary" >"$log_file" 2>&1 &
workload_pid=$!

while kill -0 "$workload_pid" 2>/dev/null; do
    runnable=0
    if [[ -r "/proc/$workload_pid/status" ]]; then
        threads=$(awk '$1 == "Threads:" { print $2 }' "/proc/$workload_pid/status" 2>/dev/null || true)
        if [[ -n "${threads:-}" && "$threads" -gt "$max_threads" ]]; then
            max_threads=$threads
        fi
    fi
    for stat_file in "/proc/$workload_pid"/task/[0-9]*/stat; do
        [[ -r "$stat_file" ]] || continue
        if { IFS= read -r stat_line <"$stat_file"; } 2>/dev/null; then
            stat_tail=${stat_line##*) }
            read -r -a stat_fields <<<"$stat_tail"
            state=${stat_fields[0]}
            tid=${stat_file%/stat}
            tid=${tid##*/}
            ticks=$((stat_fields[11] + stat_fields[12]))
            if [[ -v "previous_ticks[$tid]" && "$ticks" -gt "${previous_ticks[$tid]}" ]]; then
                active_tids[$tid]=1
            fi
            previous_ticks[$tid]=$ticks
            if [[ "$state" == "R" ]]; then
                runnable=$((runnable + 1))
            fi
        fi
    done
    if [[ "$runnable" -gt "$max_runnable" ]]; then
        max_runnable=$runnable
    fi
    sleep 0.002
done

if ! wait "$workload_pid"; then
    cat "$log_file" >&2
    exit 1
fi

if [[ "$max_threads" -lt 4 ]]; then
    echo "expected at least 4 process threads, observed $max_threads" >&2
    exit 1
fi
if [[ "$max_runnable" -lt 2 ]]; then
    echo "expected concurrent worker activity, observed at most $max_runnable runnable thread" >&2
    exit 1
fi
active_threads=${#active_tids[@]}
if [[ "$active_threads" -lt 4 ]]; then
    echo "expected at least 4 threads to accumulate CPU time, observed $active_threads" >&2
    exit 1
fi

echo "parallel runtime test passed (maximum live/runnable, CPU-active threads: $max_threads/$max_runnable, $active_threads)"
