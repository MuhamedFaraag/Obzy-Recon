#! /bin/bash

# Check Version Function
checkVersion(){
	 curl -s https://go.dev/dl/?mode=json | jq -r '.[0].version'
}

# Varabile to hold go version
version=$(checkVersion)
echo "Latest Go Version is $version"

FILE="${version}.linux-amd64.tar.gz"
echo "$FILE"

GO_URL="https://golang.org/dl/$FILE"
echo "$GO_URL"

if command -v go &> /dev/null; then
	echo "Go installed: $(go version)"
	exit 0
fi

if [ ! -f "$FILE" ]; then
	echo "Downloading $FILE...."
	wget -c "$GO_URL" -O  "$FILE"
fi 
# go1.26.1
# go1.26.1.linux-amd64.tar.gz
# https://golang.org/dl/go1.26.1.linux-amd64.tar.gz

