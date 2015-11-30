module ITermCLI
  module Subcommand
    class ListSessions < Base
      SOURCE = <<-JS
        function run(argv) {
          var iTerm = Application("iTerm");
          var terminal = iTerm.currentTerminal();
          var names = [];
          var i, session;

          for (i = 0; i < terminal.sessions.length; i++) {
            session = terminal.sessions[i];
            names.push(session.name());
          }

          return names.join("\\n");
        }
      JS

      def run
        puts osascript(SOURCE)
      end
    end
  end
end
