require "thor"

module ITermCLI
  class CLI < Thor
    desc "list-sessions", "List name of all sessions in current terminal"
    def list_sessions
      puts Terminal::ListSessions.call.join("\n")
    end

    desc "new-session COMMAND", "Create new session in current terminal"
    option :name, aliases: :n
    def new_session(*command)
      Terminal::NewSession.call(command, name: options.name)
    end

    desc "send-keys KEYS", "Send keys to session"
    option :target, aliases: :t, required: true
    def send_keys(*keys)
      Terminal::SendKeys.call(keys, target: options.target)
    end
  end
end
