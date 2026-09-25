require "spec_helper"
require "tmpdir"

describe ITermCLI::SessionsCommand do
  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) { example.run }
    end
  end

  describe "#start" do
    it ".iterm-sessions を優先してセッションを起動する" do
      File.write(".iterm-sessions", "")
      File.write("Procfile", "")
      session_manager = instance_double(ITermCLI::SessionManager, start: nil)

      allow(ITermCLI::SessionManager).to receive(:load).and_return(session_manager)

      described_class.new.start("server")

      expect(ITermCLI::SessionManager).to have_received(:load).with(".iterm-sessions")
      expect(session_manager).to have_received(:start).with(["server"])
    end

    it "Procfile でセッションを起動する" do
      File.write("Procfile", "")
      session_manager = instance_double(ITermCLI::SessionManager, start: nil)

      allow(ITermCLI::SessionManager).to receive(:load).and_return(session_manager)

      described_class.new.start("server")

      expect(ITermCLI::SessionManager).to have_received(:load).with("Procfile")
      expect(session_manager).to have_received(:start).with(["server"])
    end

    it "セッション定義ファイルがない場合は終了する" do
      command = described_class.new

      expect { command.start }.to raise_error(SystemExit).and output(".iterm-sessions or Procfile required\n").to_stderr
    end
  end

  describe "#kill" do
    it "見つけたセッション定義ファイルでセッションを終了する" do
      File.write("Procfile", "")
      session_manager = instance_double(ITermCLI::SessionManager, kill: nil)

      allow(ITermCLI::SessionManager).to receive(:load).and_return(session_manager)

      described_class.new.kill("server")

      expect(ITermCLI::SessionManager).to have_received(:load).with("Procfile")
      expect(session_manager).to have_received(:kill).with(["server"])
    end
  end

  describe "#ls" do
    it "見つけたセッション定義ファイルでセッション一覧を表示する" do
      File.write("Procfile", "")
      session_manager = instance_double(ITermCLI::SessionManager, list: nil)

      allow(ITermCLI::SessionManager).to receive(:load).and_return(session_manager)

      described_class.new.ls

      expect(ITermCLI::SessionManager).to have_received(:load).with("Procfile")
      expect(session_manager).to have_received(:list)
    end
  end
end
