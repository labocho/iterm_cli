module ITermCLI
  module Terminal
    class SendKeys < Function
      SOURCE = <<-JS.freeze
        function run(argv) {
          var options = JSON.parse(argv[0]);
          var iTerm = Application("iTerm2");
          var window = iTerm.currentWindow();
          var i, session;

          for (i = 0; i < window.tabs.length; i++) {
            session = window.tabs[i].currentSession();
            if (session.name() === options.target) {
              session.write({text: options.text});
            }
          }

          return;
        }
      JS

      def call(keys, options = {})
        options = {target: nil}.merge(options)
        target = options[:target]

        text = keys.map {|t|
          case t
          when /\AC-(.)$\z/
            ($1.ord & 0b00011111).chr
          when "Enter"
            "\n"
          else
            t
          end
        }.join(" ")

        osascript(SOURCE, target: target, text: text)
      end
    end
  end
end
