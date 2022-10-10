class Temporalite < Formula
  desc "A distribution of Temporal that runs as a single process with zero runtime dependencies."
  homepage "https://github.com/temporalio/temporalite"
  license "MIT"

  head "https://github.com/temporalio/temporalite.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/temporalite"
  end

  service do
    run [opt_bin/"temporalite", "-D", var/"postgres"]
    keep_alive true
    log_path var/"log/temporalite.log"
    error_log_path var/"log/temporalite.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    version_out = shell_output("#{bin}/temporalite --version")
    assert_match "temporal version 1.", version_out
  end
end
