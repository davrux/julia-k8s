#!/usr/bin/env bash
#

kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets -o yaml <rclone-secret.yaml >sealed-rclone-secret.yaml

