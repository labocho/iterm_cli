require "spec_helper"

describe ITermCLI::SessionManager do
  describe "#start" do
    it "まだ起動していないセッションを起動する" do
      manager = described_class.new(
        "console" => {"command" => "rails console", "kill" => "exit"},
        "server" => "rails server",
      )

      allow(ITermCLI::Terminal::ListSessions).to receive(:call).and_return(["server"])
      allow(ITermCLI::Terminal::NewSession).to receive(:call)

      expect { manager.start([]) }.to output("Start console\n").to_stdout

      expect(ITermCLI::Terminal::NewSession).to have_received(:call).with(["rails console"], name: "console")
      expect(ITermCLI::Terminal::NewSession).not_to have_received(:call).with(["rails server"], name: "server")
    end

    it "指定されたセッションだけを起動する" do
      manager = described_class.new(
        "console" => {"command" => "rails console", "kill" => "exit"},
        "server" => "rails server",
      )

      allow(ITermCLI::Terminal::ListSessions).to receive(:call).and_return([])
      allow(ITermCLI::Terminal::NewSession).to receive(:call)

      expect { manager.start(["server"]) }.to output("Start server\n").to_stdout

      expect(ITermCLI::Terminal::NewSession).to have_received(:call).with(["rails server"], name: "server")
      expect(ITermCLI::Terminal::NewSession).not_to have_received(:call).with(["rails console"], name: "console")
    end
  end

  describe "#kill" do
    it "起動中のセッションだけを終了する" do
      manager = described_class.new(
        "console" => {"command" => "rails console", "kill" => "exit"},
        "server" => "rails server",
      )

      allow(ITermCLI::Terminal::ListSessions).to receive(:call).and_return(["console"])
      allow(ITermCLI::Terminal::SendKeys).to receive(:call)

      expect { manager.kill([]) }.to output("Kill console\n").to_stdout

      expect(ITermCLI::Terminal::SendKeys).to have_received(:call).with(["exit"], target: "console")
      expect(ITermCLI::Terminal::SendKeys).not_to have_received(:call).with(["C-c"], target: "server")
    end
  end

  describe "#list" do
    it "起動中のセッションに印を付けて表示する" do
      manager = described_class.new(
        "console" => {"command" => "rails console", "kill" => "exit"},
        "server" => "rails server",
      )

      allow(ITermCLI::Terminal::ListSessions).to receive(:call).and_return(["server"])

      expect { manager.list }.to output("  console rails console\n* server  rails server\n").to_stdout
    end
  end
end
