require "thor"
require "thor/zsh_completion"

module ITermCLI
  class SessionsCommand < Thor
    namespace "sessions"

    desc "start [SESSION_NAME]", "Start all sessions if it's not started"
    def start(*session_names)
      SessionManager.load(".iterm-sessions").start(session_names)
    end

    desc "kill [SESSION_NAME]", "Kill all sessions if it's started"
    def kill(*session_names)
      SessionManager.load(".iterm-sessions").kill(session_names)
    end

    desc "ls", "List sessions"
    def ls
      SessionManager.load(".iterm-sessions").list
    end

    map(
      "s" => "start",
      "k" => "kill",
      "l" => "ls",
    )
  end

  class CLI < Thor
    include ZshCompletion::Command

    desc "list-sessions", "List name of all sessions in current terminal"
    def list_sessions
      puts Terminal::ListSessions.call.join("\n")
    end

    desc "new-session COMMAND", "Create new session in current terminal"
    option :name, aliases: :n
    option :debug, type: :boolean
    def new_session(*command)
      Terminal::NewSession.call(command, name: options.name, debug: options.debug)
    end

    desc "send-keys KEYS", "Send keys to session"
    option :target, aliases: :t, required: true
    def send_keys(*keys)
      Terminal::SendKeys.call(keys, target: options.target)
    end

    desc "sessions SUBCOMMAND ...ARGS", "Manage sessions by .iterm-sessions"
    subcommand "sessions", SessionsCommand

    map(
      "l" => "list_sessions",
      "n" => "new_session",
      "k" => "send_keys",
      "s" => "sessions",
    )
  end
end
