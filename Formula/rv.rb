class Rv < Formula
  desc "Raeva CLI - lockfile companion for Maven projects"
  homepage "https://raeva.io"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.1.1/rv-cli-aarch64-apple-darwin.tar.gz"
      sha256 "c07d0f717f489caef07fb36b1b6dfe18a466f4052524065bb52d3bf467532520"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.1.1/rv-cli-x86_64-apple-darwin.tar.gz"
      sha256 "cd24fa59bac95d9dbd4cb3c63ca5222b0a6572962fbab75edf41a7757f294696"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.1.1/rv-cli-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "441b93dca3fc125b6afe5c58076d3301154c21a10116a6f3d0a51155ec2c5b33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.1.1/rv-cli-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b0f25caa9b026e79a963d8f155671f76a48228e564ef62694551eced5ce75333"
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
