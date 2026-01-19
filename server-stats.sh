#!/usr/bin/env bash
set -euo pipefail
LC_ALL=C

print_title()
{
    echo -e "\n=== $1 ===";
}

cpu_usage()
{
    read -r _ u1 n1 s1 i1 iw1 irq1 sirq1 st1 _ < /proc/stat
    echo ""
    echo ""
    cat /proc/stat
    sleep 0.5
    read -r _ u2 n2 s2 i2 iw2 irq2 sirq2 st2 _ < /proc/stat

    awk -v u1="$u1" -v n1="$n1" -v s1="$s1" -v i1="$i1" -v iw1="$iw1" -v irq1="$irq1" -v sirq1="$sirq1" -v st1="$st1" \
    -v u2="$u2" -v n2="$n2" -v s2="$s2" -v i2="$i2" -v iw2="$iw2" -v irq2="$irq2" -v sirq2="$sirq2" -v st2="$st2" '
    BEGIN {
      idle1 = i1 + iw1
      idle2 = i2 + iw2
      non1  = u1 + n1 + s1 + irq1 + sirq1 + st1
      non2  = u2 + n2 + s2 + irq2 + sirq2 + st2

      total1 = idle1 + non1
      total2 = idle2 + non2

      dt = total2 - total1
      di = idle2 - idle1

      if (dt <= 0) { print "0.0"; exit }
      usage = (dt - di) * 100 / dt
      printf "%.1f", usage
    }'

    echo ""
    echo ""
    echo "u1 = $u1"
    echo "n1 = $n1"
    echo "st1 = $st1"
    echo "iw1 = $iw1"
}

print_title "CPU"
echo "Total CPU usage: $(cpu_usage)%"
echo ""
