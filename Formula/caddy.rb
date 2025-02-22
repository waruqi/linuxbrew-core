class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.4.0.tar.gz"
  sha256 "36ac7c018e27ea42d13f1f6e2fc3137bda26a160d1dc4888ebfa9090da2f551e"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb0c874c527071d616bbb93dd368b78fade161156277345f289038932e2a5bac"
    sha256 cellar: :any_skip_relocation, big_sur:       "f73e60413d840be6f29c75a8b4df868534bc97816fdccaad5ece3649b41a9f49"
    sha256 cellar: :any_skip_relocation, catalina:      "f73e60413d840be6f29c75a8b4df868534bc97816fdccaad5ece3649b41a9f49"
    sha256 cellar: :any_skip_relocation, mojave:        "f73e60413d840be6f29c75a8b4df868534bc97816fdccaad5ece3649b41a9f49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "636a23291deefbcf3f3b8ff77d23d4a7fd908fb381850eb6b0b1cfdaab145c7b"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.1.9.tar.gz"
    sha256 "399880f59bf093394088cf2d802b19e666377aea563b7ada5001624c489b62c9"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end
  end

  plist_options manual: "caddy run --config #{HOMEBREW_PREFIX}/etc/Caddyfile"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/caddy</string>
            <string>run</string>
            <string>--config</string>
            <string>#{etc}/Caddyfile</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardOutPath</key>
          <string>#{var}/log/caddy.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/caddy.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end
