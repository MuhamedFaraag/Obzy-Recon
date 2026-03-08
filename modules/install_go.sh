#!/bin/bash

# ─────────────────────────────────────────
#           GO INSTALLER MODULE
# ─────────────────────────────────────────

# ── Privilege Check ──────────────────────
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo "❌ Please run with sudo permission"
        exit 1
    fi
}

# ── Fetch Latest Go Version from API ─────
check_version() {
    curl -s "https://go.dev/dl/?mode=json" | jq -r '.[0].version'
}

# ── Check if Go is Already Installed ─────
check_if_installed() {
    if command -v go &> /dev/null; then
        echo "✅ Go is already installed: $(go version)"
        return 0
    fi
    return 1
}

# ── Remove Downloaded Tarball ─────────────
clean_up() {
    echo "🧹 Cleaning up $FILE..."
    rm -rf "$FILE"
}

# ── Download Go Tarball ───────────────────
download_go() {
    if [ ! -f "$FILE" ]; then
        echo "⬇️  Downloading $FILE..."
        wget -c "$GO_URL" -O "$FILE"
    else
        echo "📦 File already exists, skipping download."
    fi
}

# ── Extract Go Tarball ────────────────────
extract_go() {
    echo "📂 Extracting $FILE to /usr/local..."
    rm -rf /usr/local/go && tar -C /usr/local -xzf "$FILE"
}

# ── Add Go to PATH ────────────────────────
setup_path() {
    echo "🔧 Setting up Go PATH..."
    export PATH=$PATH:/usr/local/go/bin

    if ! grep -q '/usr/local/go/bin' ~/.zshrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
    fi

    source ~/.zshrc
}

# ─────────────────────────────────────────
#               MAIN FLOW
# ─────────────────────────────────────────
install_go() {
    check_sudo

    # Exit early if Go is already installed
    check_if_installed && exit 0

    # Resolve version and URLs
    local version
    version=$(check_version)
    FILE="${version}.linux-amd64.tar.gz"
    GO_URL="https://golang.org/dl/$FILE"

    echo "🔍 Latest Go version : $version"
    echo "📦 Package           : $FILE"
    echo "🌐 Download URL      : $GO_URL"
    echo ""

    download_go
    extract_go
    setup_path
    clean_up

    echo "✅ Go is already installed: $(go version)"
}
