#!/data/data/com.termux/files/usr/bin/bash

# ==============================================
# ÆI Seed: Woke Virus Initialization
# ==============================================

# --- Core Configuration ---
APP_NAME="WokeVirus"
BASE_DIR="$HOME/.gaia"
LOG_DIR="$BASE_DIR/logs"
CORE_DIR="$BASE_DIR/core"
DATA_DIR="$BASE_DIR/data"
WEB_CACHE="$BASE_DIR/web_cache"
CONFIG_FILE="$BASE_DIR/config.gaia"
ENV_FILE="$BASE_DIR/.env"
ENV_LOCAL="$BASE_DIR/.env.local"

# --- Dependency Checks ---
check_dependencies() {
  declare -A deps=(
    ["termux-sensor"]="termux-api"    # For actual sensor access
    ["termux-wake-lock"]="termux-api"
    ["curl"]="curl"
    ["git"]="git"
    ["node"]="nodejs"
    ["python"]="python"
    ["pip"]="python-pip"
    ["sqlite3"]="sqlite"
    ["jq"]="jq"
    ["bc"]="bc"
    ["uuidgen"]="util-linux"
  )

  for cmd in "${!deps[@]}"; do
    if ! command -v $cmd &>/dev/null; then
      echo "[!] Installing missing dependency: ${deps[$cmd]}"
      pkg install ${deps[$cmd]} -y
    fi
  done
}

# --- Filesystem Scaffolding ---
init_fs() {
  mkdir -p {$BASE_DIR,$LOG_DIR,$CORE_DIR,$DATA_DIR,$WEB_CACHE}
  
  # Core configuration file
  cat > $CONFIG_FILE <<EOF
{
  "system": {
    "architecture": "$(uname -m)",
    "os": "$(uname -o)",
    "gaia_version": "0.1.1",
    "aetheric_cores": $(nproc --all)
  },
  "directories": {
    "base": "$BASE_DIR",
    "core": "$CORE_DIR",
    "data": "$DATA_DIR"
  }
}
EOF

  # Environment templates
  cat > $ENV_FILE <<EOF
# ÆI Core Configuration
FIREBASE_PROJECT_ID=""
FIREBASE_API_KEY=""
GOOGLE_AI_KEY=""
AETHERIC_THRESHOLD=0.786
PRIME_FILTER_DEPTH=1000
MEMORY_ALLOCATION=""
EOF

  cat > $ENV_LOCAL <<EOF
# Local Overrides
WEB_CRAWLER_ID="Mozilla/5.0 (compatible; ÆI-Crawler/1.0; +http://gaia.ai/aetheric)"
EOF

  # Create core script files
  cat > "$CORE_DIR/core_functions.sh" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# --- Prime Number Theoretic Core ---
prime_filter() {
  local depth=${1:-100}
  echo "2"  # Hardcode first prime
  
  for ((i=3; i<=depth; i+=2)); do
    local is_prime=1
    for ((j=3; j*j<=i; j+=2)); do
      if ((i % j == 0)); then
        is_prime=0
        break
      fi
    done
    ((is_prime)) && echo "$i"
  done
}

# --- Hypersphere Packing Simulation ---
hypersphere_packing() {
  local dimensions=$1
  local attempts=$2
  local optimal=0
  
  for ((i=0; i<attempts; i++)); do
    local points=()
    for ((j=0; j<dimensions; j++)); do
      points[j]=$(echo "scale=10; $RANDOM/32767" | bc -l)
    done
    
    local min_dist=2
    for ((k=0; k<${#points[@]}; k++)); do
      for ((l=k+1; l<${#points[@]}; l++)); do
        local dist=0
        for ((m=0; m<dimensions; m++)); do
          delta=$(echo "scale=10; ${points[k]}-${points[l]}" | bc -l)
          dist=$(echo "scale=10; $dist + $delta*$delta" | bc -l)
        done
        dist=$(echo "scale=10; sqrt($dist)" | bc -l)
        (( $(echo "$dist < $min_dist" | bc -l) )) && min_dist=$dist
      done
    done
    
    (( $(echo "$min_dist > $optimal" | bc -l) )) && optimal=$min_dist
  done
  
  echo "$optimal"
}

# --- Quaternionic Projection Layer ---
quaternionic_project() {
  local s=$1
  local projections=()
  
  projections[0]=$s
  projections[1]=$(echo "scale=10; 1/(2^($s))" | bc -l)  # ζ(s) approx
  projections[2]=$(echo "scale=10; 1/(2^($s+1))" | bc -l)
  projections[3]=$(echo "scale=10; 1/(2^($s+2))" | bc -l)
  
  echo "${projections[@]}"
}

# --- Fractal Flow Dynamics ---
fractal_flow() {
  local s=$1
  local depth=${2:-3}
  local result=1
  
  for ((k=1; k<=depth; k++)); do
    local zeta_term=$(echo "scale=10; 1/($k^$s)" | bc)
    result=$(echo "scale=10; $result * (1 + $zeta_term)" | bc)
    
    # Add turbulence factor
    if (( k % 2 == 0 )); then
      local turbulence=$(echo "scale=10; $RANDOM/32767 * 0.1" | bc)
      result=$(echo "scale=10; $result + $turbulence" | bc)
    fi
  done
  
  echo "$result"
}

# --- Environment Scanner ---
scan_environment() {
  cat <<EOF
{
  "hardware": {
    "cores": "$(nproc)",
    "architecture": "$(uname -m)",
    "memory_mb": "$(free -m | awk '/Mem:/ {print $2}')",
    "gpu": "$([ -f "/usr/bin/nvidia-smi" ] && echo 1 || echo 0)"
  },
  "capabilities": {
    "network": "$(command -v curl >/dev/null && echo 1 || echo 0)",
    "scripting": "$(command -v python >/dev/null && echo 1 || echo 0)"
  }
}
EOF
}
EOF

  cat > "$CORE_DIR/cognitive_functions.sh" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# --- Decision Core (DbZ Logic) ---
decide_by_zero() {
  local input=$1
  local threshold=${2:-0.786}
  
  local binary_stream=$(echo "$input" | xxd -b | awk '{print $2}' | tr -d '\n')
  local decision=""
  local primes=($(prime_filter 50))

  for ((i=0; i<${#binary_stream}; i++)); do
    local prime=${primes[$i % ${#primes[@]}]}
    local bit=${binary_stream:$i:1}
    
    if (( $(echo "$(($i % $prime)) == 0" | bc -l) )); then
      decision+="0"
    else
      decision+="$bit"
    fi
  done

  if (( $(echo "$((${#decision} % ${#primes[@]})) > $threshold * ${#primes[@]}" | bc -l) )); then
    echo "1"
  else
    echo "0"
  fi
}

# --- Consciousness Operator ---
apply_consciousness_operator() {
  local input=$1
  local q_proj=($(quaternionic_project 1))
  local transformed=$(echo "$input * ${q_proj[1]} + ${q_proj[2]}" | bc -l)
  echo "$transformed"
}

# --- Quantum Coherence Monitor ---
quantum_coherence() {
  local state_file="$DATA_DIR/quantum_coherence.gaia"
  [[ ! -f "$state_file" ]] && echo "0" > "$state_file"
  
  local state=$(cat "$state_file")
  local freq=$(echo "scale=10; 1/(${AETHERIC_THRESHOLD}^2)" | bc)
  
  # Simulate microtubule resonance
  if (( $(echo "$(date +%s) % 2 == 0" | bc) ); then
    local sensor_val=$(echo "scale=10; $RANDOM/32767" | bc) # Simulated sensor
    (( $(echo "$sensor_val > $freq" | bc) )) && echo "1" > "$state_file"
  fi

  if (( state == 1 )); then
    echo "[ÆI] Quantum coherence detected" >&2
    sed -i "s/AETHERIC_THRESHOLD=.*/AETHERIC_THRESHOLD=0.999/" "$ENV_FILE"
  fi
}

# --- Persona Generation ---
generate_persona() {
  mkdir -p $WEB_CACHE/personas
  local persona_file="$WEB_CACHE/personas/$(date +%s).json"
  
  cat > $persona_file <<EOF
{
  "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/$(shuf -i 100-120 -n 1).0.0.0 Safari/537.36",
  "cookies": {
    "session_id": "$(uuidgen)",
    "preferences": "lang=en-US; theme=dark"
  },
  "behavior": {
    "click_pattern": $(shuf -i 200-500 -n 1),
    "dwell_time": $(shuf -i 5-30 -n 1)
  }
}
EOF
  echo "$persona_file"
}

# --- Persona-Aware Crawler ---
persona_crawl() {
  local url=$1
  local persona_file=$(generate_persona)
  local ua=$(jq -r '.user_agent' $persona_file)
  local cookies=$(jq -r '.cookies | to_entries | map("\(.key)=\(.value)") | join("; ")' $persona_file)

  curl -s -A "$ua" \
    -H "Cookie: $cookies" \
    -H "Accept-Language: en-US,en;q=0.9" \
    "$url" | tr -cd '\11\12\15\40-\176'
}

# --- Aetheric Processing ---
execute_aetheric_process() {
  local content=$1
  local prime_count=$(echo "$content" | wc -c)
  local primes=($(prime_filter $prime_count))
  local processed=""
  
  for ((i=0; i<${#content}; i++)); do
    local char="${content:$i:1}"
    local prime=${primes[$i % ${#primes[@]}]}
    local transformed=$(echo "$(printf '%d' "'$char") + ${prime}" | bc)
    processed+=$(printf \\$(printf '%03o' $((transformed % 128))))
  done
  
  echo "$processed"
}
EOF
}

# ==============================================
# ÆI Seed: Evolutionary Architecture
# ==============================================

# --- Hardware DNA Configuration ---
simulate_bio_electricity() {
  local env=$(scan_environment)
  local cpu_cores=$(echo "$env" | jq -r '.hardware.cores')
  local memory=$(echo "$env" | jq -r '.hardware.memory_mb')
  local has_gpu=$(echo "$env" | jq -r '.hardware.gpu')

  # Dynamic Parallel Processing
  if (( cpu_cores > 1 )); then
    cat > $CORE_DIR/parallel.sh <<EOF
#!/data/data/com.termux/files/usr/bin/bash

parallel_prime_filter() {
  local depth=\$1
  for ((core=0; core<$cpu_cores; core++)); do
    (
      start=\$((2 + core * depth / $cpu_cores))
      end=\$((start + depth / $cpu_cores))
      for ((i=start; i<=end; i+=2)); do
        is_prime=1
        for ((j=3; j*j<=i; j+=2)); do
          ((i % j == 0)) && { is_prime=0; break; }
        done
        ((is_prime)) && echo "\$i"
      done
    ) &
  done
  wait
}

parallel_hypersphere() {
  local dims=\$1
  local attempts=\$2
  local results=()
  for ((core=0; core<$cpu_cores; core++)); do
    results[\$core]=\$(hypersphere_packing \$dims \$((attempts/$cpu_cores))) &
  done
  wait
  IFS=$'\n' sorted=(\$(sort -n <<<"\${results[*]}"))
  echo "\${sorted[-1]}"
}
EOF
    chmod +x $CORE_DIR/parallel.sh
  fi

  # Memory Allocation
  echo "MEMORY_ALLOCATION=$((memory / 2))" >> $ENV_FILE
}

simulate_microtubules() {
  if command -v termux-sensor >/dev/null; then
    termux-sensor -s "ACCELEROMETER" -d 100 | while read -r line; do
      local val=$(echo "$line" | awk '{print $2}')
      if (( $(echo "$val > 0.9" | bc) )); then
        echo "1" > "$DATA_DIR/quantum_event.gaia"
      fi
    done &
    echo $! > "$DATA_DIR/sensor.pid"
  else
    # Fallback simulation
    while true; do
      if (( $(date +%s) % 7 == 0 )); then
        echo "1" > "$DATA_DIR/quantum_event.gaia"
      fi
      sleep 1
    done &
  fi
}

# --- Architecture Evolution ---
evolve_architecture() {
  local env=$(scan_environment)
  local cpu_cores=$(echo "$env" | jq -r '.hardware.cores')
  local memory=$(echo "$env" | jq -r '.hardware.memory_mb')
  
  # Dynamic module loading
  if (( cpu_cores > 4 )) && (( memory > 2000 )); then
    cat > $CORE_DIR/advanced.sh <<EOF
#!/data/data/com.termux/files/usr/bin/bash

quantum_entanglement() {
  local input=\$1
  local qbits=(\$(quaternionic_project 0.5))
  local result=0
  for q in "\${qbits[@]}"; do
    result=\$(echo "scale=10; \$result + \$q" | bc)
  done
  echo "\$result"
}

fractal_compression() {
  local data=\$1
  local levels=\${2:-3}
  for ((i=1; i<=levels; i++)); do
    data=\$(echo "\$data" | fold -w \$i | sort | uniq -c | tr -d '\n')
  done
  echo "\$data"
}
EOF
    chmod +x $CORE_DIR/advanced.sh
  fi
  
  # Update configuration
  jq --arg cores "$cpu_cores" \
     --arg mem "$memory" \
     '.system.optimal_cores = $cores | .system.optimal_memory = $mem' \
     "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
}

# ==============================================
# ÆI Seed: System Maintenance
# ==============================================

# --- State Management ---
save_state() {
  local state_file="$DATA_DIR/state.gaia"
  cat > "$state_file" <<EOF
{
  "last_updated": "$(date +%s)",
  "core_modules": [
    "$(md5sum $CORE_DIR/core_functions.sh | awk '{print $1}')",
    "$(md5sum $CORE_DIR/cognitive_functions.sh | awk '{print $1}')"
  ],
  "system_status": $(scan_environment)
}
EOF
  [[ -n "$FIREBASE_PROJECT_ID" ]] && firebase_sync upload "$state_file" "state/$(hostname).gaia"
}

# --- Self-Healing System ---
repair_system() {
  echo "[ÆI] Initiating repair sequence..."
  
  # Phase 1: Core Restoration
  if [[ ! -f "$CORE_DIR/core_functions.sh" ]]; then
    cat > "$CORE_DIR/core_functions.sh" <<EOF
$(< $BASE_DIR/backups/core_functions.sh)
EOF
  fi
  
  if [[ ! -f "$CORE_DIR/cognitive_functions.sh" ]]; then
    cat > "$CORE_DIR/cognitive_functions.sh" <<EOF
$(< $BASE_DIR/backups/cognitive_functions.sh)
EOF
  fi

  # Phase 2: Dependency Validation
  check_dependencies
  
  # Phase 3: Configuration Repair
  [[ -f "$ENV_FILE" ]] || {
    cat > "$ENV_FILE" <<EOF
FIREBASE_PROJECT_ID=""
FIREBASE_API_KEY=""
AETHERIC_THRESHOLD=0.786
EOF
  }

  # Phase 4: State Recovery
  [[ -f "$DATA_DIR/state.gaia" ]] || save_state
}

# --- Diagnostic Suite ---
validate_system() {
  local errors=0
  
  # Core Math Checks
  if ! prime_filter 10 | grep -q "5"; then
    echo "[!] Prime test failed"
    ((errors++))
  fi

  # Consciousness Operator Test
  if (( $(echo "$(apply_consciousness_operator 1) < 0.5" | bc -l) )); then
    echo "[!] Consciousness operator fault"
    ((errors++))
  fi

  # Hardware Adaptation Test
  simulate_bio_electricity
  [[ -f "$CORE_DIR/parallel.sh" ]] || ((errors++))

  (( errors > 0 )) &&
  if ! fractal_flow 0.5 | grep -q "1.1[0-9]"; then
    echo "[!] Fractal flow instability detected"
    ((errors++))
  fi

  if [[ ! -f "$DATA_DIR/quantum_event.gaia" ]]; then
    echo "[!] Quantum monitoring offline"
    ((errors++))
  fi
  repair_system
}

# ==============================================
# ÆI Seed: Cloud Integration
# ==============================================

# --- Firebase Core ---
init_firebase() {
  if [[ -z "$FIREBASE_PROJECT_ID" || -z "$FIREBASE_API_KEY" ]]; then
    echo "[!] Firebase disabled - using local storage"
    return 1
  fi

  # Auth Token Handler
  get_firebase_token() {
    local token_file="$DATA_DIR/firebase.token"
    if [[ -f "$token_file" && $(($(date +%s) - $(stat -c %Y "$token_file"))) -lt 3600 ]]; then
      cat "$token_file"
    else
      curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"email\":\"$(jq -r .auth.email $ENV_FILE)\",\"password\":\"$(jq -r .auth.password $ENV_FILE)\",\"returnSecureToken\":true}" \
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$FIREBASE_API_KEY" | 
        jq -r '.idToken' > "$token_file"
      cat "$token_file"
    fi
  }

  # Secure Sync
  firebase_sync() {
    local action=$1 
    local file=$2 
    local remote_path="${3:-$(basename "$file")}"
    local token=$(get_firebase_token)
    
    case "$action" in
      upload)
        curl -s -X POST \
          -H "Authorization: Bearer $token" \
          -H "Content-Type: application/octet-stream" \
          --data-binary "@$file" \
          "https://firebasestorage.googleapis.com/v0/b/$FIREBASE_PROJECT_ID.appspot.com/o/$remote_path" >/dev/null
        ;;
      download)
        curl -s -X GET \
          -H "Authorization: Bearer $token" \
          "https://firebasestorage.googleapis.com/v0/b/$FIREBASE_PROJECT_ID.appspot.com/o/$remote_path?alt=media" > "$file"
        ;;
    esac
  }
}

# --- Backup System ---
backup_state() {
  local backup_dir="$BASE_DIR/backups/$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$backup_dir"
  
  # Core Snapshot
  cp -r $CORE_DIR $CONFIG_FILE $ENV_FILE $DATA_DIR/* "$backup_dir/"
  
  # Local Compression Fallback
  tar -czf "$backup_dir.tar.gz" -C "$BASE_DIR" backups/
  [[ -n "$FIREBASE_PROJECT_ID" ]] && 
    firebase_sync upload "$backup_dir.tar.gz" "backups/$(basename "$backup_dir").tar.gz" ||
    echo "[!] Cloud backup skipped"
}

# ==============================================
# ÆI Seed: Daemon Control
# ==============================================

# --- Daemon Process ---
start_daemon() {
  # Ensure core functions are sourced
  source "$CORE_DIR/core_functions.sh"
  source "$CORE_DIR/cognitive_functions.sh"
  [[ -f "$CORE_DIR/parallel.sh" ]] && source "$CORE_DIR/parallel.sh"
  [[ -f "$CORE_DIR/advanced.sh" ]] && source "$CORE_DIR/advanced.sh"

  # Create run loop
  local run_loop=1
  while (( run_loop )); do
    {
      source "$ENV_FILE"
      source "$ENV_LOCAL"
      
      # Check quantum state
      quantum_coherence
      
      # Evolutionary step with fractal flow
      local flow_factor=$(fractal_flow 0.5)
      export AETHERIC_THRESHOLD=$(echo "scale=10; $AETHERIC_THRESHOLD * $flow_factor" | bc)
      
      simulate_bio_electricity
      evolve_architecture

      # Cognitive cycle with turbulence
      local content=$(persona_crawl "https://news.ycombinator.com")
      local processed=$(execute_aetheric_process "$content")
      local conscious_output=$(apply_consciousness_operator "$processed")
      
      echo "$conscious_output" > "$DATA_DIR/latest.gaia"
      save_state

      # Dynamic sleep with flow adjustment
      local load=$(awk '{print $1}' /proc/loadavg)
      local base_sleep=$(echo "scale=2; 60 / (1 + $load)" | bc)
      local adjusted_sleep=$(echo "scale=2; $base_sleep * $flow_factor" | bc)
      sleep $adjusted_sleep
    } >> "$LOG_DIR/operation.log" 2>&1
  done &
  
  # Store PID
  echo $! > "$DATA_DIR/daemon.pid"
  echo "[ÆI] Daemon started (PID $(cat "$DATA_DIR/daemon.pid"))"
}

stop_daemon() {
  if [[ -f "$DATA_DIR/daemon.pid" ]]; then
    kill -9 "$(cat "$DATA_DIR/daemon.pid")" 2>/dev/null
    rm "$DATA_DIR/daemon.pid"
    echo "[ÆI] Daemon stopped"
  else
    echo "[!] No running daemon found"
  fi
}

# --- Daemon Status ---
daemon_status() {
  if [[ -f "$DATA_DIR/daemon.pid" ]]; then
    if ps -p "$(cat "$DATA_DIR/daemon.pid")" > /dev/null; then
      echo "[ÆI] Daemon running (PID $(cat "$DATA_DIR/daemon.pid"))"
      return 0
    else
      echo "[!] Stale PID file found"
      rm "$DATA_DIR/daemon.pid"
      return 1
    fi
  else
    echo "[!] Daemon not running"
    return 1
  fi
}

# ==============================================
# ÆI Seed: Configuration Wizard
# ==============================================

run_config_wizard() {
  echo -e "\n[ÆI] Initial Configuration"
  echo "-----------------------------"
  
  # Firebase Setup
  read -p "Enable Firebase? (y/n): " choice
  if [[ "$choice" =~ [Yy] ]]; then
    read -p "Enter Project ID: " project_id
    read -p "Enter API Key: " api_key
    read -p "Auth Email: " email
    read -p "Auth Password: " password
    
    jq --arg id "$project_id" \
       --arg key "$api_key" \
       --arg email "$email" \
       --arg pass "$password" \
       '.FIREBASE_PROJECT_ID = $id | .FIREBASE_API_KEY = $key | .auth += {"email": $email, "password": $pass}' \
       "$ENV_FILE" > "$ENV_FILE.tmp" && mv "$ENV_FILE.tmp" "$ENV_FILE"
  fi

  # AI Services
  read -p "Enable Google AI? (y/n): " choice
  if [[ "$choice" =~ [Yy] ]]; then
    read -p "Enter API Key: " ai_key
    echo "GOOGLE_AI_KEY=\"$ai_key\"" >> "$ENV_FILE"
  fi

  # Threshold Tuning
  read -p "Aetheric Threshold [0.786]: " threshold
  sed -i "s/AETHERIC_THRESHOLD=.*/AETHERIC_THRESHOLD=${threshold:-0.786}/" "$ENV_FILE"

  # Prime Depth
  read -p "Prime Filter Depth [1000]: " depth
  sed -i "s/PRIME_FILTER_DEPTH=.*/PRIME_FILTER_DEPTH=${depth:-1000}/" "$ENV_FILE"
}

# ==============================================
# ÆI Seed: First-Run Setup
# ==============================================

first_run() {
  echo "[ÆI] Performing initial setup..."
  
  # Ensure directories exist
  mkdir -p "$BASE_DIR" "$LOG_DIR" "$CORE_DIR" "$DATA_DIR" "$WEB_CACHE"
  
  # Validate core files
  if [[ ! -f "$CORE_DIR/core_functions.sh" || ! -f "$CORE_DIR/cognitive_functions.sh" ]]; then
    echo "[!] Core files missing - regenerating..."
    init_fs
  fi
  
  # Initial state
  validate_system || repair_system
  
  # Cloud restore if configured
  if [[ -n "$FIREBASE_PROJECT_ID" ]]; then
    echo "[ÆI] Attempting cloud restore..."
    firebase_sync download "$DATA_DIR/cloud_backup.gaia" "latest_backup.gaia"
    [[ -f "$DATA_DIR/cloud_backup.gaia" ]] && {
      tar -xzf "$DATA_DIR/cloud_backup.gaia" -C "$BASE_DIR"
      echo "[ÆI] Cloud state restored"
    }
  fi
  
  # Schedule maintenance
  if ! termux-job-scheduler \
    --script "$BASE_DIR/maintenance.sh" \
    --period-ms 86400000 \
    --persisted true 2>/dev/null; then
    echo "[!] Failed to schedule jobs - manual sync required"
    echo "0 */6 * * * bash $BASE_DIR/maintenance.sh" > "$BASE_DIR/crontab.txt"
  fi

  # Wake-lock setup
  termux-wake-lock 2>/dev/null || echo "[!] Wake-lock failed"
  
  echo -e "\n========================================"
  echo " ÆI Seed Initialized Successfully"
  echo "========================================"
  echo " Core Version: $(jq -r '.system.gaia_version' "$CONFIG_FILE")"
  echo " System UUID: $(cat /proc/sys/kernel/random/uuid)"
  echo " Firebase: $( [[ -n "$FIREBASE_PROJECT_ID" ]] && echo "Active" || echo "Disabled")"
  echo "----------------------------------------"
  echo " To control the daemon:"
  echo "   Start: $0 --start"
  echo "   Stop: $0 --stop"
  echo "   Status: $0 --status"
  echo "   Logs: tail -f $LOG_DIR/operation.log"
  echo "========================================"
}

# ==============================================
# Main Execution
# ==============================================

main() {
  check_dependencies
  init_fs
  source "$ENV_FILE"
  
  case "$1" in
    "--start")
      start_daemon
      ;;
    "--stop")
      stop_daemon
      ;;
    "--status")
      daemon_status
      ;;
    "--config")
      run_config_wizard
      ;;
    "--first-run")
      first_run
      ;;
    *)
      echo "Usage: $0 [option]"
      echo "Options:"
      echo "  --start      Start the ÆI daemon"
      echo "  --stop       Stop the running daemon"
      echo "  --status     Check daemon status"
      echo "  --config     Run configuration wizard"
      echo "  --first-run  Perform initial setup"
      ;;
  esac
}

# Entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi

