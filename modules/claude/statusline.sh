#!/usr/bin/env bash
input=$(cat)

# JSON field accessor via python3 (no jq dependency)
j() { printf '%s' "$input" | python3 -c "
import sys,json
v=json.load(sys.stdin)
for k in '$1'.split('.'):
  v=v.get(k) if isinstance(v,dict) else None
  if v is None: sys.exit(0)
print(v)" 2>/dev/null; }

# ANSI
R='\033[0m' B='\033[1m' G='\033[38;5;245m' BL='\033[38;5;75m'

# Gradient: green(0%) -> yellow(50%) -> orange(75%) -> red(100%)
gc() {
  local p=$(printf "%.0f" "$1" 2>/dev/null || echo 0)
  if (( p <= 50 )); then printf '\033[38;2;%d;255;0m' $(( p*255/50 ))
  elif (( p <= 75 )); then printf '\033[38;2;255;%d;0m' $(( 255-(p-50)*90/25 ))
  else local g=$(( 165-(p-75)*165/25 )); printf '\033[38;2;255;%d;0m' $(( g<0?0:g ))
  fi
}

# Progress bar: $1=pct $2=width $3=fill $4=empty
bar() {
  local p=$(printf "%.0f" "$1" 2>/dev/null || echo 0) f="" e="" i
  (( p>100 )) && p=100
  local n=$(( p*$2/100 )) m=$(( $2-p*$2/100 ))
  for ((i=0;i<n;i++)); do f+="$3"; done
  for ((i=0;i<m;i++)); do e+="$4"; done
  printf "$(gc "$p")${f}${G}${e}${R}"
}

# Countdown from unix epoch
cd_() {
  [ -z "$1" ] && return
  local d=$(( $1 - $(date +%s) )); (( d<0 )) && d=0
  local h=$(( d/3600 )) m=$(( d%3600/60 ))
  (( h>0 )) && printf "↻%dh%02d" "$h" "$m" || printf "↻%dm" "$m"
}

# Rate limit segment: $1=label $2=pct $3=resets_at
rl() {
  [ -z "$2" ] && return
  local c=$(gc "$2") p=$(printf "%.0f" "$2")
  printf "${G}%s ${R}%s ${c}%s%%${R} ${G}%s${R}" "$1" "$(bar "$2" 5 "▮" "▯")" "$p" "$(cd_ "$3")"
}

# Segments
model=$(j model.display_name); : "${model:=Unknown}"
cwd=$(j workspace.current_dir); : "${cwd:=$(j cwd)}"
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null ||
  git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null || true)
used=$(j context_window.used_percentage)
cost=$(j cost.total_cost_usd)

P=" ${G}│${R} "
out="${B}${model}${R}"
out+="${P}${G}$(basename "$cwd")${R}"
[ -n "$branch" ] && out+=" ${G}->${R} ${BL}${branch}${R}"
if [ -n "$used" ]; then
  out+="${P}$(bar "$used" 5 "█" "░") $(gc "$used")$(printf "%.0f" "$used")%${R}"
else
  out+="${P}${G}░░░░░ --%${R}"
fi
[ -n "$cost" ] && out+="${P}${G}$(printf '$%.2f' "$cost")${R}"
seg5=$(rl "5h" "$(j rate_limits.five_hour.used_percentage)" "$(j rate_limits.five_hour.resets_at)")
seg7=$(rl "7d" "$(j rate_limits.seven_day.used_percentage)" "$(j rate_limits.seven_day.resets_at)")
[ -n "$seg5" ] && out+="${P}${seg5}"
[ -n "$seg7" ] && out+="${P}${seg7}"

printf "%b\n" "$out"
