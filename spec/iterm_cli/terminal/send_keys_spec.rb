require "spec_helper"

describe ITermCLI::Terminal::SendKeys do
  describe "#call" do
    it "対象セッションへ文字列を送信する" do
      osascript_calls = stub_osascript

      described_class.new.call(["exit"], target: "console")

      expect(JSON.parse(osascript_calls.first[5])).to include("target" => "console", "text" => "exit")
    end

    it "特殊キー名を変換してから文字列を送信する" do
      osascript_calls = stub_osascript

      described_class.new.call(%w(C-c Enter), target: "server")

      expect(JSON.parse(osascript_calls.first[5])).to include("target" => "server", "text" => "\u0003 \n")
    end
  end
end
