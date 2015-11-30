require "shellwords"
module ITermCLI
  module Subcommand
    class NewSession < Base
      SOURCE = <<-JS
        function run(argv) {
          var options = JSON.parse(argv[0]);
          var iTerm = Application("iTerm");
          var terminal = iTerm.currentTerminal();
          var session = new iTerm.Session();

          terminal.sessions.push(session);
          session.exec({command: options.command});
          session.name = options.name;
        }
      JS

      def run(command, options)
        command ||= ENV["SHELL"]
        name = options[:name] || command.shellsplit.first.split("/").last
        command = "cd #{Dir.pwd.shellescape} && " + command

        script_filename = Dir.mktmpdir("iterm-new-session") + "/iterm-new-session.sh"
        open(script_filename, "w"){|f| f.write(command) }

        osascript(SOURCE, command: "/bin/sh #{script_filename.shellescape}", name: name)
      end
    end
  end
end
