class SourceHighlight < Formula
  desc "Source-code syntax highlighter"
  homepage "https://www.gnu.org/software/src-highlite/"
  url "https://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.9.tar.gz"
  sha256 "3a7fd28378cb5416f8de2c9e77196ec915145d44e30ff4e0ee8beb3fe6211c91"
  revision 4

  livecheck do
    url :stable
    regex(/href=.*?source-highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "6787a672bb05029ac64fb923c688b69c0cd3633f099b736a47962967eb2849fd" => :big_sur
    sha256 "07e07ed256aabe40ef072afe4e17a512bdbb7c0bf588c1732c5a03ccce24663c" => :catalina
    sha256 "abff93ed1104e4cd391a4bc0d042fca421c14cd29e67746b289916313cb99e45" => :mojave
    sha256 "a43e40d4ccdefeb445664cc1c627f3989cdf5448884141508aada56795fe7fc4" => :x86_64_linux
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    system "make", "install"

    bash_completion.install "completion/source-highlight"
  end

  test do
    assert_match /GNU Source-highlight #{version}/, shell_output("#{bin}/source-highlight -V")
  end
end
