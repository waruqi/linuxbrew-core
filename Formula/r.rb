class R < Formula
  desc "Software environment for statistical computing"
  homepage "https://www.r-project.org/"
  url "https://cran.r-project.org/src/base/R-4/R-4.0.5.tar.gz"
  sha256 "0a3ee079aa772e131fe5435311ab627fcbccb5a50cabc54292e6f62046f1ffef"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://cran.rstudio.com/banner.shtml"
    regex(%r{href=(?:["']?|.*?/)R[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "7d32bae3d8e334bf52cdbc4c739e846e6146080e92bdf25a435f03a260207d5c"
    sha256 big_sur:       "6ce7c0d1377cfc641ac4c2e3e6d6e481a3a1d53eb308669335193acff85e7d75"
    sha256 catalina:      "803554a7ca7deec319055c16a6de6d773622c79d8d3d3fa8f799d0c33e26746c"
    sha256 mojave:        "24a1e770629bdbcc47aeacf402b40e1e76b61ae827107005f90993ffdf48c685"
    sha256 x86_64_linux:  "5dbc29e14563a7d3eb2a0c0f3724dda3b6e11e8d7aecd7b335b99adee3266302"
  end

  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openblas"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "xz"

  unless OS.mac?
    depends_on "cairo"
    depends_on "curl"
    depends_on "pango"
    depends_on "libice"
    depends_on "libx11"
    depends_on "libxt"
    depends_on "libtirpc"
  end

  # needed to preserve executable permissions on files without shebangs
  skip_clean "lib/R/bin", "lib/R/doc"

  def install
    # BLAS detection fails with Xcode 12 due to missing prototype
    # https://bugs.r-project.org/bugzilla/show_bug.cgi?id=18024
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    args = [
      "--prefix=#{prefix}",
      "--enable-memory-profiling",
      "--with-tcl-config=#{Formula["tcl-tk"].opt_lib}/tclConfig.sh",
      "--with-tk-config=#{Formula["tcl-tk"].opt_lib}/tkConfig.sh",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--enable-R-shlib",
      "--disable-java",
    ]

    # don't remember Homebrew's sed shim
    args << "SED=/usr/bin/sed" if File.exist?("/usr/bin/sed")

    if OS.mac?
      args << "--without-cairo"
      args << "--without-x"
      args << "--with-aqua"
    end

    unless OS.mac?
      args << "--libdir=#{lib}" # avoid using lib64 on CentOS
      args << "--with-cairo"

      # If LDFLAGS contains any -L options, configure sets LD_LIBRARY_PATH to
      # search those directories. Remove -LHOMEBREW_PREFIX/lib from LDFLAGS.
      ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    end

    # Help CRAN packages find gettext and readline
    ["gettext", "readline", "xz"].each do |f|
      ENV.append "CPPFLAGS", "-I#{Formula[f].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula[f].opt_lib}"
    end

    # Avoid references to homebrew shims
    args << "LD=ld" unless OS.mac?

    unless OS.mac?
      ENV.append "CPPFLAGS", "-I#{Formula["libtirpc"].opt_include}/tirpc"
      ENV.append "LDFLAGS", "-L#{Formula["libtirpc"].opt_lib}"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize do
      system "make", "install"
    end

    cd "src/nmath/standalone" do
      system "make"
      ENV.deparallelize do
        system "make", "install"
      end
    end

    r_home = lib/"R"

    # make Homebrew packages discoverable for R CMD INSTALL
    inreplace r_home/"etc/Makeconf" do |s|
      s.gsub!(/^CPPFLAGS =.*/, "\\0 -I#{HOMEBREW_PREFIX}/include")
      s.gsub!(/^LDFLAGS =.*/, "\\0 -L#{HOMEBREW_PREFIX}/lib")
      s.gsub!(/.LDFLAGS =.*/, "\\0 $(LDFLAGS)")
    end

    include.install_symlink Dir[r_home/"include/*"]
    lib.install_symlink Dir[r_home/"lib/*"]

    # avoid triggering mandatory rebuilds of r when gcc is upgraded
    inreplace lib/"R/etc/Makeconf",
      Formula["gcc"].prefix.realpath,
      Formula["gcc"].opt_prefix,
      OS.mac?
  end

  def post_install
    short_version =
      `#{bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
    site_library = HOMEBREW_PREFIX/"lib/R/#{short_version}/site-library"
    site_library.mkpath
    ln_s site_library, lib/"R/site-library"
  end

  test do
    dylib_ext = OS.mac? ? ".dylib" : ".so"
    assert_equal "[1] 2", shell_output("#{bin}/Rscript -e 'print(1+1)'").chomp
    assert_equal dylib_ext, shell_output("#{bin}/R CMD config DYLIB_EXT").chomp
    if OS.mac?
      assert_equal "[1] \"aqua\"",
                   shell_output(
                     "#{bin}/Rscript -e 'library(tcltk)' -e 'tclvalue(.Tcl(\"tk windowingsystem\"))'",
                   ).chomp
    end
    system bin/"Rscript", "-e", "install.packages('gss', '.', 'https://cloud.r-project.org')"
    assert_predicate testpath/"gss/libs/gss.so", :exist?,
                     "Failed to install gss package"
  end
end
