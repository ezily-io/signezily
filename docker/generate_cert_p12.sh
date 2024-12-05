#!/bin/bash

PRIVATE_KEY="sign_priv_key.key"
CERTIFICATE="sign_certificate.crt"

# Function to check if OpenSSL is installed
check_openssl_installed() {
  if ! command -v openssl &> /dev/null; then
    echo "OpenSSL is not installed. Please install it and try again."
    exit 1
  fi
}

# Generate the PKCS#12 file
generate_pkcs12() {   
  cd apps
  echo "$SIGN_PRIV_KEY_FILE" > $PRIVATE_KEY
  echo "$SIGN_CERT_FILE" > $CERTIFICATE
  chown nextjs:nodejs $PRIVATE_KEY
  chown nextjs:nodejs $CERTIFICATE
  chmod 600 $PRIVATE_KEY
  chmod 600 $CERTIFICATE
  echo "Creating PKCS#12 file..."
  openssl pkcs12 -export -out "$NEXT_PRIVATE_SIGNING_LOCAL_FILE_PATH" \
    -inkey "$PRIVATE_KEY" \
    -in "$CERTIFICATE" \
    -name "$SIGN_CERT_NAME" \
    -passout pass:"$SIGN_PRIV_KEY_PASS"

  # openssl pkcs12 -export -out "/app/apps/sing_ezily_cert.p12" -inkey sign_priv_key.key -in "sign_certificate.crt" -name "SIGN_EZLY" -passout pass:""

  if [ $? -ne 0 ]; then
    echo "Failed to create PKCS#12 file."
    exit 1
  fi
  echo "PKCS#12 file created: $NEXT_PRIVATE_SIGNING_LOCAL_FILE_PATH"

  #Remove
  # rm "$PRIVATE_KEY"
  # rm "$CERTIFICATE"
  # unset SIGN_PRIV_KEY_FILE
  # unset SIGN_CERT_FILE
  # unset SIGN_PRIV_KEY_PASS

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