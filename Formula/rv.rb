class Rv < Formula
  desc "Raeva CLI - lockfile companion for Maven projects"
  homepage "https://raeva.io"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.3.0/rv-cli-aarch64-apple-darwin.tar.gz"
      sha256 "6502572f40994a662f271947533ca0a29893ee150412bfe1f635c13bfddb6ae8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.3.0/rv-cli-x86_64-apple-darwin.tar.gz"
      sha256 "81b1b7bcefcb9e6c580ca3d3e37032370d573b2b880117f4b6466a102859d206"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.3.0/rv-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d2e11d230a6bd5c964134739e6fc4fca8d82c1fdcec168f3b5b8c71e3b718b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.3.0/rv-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d248e308a39be35e1bd4cd9e5e7cff803b56e414b9fe1f37e3de26a6b7a8e999"
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
