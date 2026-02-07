#!/bin/bash

# Определяем директорию, где лежит сам скрипт
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGFILE="$SCRIPT_DIR/../logs/access.log"

# Проверка существования лога
if [[ ! -f "$LOGFILE" ]]; then
    echo "Error: log file not found: $LOGFILE" >&2
    exit 1
fi

# Считаем статистику
total=$(wc -l < "$LOGFILE")
ok=$(awk '{if ($NF == "200") c++} END {print c+0}' "$LOGFILE")

# Собираем IP -> count
declare -A ip_counts
while IFS= read -r line; do
    ip=$(echo "$line" | awk '{print $1}')
    if [[ -n "$ip" ]]; then
        ((ip_counts["$ip"]++))
    fi
done < "$LOGFILE"

# Вывод в stdout
echo "Total requests: $total"
echo "200 responses: $ok"
echo "Top 3 IPs:"
printf '%s\n' "${!ip_counts[@]}" | sort | head -3

# Запись в БД
psql -d devops_test -c "DELETE FROM log_stats;" >/dev/null 2>&1
for ip in "${!ip_counts[@]}"; do
    count=${ip_counts[$ip]}
    psql -d devops_test -c "INSERT INTO log_stats (ip, requests_count) VALUES ('$ip', $count);" >/dev/null 2>&1
done

exit 0
