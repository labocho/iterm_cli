require "shellwords"
module ITermCLI
  module Terminal
    class NewSession < Function
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

      # command should be ["command", "arg"] or ["command arg"] or nil
      def call(command, options = {})
        options = {name: nil, debug: false}.merge(options)
        name = options[:name]
        debug = options[:debug]

        commands = split_command_and_args(command)
        executable = commands.first

        unless which(executable)
          $stderr.puts "No such file or directory: #{executable}"
          exit 1
        end

        name ||= executable.split("/").last

        script_lines = []
        script_lines.concat(set_env_lines)
        script_lines << "cd #{Dir.pwd.shellescape}"
        script_lines << commands.shelljoin

        if debug
          puts script_lines
        end

        script_filename = write_script(script_lines.join("\n"))
        osascript(SOURCE, command: "/bin/sh #{script_filename.shellescape}", name: name)
      end

      private
      def which(executable)
        system("which", executable, out: "/dev/null", err: "/dev/null")
      end

      def split_command_and_args(commands)
        case commands.size
        when 0
          [ENV["SHELL"]]
        when 1
          commands[0].shellsplit
        else
          commands
        end
      end

      def set_env_lines
        ENV.reject{|k, v| k == "_" }.map{|kv| "export " + kv.map(&:shellescape).join("=") }
      end

      def write_script(script)
        filename = Dir.mktmpdir("iterm-new-session") + "/iterm-new-session.sh"
        open(filename, "w"){|f| f.write(script) }
        filename
      end
    end
  end
end
