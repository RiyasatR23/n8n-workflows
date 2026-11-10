#!/usr/bin/env bash
# Sends a sample lead to the AI lead qualifier.
# Usage: ./send-test-lead.sh https://your-n8n.example.com/webhook-test/lead-intake
URL="${1:-http://localhost:5678/webhook-test/lead-intake}"

curl -s -X POST "$URL" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Thandi Mokoena",
    "email": "thandi@example.co.za",
    "phone": "082 000 0000",
    "company": "Mokoena Plumbing",
    "message": "Hi, we need a new website with online booking and a WhatsApp chat. Hoping to launch before the end of the month. What would it cost?",
    "source": "website"
  }'
echo
