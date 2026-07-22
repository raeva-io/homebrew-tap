class Rv < Formula
  desc "Raeva CLI - lockfile companion for Maven projects"
  homepage "https://raeva.io"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.2.0/rv-cli-aarch64-apple-darwin.tar.gz"
      sha256 "f7fb421ee78bad9bd78fee6d462c95bb5d31468a991ee06f453637982eeeb3e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.2.0/rv-cli-x86_64-apple-darwin.tar.gz"
      sha256 "059a0301baabdc22bff3473bd1db34ba04fd277f2a78164e85e5c3c79b4f1019"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.2.0/rv-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "676fe15268efcae657cb503c94353208c92009b0089931d0d6c26c1529059442"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.2.0/rv-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41a5f80cf1b8824310af662636b357fc2a09124e443385414368e49d77d2180f"
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
    bin.install "rv" if OS.mac? && Hardware::CPU.arm?
    bin.install "rv" if OS.mac? && Hardware::CPU.intel?
    bin.install "rv" if OS.linux? && Hardware::CPU.arm?
    bin.install "rv" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
