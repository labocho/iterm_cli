require "thor"

module ITermCLI
  class CLI < Thor
    desc "list-sessions", "List name of all sessions in current terminal"
    def list_sessions
      Subcommand::ListSessions.run
    end

    desc "new-session COMMAND", "Create new session in current terminal"
    option :name, aliases: :n
    def new_session(command = nil)
      Subcommand::NewSession.run(command, options)
    end

    desc "send-keys KEYS", "Send keys to session"
    option :target, aliases: :t, required: true
    def send_keys(*keys)
      Subcommand::SendKeys.run(keys, options)
    end
  end
end
