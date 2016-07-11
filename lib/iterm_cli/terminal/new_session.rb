require "shellwords"
module ITermCLI
  module Terminal
    class NewSession < Function
      SOURCE = <<-JS
        function run(argv) {
          var options = JSON.parse(argv[0]);
          var iTerm = Application("iTerm");
          var window = iTerm.currentWindow();
          var tab = iTerm.createTab(window, {withProfile: "Default", command: options.command});

          tab.currentSession().name = options.name;
        }
      JS

      # command should be ["command", "arg"] or ["command arg"]
      def call(command_and_args, options = {})
        options = {name: nil, debug: false}.merge(options)
        name = options[:name]
        debug = options[:debug]

        command = join_command(command_and_args)
        executable = command.shellsplit.first

        unless which(executable)
          $stderr.puts "No such file or directory: #{executable}"
          exit 1
        end

        name ||= executable.split("/").last

        script_lines = []
        script_lines.concat(set_env_lines)
        script_lines << "cd #{Dir.pwd.shellescape}"
        script_lines << command

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

      def join_command(command_and_args)
        case command_and_args.size
        when 0
          ENV["SHELL"]
        when 1
          command_and_args[0]
        else
          command_and_args.shelljoin
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
