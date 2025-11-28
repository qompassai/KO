#!/bin/sh
# quicktest.sh
# Qompass AI KO Quick Test
# Copyright (C) 2025 Qompass AI, All rights reserved
set -eu
OPENSSL_CONF=${OPENSSL_CONF:-/opt/qai/qompassl/ssl/openssl.cnf}
OPENSSL_MODULES=${OPENSSL_MODULES:-/opt/qompassl/lib64/ossl-modules}
export OPENSSL_CONF OPENSSL_MODULES
PROVIDERS="-provider default"
WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT INT TERM HUP
REPORT="$WORKDIR/report.md"
(
	printf '| Algorithm | Key-gen | Sign | Verify | Notes |\n'
	printf '|-----------|--------|------|--------|-------|\n'
) >"$REPORT"
TMPALG="$WORKDIR/algs.txt"
openssl list -signature-algorithms $PROVIDERS |
	awk -F '@' '{print $1}' | sed 's/^ *//;s/ *$//' | sort -u >"$TMPALG"
while IFS= read -r ALG; do
	# Replace spaces with _
	SAFEALG=$(printf '%s' "$ALG" | tr ' /' '_-')
	KEY="$WORKDIR/$SAFEALG.key"
	PUB="$WORKDIR/$SAFEALG.pub"
	SIG="$WORKDIR/$SAFEALG.sig"
	MSG="$WORKDIR/msg.txt"
	printf 'Quantum-test\n' >"$MSG"
	keygen_status="FAIL"
	sign_status="FAIL"
	verify_status="FAIL"
	notes=""
	printf "testing %-30s ... " "$ALG"
	if openssl genpkey -algorithm "$ALG" -out "$KEY" $PROVIDERS 2>/dev/null; then
		keygen_status="OK"
		if openssl pkeyutl -sign -inkey "$KEY" -in "$MSG" -out "$SIG" $PROVIDERS 2>/dev/null; then
			sign_status="OK"
			# Export public key and verify
			if openssl pkey -in "$KEY" -pubout -out "$PUB" $PROVIDERS 2>/dev/null; then
				if openssl pkeyutl -verify -pubin -inkey "$PUB" -in "$MSG" -sigfile "$SIG" $PROVIDERS 2>/dev/null; then
					verify_status="OK"
				fi
			fi
		fi
	fi
	if [ "$keygen_status" != "OK" ]; then
		notes="❌ Key-gen failed → algorithm not enabled or provider missing"
	elif [ "$sign_status" != "OK" ]; then
		notes="❌ Sign failed → $ALG may be KEM-only (no signing)"
	elif [ "$verify_status" != "OK" ]; then
		notes="❌ Verify failed → probable provider mismatch"
	else
		notes="✅ All good"
	fi
	printf '| `%s` | %s | %s | %s | %s |\n' \
		"$ALG" "$keygen_status" "$sign_status" "$verify_status" "$notes" >>"$REPORT"
	echo "done"
done <"$TMPALG"
cat "$REPORT"
