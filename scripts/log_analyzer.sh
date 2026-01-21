#!/bin/bash

LOGFILE="logs/access.log"

if [[ ! -f "$LOGFILE" ]]; then
    echo "Error: log file not found: $LOGFILE" >&2
    exit 1
fi

# Общее число запросов
total=$(wc -l < "$LOGFILE")

# Число ответов 200
# В нашем логе: последнее поле — это код (например, 200)
ok=$(awk '{if ($NF == "200") c++} END {print c+0}' "$LOGFILE")

# ТОП-3 IP
top_ips=$(awk '{print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -3 | awk '{print $2}')

# Вывод
echo "Total requests: $total"
echo "200 responses: $ok"
echo "Top 3 IPs:"
echo "$top_ips"
