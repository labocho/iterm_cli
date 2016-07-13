# iTerm CLI

Command line interface for [iTerm 2](https://www.iterm2.com/). Inspired by [tmux](https://tmux.github.io/) and [tmuxinator](https://github.com/tmuxinator/tmuxinator).

## Requirements

Ruby 1.9.3 or later.

## Installation

    $ git clone https://github.com/labocho/iterm_cli
    $ cd iterm_cli
    $ rake install

## Usage

    # If no arguments, show help.
    $ iterm

### new-session

    # `iterm new-session` creates new session (tab)
    $ iterm new-session

    # with command, execute in created session
    $ iterm new-session top
    $ iterm new-session sleep 3
    $ iterm new-session 'sleep 3'

    # session name will be command name.
    # --name (or -n) option names session explicitly.
    $ iterm new-session --name=server rails server

### send-keys

    # `iterm send-keys` types keys to target session
    $ iterm new-session -n foo zsh
    $ iterm send-keys --target foo exit

    # C-* indicates control key
    $ iterm new-session top
    $ iterm send-keys --target top C-c # send control-c

### sessions

`iterm sessions` manages multi sessions by file named `.iterm-sessions` in current directory.
`.iterm-sessions` should be written in YAML (http://yaml.org/).

    # keys are session names
    console:
      # `command` passes `iterm new-session` when started
      command: rails console
      # `kill` passes `iterm send-keys` when stopped
      kill: exit
    # shorthand style (killed by control-c)
    server: rails server

`iterm sessions` have subcommands below.

    # `iterm sessions ls` lists sessions defined
    # marked for session exists.
    $ iterm sessions ls
      console
    * server


    # `iterm sessions start` starts all sessions.
    # If session exists, do nothing for the session.
    $ iterm sessions start

    # If pass session name, start the session (if not exists).
    $ iterm sessions start server


    # `iterm sessions kill` stops all sessions.
    # If session does not exist, do nothing.
    $ iterm sessions kill

    # If pass session name, kill the session (if exists).
    $ iterm sessions kill server

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/labocho/iterm_cli.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

