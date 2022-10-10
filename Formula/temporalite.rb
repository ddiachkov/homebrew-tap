class Temporalite < Formula
  desc "A distribution of Temporal that runs as a single process."
  homepage "https://github.com/temporalio/temporalite"
  license "MIT"

  head "https://github.com/temporalio/temporalite.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/temporalite"
  end

  def post_install
    temporalite_config_dir.mkpath
    temporalite_db_path.dirname.mkpath
  end

  def temporalite_config_dir
    var/"temporalite"
  end

  def temporalite_db_path
    temporalite_config_dir/"db/default.db"
  end

  service do
    run [opt_bin/"temporalite", "start", "--namespace", "default", "--filename", f.temporalite_db_path]
    keep_alive true
    log_path var/"log/temporalite.log"
    error_log_path var/"log/temporalite.log"
    working_dir f.temporalite_config_dir
  end

  test do
    version_out = shell_output("#{opt_bin}/temporalite --version")
    assert_match "temporalite", version_out
    assert_match "server 1.", version_out
  end
end
