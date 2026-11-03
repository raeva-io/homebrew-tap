class Raeva < Formula
  desc "Raeva CLI - lockfile companion for Maven projects"
  homepage "https://raeva.io"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.5.2/raeva-aarch64-apple-darwin.tar.gz"
      sha256 "8eef91f31abb1f1a46628352a08d4b4196ecff073826e3baab7b62c1e48207e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.5.2/raeva-x86_64-apple-darwin.tar.gz"
      sha256 "a265829de2bc4280e2dac1fb43c3c60b49a8dd54ce3c347f9b324856536d39b1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.5.2/raeva-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "37b0e8b9a4fcf81645363cddcf5692b8992fe4572d82ae8916d268e9c67dc6fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.5.2/raeva-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2fb292902ebb2e62e7bf8d5277a1c64a281fdf55ae7a61b005f89c3ac73613ad"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "raeva"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "raeva"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "raeva"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "raeva"
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
