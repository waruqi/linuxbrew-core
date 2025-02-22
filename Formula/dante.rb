class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https://www.inet.no/dante/"
  url "https://www.inet.no/dante/files/dante-1.4.3.tar.gz"
  sha256 "418a065fe1a4b8ace8fbf77c2da269a98f376e7115902e76cda7e741e4846a5d"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7b25a50f17292cdad4dd0e52de401117411fc6bb660c66bedbdbc8c7759dea9a"
    sha256 cellar: :any,                 big_sur:       "098dc6c46d4ee77860f8fefcd44bc21533bf70423add42de899910757796d410"
    sha256 cellar: :any,                 catalina:      "4b33f0996ade01cae7bc72f40cf7c8011f86133755e782cc40a15a0d610560c1"
    sha256 cellar: :any,                 mojave:        "f6348c63fff9dbf5392ccb1b769e9643e248e00913aba9bcb24dc928f153b526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbf8ee6ceaac44eeee0a090b9f61aaa8821fdd3d1af3fc8ca63cc029abfe4df4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-silent-rules",
                          # Enabling dependency tracking disables universal
                          # build, avoiding a build error on Mojave
                          "--enable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/dante"
    system "make", "install"
  end

  test do
    system "#{sbin}/sockd", "-v"
  end
end
