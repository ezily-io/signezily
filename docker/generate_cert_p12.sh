#!/bin/bash

# Function to check if OpenSSL is installed
check_openssl_installed() {
  if ! command -v openssl &> /dev/null; then
    echo "OpenSSL is not installed. Please install it and try again."
    exit 1
  fi
}

# Generate the PKCS#12 file
generate_pkcs12() {
  echo "Creating PKCS#12 file..."
  openssl pkcs12 -export -out "$NEXT_PRIVATE_SIGNING_LOCAL_FILE_PATH" \
    -inkey <(echo "$SIGN_PRIV_KEY_FILE") \
    -in <(echo "$SIGN_CERT_FILE") \
    -name "$SIGN_CERT_NAME" \
    -passout pass:"$SIGN_PRIV_KEY_PASS"

  if [ $? -ne 0 ]; then
    echo "Failed to create PKCS#12 file."
    exit 1
  fi
  echo "PKCS#12 file created: $NEXT_PRIVATE_SIGNING_LOCAL_FILE_PATH"
}

# Main function
main() {
  # openssl_installation
  check_openssl_installed
  generate_pkcs12
  echo "Process complete. PKCS#12 file: $NEXT_PRIVATE_SIGNING_LOCAL_FILE_PATH"
}

# Run the script
main