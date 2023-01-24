class TerminalCommand {
  TerminalCommand() {
  }
  void parseCommand(Terminal terminal, String command) {
    if(command.equals("$ help")) {
      terminal.messages.add("help ----- display the list of commands");
      terminal.messages.add("clear ----- clears the screen");
    }
    else {
      String[] words = command.substring(2, command.length()).split(" ");
    }
  }
}
