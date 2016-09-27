module ITermCLI
  module Terminal
    class ListSessions < Function
      SOURCE = <<-JS
        function run(argv) {
          var iTerm = Application("iTerm2");
          var window = iTerm.currentWindow();
          var names = [];
          var i, tab;

          for (i = 0; i < window.tabs.length; i++) {
            tab = window.tabs[i];
            names.push(tab.currentSession().name());
          }

          return names.join("\\n");
        }
      JS

      def call
        osascript(SOURCE).split("\n")
      end
    end
  end
end
