module ExternalCommandHelpers
  def successful_command_status
    Struct.new(:code) do
      def success?
        true
      end

      def to_i
        code
      end
    end.new(0)
  end

  def stub_osascript(*outputs)
    calls = []

    allow(Open3).to receive(:capture3) do |*args|
      calls << args
      [outputs.shift.to_s, "", successful_command_status]
    end

    calls
  end

  def osascript_options(calls)
    calls.map {|call| JSON.parse(call[5]) }
  end
end

RSpec.configure do |config|
  config.include ExternalCommandHelpers
end
