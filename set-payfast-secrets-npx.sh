#!/bin/bash

# Set PayFast credentials using npx (no Docker needed!)
# This only works for remote Supabase operations (login, link, secrets)

set -e

echo "🔐 Setting PayFast credentials using npx supabase..."
echo ""

# Check if npx is available
if ! command -v npx &> /dev/null; then
  echo "❌ npx not found. Please install Node.js first."
  exit 1
fi

# PayFast PRODUCTION credentials
PAYFAST_MERCHANT_ID="30921435"
PAYFAST_MERCHANT_KEY="pbwun2rxgmavh"
PAYFAST_MODE="production"
PAYFAST_TEST_EMAIL="test@edudashpro.org.za"

echo "⚠️  Using PRODUCTION credentials - these will process REAL payments!"
echo ""

# Login first (if not already logged in)
echo "📝 Logging into Supabase..."
npx supabase login

# Link to project
echo "📝 Linking to project..."
npx supabase link --project-ref lvvvjywrmpcqrpvuptdi

# Set secrets
echo "📝 Setting PayFast secrets..."
npx supabase secrets set PAYFAST_MODE="${PAYFAST_MODE}"
npx supabase secrets set PAYFAST_MERCHANT_ID="${PAYFAST_MERCHANT_ID}"
npx supabase secrets set PAYFAST_MERCHANT_KEY="${PAYFAST_MERCHANT_KEY}"
npx supabase secrets set PAYFAST_TEST_EMAIL="${PAYFAST_TEST_EMAIL}"

echo ""
echo "⚠️  IMPORTANT: Production mode REQUIRES passphrase!"
echo "   Get it from: PayFast Dashboard → Settings → Integration → Passphrase"
echo ""
read -p "Do you have the PayFast passphrase? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "Enter PayFast Passphrase: " -s PAYFAST_PASSPHRASE
  echo ""
  npx supabase secrets set PAYFAST_PASSPHRASE="${PAYFAST_PASSPHRASE}"
  echo "✅ PayFast passphrase set"
else
  echo "⚠️  Remember to set PAYFAST_PASSPHRASE before processing live payments!"
  echo "   Run: npx supabase secrets set PAYFAST_PASSPHRASE=<your-passphrase>"
fi

echo ""
echo "✅ PayFast secrets set successfully!"
echo ""
echo "📋 Summary:"
echo "   Mode: ${PAYFAST_MODE} (PRODUCTION)"
echo "   Merchant ID: ${PAYFAST_MERCHANT_ID}"
echo "   Merchant Key: ${PAYFAST_MERCHANT_KEY:0:4}...${PAYFAST_MERCHANT_KEY: -4}"
echo ""
echo "🔍 Verify secrets:"
echo "   npx supabase secrets list | grep PAYFAST"
echo ""


