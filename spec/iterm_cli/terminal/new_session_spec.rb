require "spec_helper"

describe ITermCLI::Terminal::NewSession do
  describe "#call" do
    it "指定されたコマンドを生成したシェルスクリプトで実行する" do
      new_session = described_class.new
      osascript_calls = stub_osascript

      allow(new_session).to receive(:system).with("which", "ruby", out: "/dev/null", err: "/dev/null").and_return(true)

      new_session.call(["ruby", "-v"])

      options = JSON.parse(osascript_calls.first[5])
      script_filename = Shellwords.split(options["command"]).last
      script = File.read(script_filename)

      expect(script).to include("cd #{Dir.pwd}", "ruby -v")
      expect(options["name"]).to eq("ruby")
    end

    it "指定されたセッション名を使う" do
      new_session = described_class.new
      osascript_calls = stub_osascript

      allow(new_session).to receive(:system).with("which", "rails", out: "/dev/null", err: "/dev/null").and_return(true)

      new_session.call(%w(rails server), name: "server")

      options = JSON.parse(osascript_calls.first[5])
      expect(options["name"]).to eq("server")
    end
  end
end
