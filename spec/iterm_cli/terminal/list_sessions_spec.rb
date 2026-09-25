require "spec_helper"

describe ITermCLI::Terminal::ListSessions do
  describe "#call" do
    it "osascript の出力からセッション名を返す" do
      allow(Open3).to receive(:capture3).with(
        "/usr/bin/osascript",
        "-l",
        "JavaScript",
        "-e",
        described_class::SOURCE,
        "{}",
      ).and_return(["console\nserver\n", "", successful_command_status])

      expect(described_class.new.call).to eq(%w(console server))
    end
  end
end
