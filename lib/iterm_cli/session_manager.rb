require "yaml"

module ITermCLI
  class SessionManager
    class Session
      attr_accessor :name, :command, :kill
      private :name=, :command=, :kill=

      def initialize(attributes)
        attributes.each do |k, v|
          send("#{k}=", v)
        end
      end
    end

    def self.load(sessions_file)
      unless File.exists?(sessions_file)
        $stderr.puts "#{sessions_file} not found"
        exit 1
      end
      sessions = YAML.load_file(sessions_file)
      new(sessions)
    end

    attr_reader :sessions

    def initialize(sessions)
      @sessions = parse_sessions(sessions)
    end

    def start(names)
      sessions_will_start = select_sessions_by_names(names)
      existed = existed_session_names
      sessions_will_start.reject!{|s| existed.include?(s.name) }

      sessions_will_start.map{|session|
        Thread.new {
          $stdout.puts "Start #{session.name}"
          Terminal::NewSession.call([session.command], name: session.name)
        }
      }.each(&:join)
    end

    def kill(names)
      sessions_will_kill = select_sessions_by_names(names)
      existed = existed_session_names
      sessions_will_kill.select!{|s| existed.include?(s.name) }

      sessions_will_kill.map{|session|
        Thread.new {
          $stdout.puts "Kill #{session.name}"
          Terminal::SendKeys.call(session.kill.split(" "), target: session.name)
        }
      }.each(&:join)
    end

    def list
      existed = existed_session_names
      column_width = sessions.values.map{|s| s.name.length }.max
      sessions.values.each do |session|
        prefix = if existed.include?(session.name)
          "*"
        else
          " "
        end
        puts [prefix, session.name.ljust(column_width), session.command].join(" ")
      end
    end

    private
    def select_sessions_by_names(names)
      if names.empty?
        sessions.values
      else
        r = []
        names.each do |name|
          s = sessions[name]
          unless s
            $stderr.puts "#{name} not defined"
            exit 1
          end
          r << s
        end
        r
      end
    end

    def parse_sessions(sessions)
      sessions.inject({}) do |h, (k, v)|
        s = {name: k}
        session = case v
        when String
          Session.new(name: k, command: v, kill: "C-c")
        when Hash
          Session.new(v.merge(name: k))
        end
        h[k] = session
        h
      end
    end

    def existed_session_names
      Terminal::ListSessions.call
    end
  end
end
