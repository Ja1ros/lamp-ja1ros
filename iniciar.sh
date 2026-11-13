#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

if ! docker compose version >/dev/null 2>&1; then
    echo "Instala Docker y el complemento Docker Compose v2." >&2
    exit 1
fi

if [[ ! -e .env ]]; then
    umask 077
    env_temporal=$(mktemp .env.XXXXXX)
    trap 'rm -f -- "$env_temporal"' EXIT
    clave_usuario=$(openssl rand -hex 24)
    clave_root=$(openssl rand -hex 24)
    sed -e "s/^MYSQL_PASSWORD=$/MYSQL_PASSWORD=$clave_usuario/" \
        -e "s/^MYSQL_ROOT_PASSWORD=$/MYSQL_ROOT_PASSWORD=$clave_root/" \
        .env.example > "$env_temporal"
    ln -- "$env_temporal" .env
    # Permit local editing when invoked through sudo.
    if [[ -n ${SUDO_UID:-} && -n ${SUDO_GID:-} ]]; then
        chown "$SUDO_UID:$SUDO_GID" .env
    fi
fi

docker compose config --quiet
docker compose up -d --wait --wait-timeout 180
docker compose ps
