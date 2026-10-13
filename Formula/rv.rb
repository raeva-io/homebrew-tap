class Rv < Formula
  desc "Raeva CLI - lockfile companion for Maven projects"
  homepage "https://raeva.io"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.4.1/rv-cli-aarch64-apple-darwin.tar.gz"
      sha256 "6ed0fd1f7615886bf398ce4e361f058e7767de95c65740fcce10ef62f68aa9c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.4.1/rv-cli-x86_64-apple-darwin.tar.gz"
      sha256 "9447e0555ec11e312a18665a6465f9cdbe290a950f9c78b53ea59acde92609a0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.4.1/rv-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "28529ea82777df2d12e0b61c779ddd02edb6d85336be10345d6d11cd58ce39ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.4.1/rv-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c0cae00ea323366254318d54b9f002aac4e470ee54c630bdbe7f6d49e3c0162b"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rv"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rv"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rv"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rv"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
