#!/usr/bin/env bash

printf "Running setup...\n"
if ! sudo -E ./scripts/oqsprep.sh; then
    printf "Setup failed. Exiting.\n"
    exit 1
fi

printf "Setup completed successfully. Running tests...\n"
if ! sudo -E ./scripts/runtests.sh; then
    printf "Tests failed. Exiting.\n"
    exit 1
fi

printf "Running additional tests...\n"
if ! sudo -E pytest ./scripts/test_tls_full.py; then
    printf "Additional tests failed. Exiting.\n"
    exit 1
fi

printf "All tasks completed successfully.\n"
