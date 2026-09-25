require "spec_helper"

describe ITermCLI do
  it "バージョン番号を持つ" do
    expect(ITermCLI::VERSION).not_to be nil
  end
end
