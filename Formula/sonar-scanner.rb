class SonarScanner < Formula
  desc "Launcher to analyze a project with SonarQube"
  homepage "https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner"
  url "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472.zip"
  sha256 "344bfeff44b09a11082b4a4646b1ed14f213feb00a5cd6d01c86f3767cb32471"
  license "LGPL-3.0-or-later"
  head "https://github.com/SonarSource/sonar-scanner-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ea497e6f2b95c53f04f189a27f92940adaf78b0a1280f26c5c9b6675267c4a2e"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.install libexec/"bin/sonar-scanner"
    etc.install libexec/"conf/sonar-scanner.properties"
    ln_s etc/"sonar-scanner.properties", libexec/"conf/sonar-scanner.properties"
    bin.env_script_all_files libexec/"bin/", SONAR_SCANNER_HOME: libexec, JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sonar-scanner --version")
  end
end
