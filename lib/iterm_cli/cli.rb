require "thor"
require "thor/zsh_completion"

module ITermCLI
  class SessionsCommand < Thor
    namespace "sessions"

    desc "start [SESSION_NAME]", "Start all sessions if it's not started"
    def start(*session_names)
      SessionManager.load(".iterm-sessions").start(session_names)
    end

    desc "stop [SESSION_NAME]", "Stop all sessions if it's started"
    def stop(*session_names)
      SessionManager.load(".iterm-sessions").stop(session_names)
    end

    desc "ls", "List sessions"
    def ls(*session_names)
      SessionManager.load(".iterm-sessions").list
    end
  end

  class CLI < Thor
    include ZshCompletion::Command

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

    register SessionsCommand, "sessions", "sessions <command>", "Manage sessions by .iterm-sessions"
  end
end
