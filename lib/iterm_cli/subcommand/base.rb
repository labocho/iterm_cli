require "open3"
require "json"

module ITermCLI
  module Subcommand
    class Base
      def self.run(*args)
        new.run(*args)
      end

      def run(*args)
        raise NotImplementedError
      end

      def osascript(source, arg = {})
        out, err, status = Open3.capture3("/usr/bin/osascript", "-l", "JavaScript", "-e", source, arg.to_json)
        unless status.success?
          $stderr.puts "osascript exited with #{status.to_i}"
          $stderr.puts err
          exit status.to_i
        end
        out
      end
    end
  end
end
