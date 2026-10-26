#!/bin/bash
# Успешные попытки 2026 года и количество троек за 2024–2026 годы.
set -eu
export LC_ALL=C
cd "$(dirname "$0")"
mkdir -p reports

success='^[^;]+;[^;]+;2026-[0-9]{2}-[0-9]{2};[0-9]+;[3-5][+-]*$'
threes='^[^;]+;[^;]+;202[4-6]-[0-9]{2}-[0-9]{2};[0-9]+;3$'
format='s/^([^;]+)-[0-9]{2};([^;]+);[^;]+;[^;]+;([^;]+)$/\2,\1,\3/'

for subject in Цирковое_Дело Пересдачеведение; do
    report="reports/${subject}-2026.txt"
    grep -hE "$success" "labfiles-3-26/$subject"/tests/TEST-* |
        sed -E "$format" | sort > "$report"
    count=$(grep -hE "$threes" "labfiles-3-26/$subject"/tests/TEST-* | wc -l | tr -d ' ')
    printf '# Оценок ровно 3 за 2024–2026: %s\n' "$count" >> "$report"
    printf '%s: %s успешных попыток; троек за 2024–2026: %s\n' \
        "$subject" "$(grep -c '^[^#]' "$report")" "$count"
done

report=reports/all-subjects-2026.txt
grep -hE "$success" labfiles-3-26/*/tests/TEST-* |
    sed -E "$format" | sort > "$report"
count=$(grep -hE "$threes" labfiles-3-26/*/tests/TEST-* | wc -l | tr -d ' ')
printf '# Оценок ровно 3 за 2024–2026 по двум предметам: %s\n' "$count" >> "$report"
printf 'Всего: %s успешных попыток; троек за 2024–2026: %s\n' \
    "$(grep -c '^[^#]' "$report")" "$count"
