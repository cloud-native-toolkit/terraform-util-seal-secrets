#!/usr/bin/env bash

ls -l ./sealed-secrets

if [[ $(ls -l ./sealed-secrets | wc -l) -eq 0 ]]; then
  echo "Sealed secrets not found"
  exit 1
fi
