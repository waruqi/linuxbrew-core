class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.1.9.tar.gz"
  sha256 "619ad05162161d6381625565cb2913e09ce393d985b7795073ef3c3ae91f7198"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2d96cbc7eb29fd072ff08b1954ed143ed868639d15603ae1b58ba418e265b527"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match(/^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1))
  end
end
