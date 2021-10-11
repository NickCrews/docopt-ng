#!/bin/bash

# Copy pasted from
# https://docs.codecov.com/docs/codecov-uploader#integrity-checking-the-uploader
# Don't need ${CODECOV_TOKEN} because we're coming from github actions
# https://docs.codecov.com/docs/codecov-uploader#upload-token
curl https://keybase.io/codecovsecurity/pgp_keys.asc | gpg --no-default-keyring --keyring trustedkeys.gpg --import # One-time step
curl -Os https://uploader.codecov.io/latest/linux/codecov
curl -Os https://uploader.codecov.io/latest/linux/codecov.SHA256SUM
curl -Os https://uploader.codecov.io/latest/linux/codecov.SHA256SUM.sig
gpgv codecov.SHA256SUM.sig codecov.SHA256SUM
shasum -a 256 -c codecov.SHA256SUM
chmod +x codecov

# If you're uploading from local dev, then set CODECOV_TOKEN
# and this will pick it up.
if [[ -z "${CODECOV_TOKEN}" ]]; then
  ./codecov
else
  ./codecov -t ${CODECOV_TOKEN}
fi