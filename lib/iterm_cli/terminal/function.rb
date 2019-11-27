require "open3"
require "json"

module ITermCLI
  module Terminal
    class Function
      def self.call(*args)
        new.call(*args)
      end

      def call(*_args)
        raise NotImplementedError
      end

      def osascript(source, arg = {})
        out, err, status = Open3.capture3("/usr/bin/osascript", "-l", "JavaScript", "-e", source, arg.to_json)
        unless status.success?
          warn "osascript exited with #{status.to_i}"
          warn err
          exit status.to_i
        end
        out
      end
    end
  end
end
