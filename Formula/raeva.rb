class Raeva < Formula
  desc "Raeva CLI - lockfile companion for Maven projects"
  homepage "https://raeva.io"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.5.3/raeva-aarch64-apple-darwin.tar.gz"
      sha256 "732005ed7f97e37766238691cabdef3644bd73123ff22339709e975c9ef863e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.5.3/raeva-x86_64-apple-darwin.tar.gz"
      sha256 "bb10e44f977f123b820c6394399e8e7ac4da9805a00775433285f8baa85fc039"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raeva-io/raeva/releases/download/v0.5.3/raeva-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ed79fbd39639d9afc4c47d4b4f3aadbe7ab5f45246825ed50a10464bcf12522"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raeva-io/raeva/releases/download/v0.5.3/raeva-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ab7bbffe64258201adc9551b084f85d67779d80e325f04728efe6af4f65f8e87"
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
