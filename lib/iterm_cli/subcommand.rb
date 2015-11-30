module ITermCLI
  module Subcommand
    autoload :Base, "iterm_cli/subcommand/base"
    autoload :ListSessions, "iterm_cli/subcommand/list_sessions"
    autoload :NewSession, "iterm_cli/subcommand/new_session"
    autoload :SendKeys, "iterm_cli/subcommand/send_keys"
  end
end
