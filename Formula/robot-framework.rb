class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https://robotframework.org/"
  url "https://files.pythonhosted.org/packages/1d/34/1dd668560f4dad65fb913a80b82f942395ace488c02c1ce050c07f3347fb/robotframework-4.0.2.zip"
  sha256 "efd39558219fddc86473d4d390aeaec60640d7a7567a15fd51c0576f20e46171"
  license "Apache-2.0"
  head "https://github.com/robotframework/robotframework.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "99643958cff65b1cf3b80a8840ab1681f7201fbf41a61d591c798c95ad8ed8a2"
    sha256 cellar: :any,                 big_sur:       "1b19e232b3084f8d07391ee81a644159097782db9217b57b31816eb582c53435"
    sha256 cellar: :any,                 catalina:      "0e4ed0f5020d4ebed1f24ca558ab111f54354ddd5c8f4598bf0b1252ba5a5d85"
    sha256 cellar: :any,                 mojave:        "01dfb6617e3f8770b044a3d00ec1fb8bb9adbac61c218184194f948026f21406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565af4bd3e4139fc58a23796b158510799e932c9e23be67d10310ac078071c40"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "robotframework-archivelibrary" do
    url "https://files.pythonhosted.org/packages/29/b6/bf5bd38d5764f6afaf17b0debef580aee9bfbd63ad77a0e215389691fdfb/robotframework-archivelibrary-0.4.0.tar.gz"
    sha256 "d18dd05a9d43decef1352a9a7601522639e4e6f02a084692b6392603c5f6c063"
  end

  resource "robotframework-pythonlibcore" do
    url "https://files.pythonhosted.org/packages/77/47/a745d43181acc2eed5fc9558014040ac090fd530efe60876cfe9f5298c8b/robotframework-pythonlibcore-2.2.1.tar.gz"
    sha256 "1b311764721b6117d85b0702ab95a7f1d0525d9d3e3433cca02cdbc0010edb55"
  end

  resource "robotframework-selenium2library" do
    url "https://files.pythonhosted.org/packages/c4/7d/3c07081e7f0f1844aa21fd239a0139db4da5a8dc219d1e81cb004ba1f4e2/robotframework-selenium2library-3.0.0.tar.gz"
    sha256 "2a8e942b0788b16ded253039008b34d2b46199283461b294f0f41a579c70fda7"
  end

  resource "robotframework-seleniumlibrary" do
    url "https://files.pythonhosted.org/packages/c4/75/fe0184ba697a585d80457b74b7bed1bb290501cd6f9883d149efb4a3d9f2/robotframework-seleniumlibrary-5.1.3.tar.gz"
    sha256 "f51a0068c6c0d8107ee1120874a3afbf2bbe751fd0782cb86a27a616d9ca30b6"
  end

  resource "robotframework-sshlibrary" do
    url "https://files.pythonhosted.org/packages/36/58/a91f61f183ec71fd59f488e6a0381083fd8ccdf9595d16769c111ee39cc6/robotframework-sshlibrary-3.6.0.tar.gz"
    sha256 "169c343f4db71e1969169fa6f383ca7fff549aa8f83bdd3d9cbd03cea928b688"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/31/ea/957c864e8f0aafab52edfd18bbaacf342a1935ba3a5cb6b5704a1738ebac/scp-0.13.3.tar.gz"
    sha256 "8bd748293d7362073169b96ce4b8c4f93bcc62cfc5f7e1d949e01e406a025bd4"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/ed/9c/9030520bf6ff0b4c98988448a93c04fcbd5b13cd9520074d8ed53569ccfe/selenium-3.141.0.tar.gz"
    sha256 "deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"HelloWorld.robot").write <<~EOS
      *** Settings ***
      Library         HelloWorld.py

      *** Test Cases ***
      HelloWorld
          Hello World
    EOS

    (testpath/"HelloWorld.py").write <<~EOS
      def hello_world():
          print("HELLO WORLD!")
    EOS
    system bin/"robot", testpath/"HelloWorld.robot"
  end
end
