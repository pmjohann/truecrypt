# Truecrypt from sources
Compile TrueCrypt from sources in Docker container

## TODO

- [] Use multi-stage build to copy the compiled binary to a lean container
- [] Remove wxWidgets external dependency (omit curl call), include tar.gz in this repo
- [] Use git patches instead of ugly in-place sed replacements
