final int TERMINAL_FONT_SIZE = 16;
class Terminal {
  ArrayList<String> messages;
  String currentCommand;
  String commandCalled;
  TerminalCommand terminalCommandHandler;
  Terminal() {
    terminalCommandHandler = new TerminalCommand();
    messages = new ArrayList<String>();
    currentCommand = "$ ";
    commandCalled = null;
    messages.add("This is a very basic terminal window to help you manage the server!");
    messages.add("Type \"help\" to get the list of commands!");
  }
  void render() {
    fill(50);
    rect(0, 0, width, height);
    fill(200);
    textAlign(LEFT, TOP);
    textFont(terminalFont, TERMINAL_FONT_SIZE);
    for(int i=0;i<messages.size();i++) {
      text(messages.get(i), 10, i * 20 + 5);
    }
    text(currentCommand, 10, messages.size() * 20 + 5);
    rect(textWidth(currentCommand) + 10, messages.size() * 20 + 5, 5, 14);
  }
  void keyPressed(char k, int kcode) {
    if(kcode == ENTER && currentCommand != "$ ") {
      messages.add(currentCommand);
      commandCalled = currentCommand.toLowerCase();
      currentCommand = "$ ";
      if(terminalCommandResponse(commandCalled)) {
        commandCalled = null;
      } else {
        terminalCommandHandler.parseCommand(this, commandCalled);
        commandCalled = null;
      }
    } else if(kcode == BACKSPACE) {
      if(currentCommand.length() > 2) {
        currentCommand = currentCommand.substring(0, currentCommand.length() - 1);
      }
    } else if(kcode > 31 && kcode < 127) {
      currentCommand += k;
    }
  }
  boolean terminalCommandResponse(String command) {
    if(command.equals("$ clear")) {
      messages.clear();
      messages.add("This is a very basic terminal window to help you manage the server!");
      messages.add("Type \"help\" to get a list of commands!");
      return true;
    }
    return false;
  }
}
