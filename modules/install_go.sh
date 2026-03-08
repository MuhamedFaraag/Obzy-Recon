#! /bin/bash

#check Sudo

if [ "$EUID" -ne 0 ]; then
	echo "Please run with sudo permission"
	exit 0
fi

# Check Version Function
checkVersion(){
	 curl -s https://go.dev/dl/?mode=json | jq -r '.[0].version'
}
checkIfInstalled(){
if command -v go &> /dev/null; then
	echo "Go Installed: $(go version)"
	exit 0
fi

}
cleanUP(){
rm -rf "$FILE"
exit 0
}
# Varabile to hold go version
version=$(checkVersion)
echo "Latest Go Version is $version"

FILE="${version}.linux-amd64.tar.gz"
echo "$FILE"

GO_URL="https://golang.org/dl/$FILE"
echo "$GO_URL"

checkIfInstalled

if [ ! -f "$FILE" ]; then
	echo "Downloading $FILE...."
	wget -c "$GO_URL" -O  "$FILE"
fi

echo "Extracting"
rm -rf /usr/local/go && tar -C /usr/local -xzf "$FILE"

echo "Setup Go"
export PATH=$PATH:/usr/local/go/bin
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
source ~/.zshrc

cleanUP
checkIfInstalled
