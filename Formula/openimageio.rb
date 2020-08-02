class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/Release-2.1.18.1.tar.gz"
  version "2.1.18"
  sha256 "e2cf54f5b28e18fc88e76e1703f2e39bf144c88378334527e4a1246974659a85"
  license "BSD-3-Clause"
  head "https://github.com/OpenImageIO/oiio.git"

  bottle do
    sha256 "d3467bc4fb634acd02576a8f43546ae2c898b85969a091751953b71e85f47d79" => :catalina
    sha256 "d5ddb5faf23546680135f830ea2f170215cf1929df911a510555566db69fb243" => :mojave
    sha256 "61aed9ec9cfc49177f67fbee3987630c50ed5eb4559bc22925458fffe84e9702" => :high_sierra
    sha256 "3baffc1cdc14fdc50b4637cc6ba25e82244a8efaf3f7fb5fe124a08b66ed89ea" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "ilmbase"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "python@3.8"
  depends_on "webp"

  def install
    args = std_cmake_args + %w[
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DUSE_FIELD3D=OFF
      -DUSE_JPEGTURBO=OFF
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    # CMake picks up the system's python dylib, even if we have a brewed one.
    ext = OS.mac? ? "dylib" : "so"
    py3ver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    py3prefix = if OS.mac?
      Formula["python@3.8"].opt_frameworks/"Python.framework/Versions/#{py3ver}"
    else
      Formula["python@3.8"].opt_prefix
    end

    ENV["PYTHONPATH"] = lib/"python#{py3ver}/site-packages"

    args << "-DPYTHON_EXECUTABLE=#{py3prefix}/bin/python3"
    args << "-DPYTHON_LIBRARY=#{py3prefix}/lib/libpython#{py3ver}.#{ext}"
    args << "-DPYTHON_INCLUDE_DIR=#{py3prefix}/include/python#{py3ver}"

    # CMake picks up boost-python instead of boost-python3
    args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
    boost_lib = Formula["boost-python3"].opt_lib
    py3ver_without_dots = py3ver.to_s.delete(".")
    args << "-DBoost_PYTHON_LIBRARIES=#{boost_lib}/libboost_python#{py3ver_without_dots}-mt.#{ext}"

    # This is strange, but must be set to make the hack above work
    args << "-DBoost_PYTHON_LIBRARY_DEBUG=''"
    args << "-DBoost_PYTHON_LIBRARY_RELEASE=''"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}/oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    assert_match version.to_s, pipe_output(Formula["python@3.8"].opt_bin/"python3", output, 0)
  end
end
