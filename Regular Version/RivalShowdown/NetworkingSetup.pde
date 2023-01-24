class NetworkingSetupState extends States {
  String ipDisplay;
  String portDisplay;
  NumberInput ipInput;
  NumberInput portInput;
  NetworkingSetupState() {
    ipDisplay = IP;
    portDisplay = str(PORT);
    
    ipInput = new NumberInput(13);
    ipInput.value = ipDisplay;
    ipInput.position = new PVector(width / 2, 300);
    ipInput.size = new PVector(300, 50);
    
    portInput = new NumberInput(5);
    portInput.position = new PVector(width / 2, 500);
    portInput.size = new PVector(300, 50);
    portInput.value = portDisplay;
  }
  void update(float deltaTime) {
    playMusic();
  }
  void render() {
    textAlign(CENTER, CENTER);
    fill(255, 255, 0);
    text("IP: " + ipDisplay, width / 2, 200);
    ipInput.display();
    textAlign(CENTER, CENTER);
    fill(255, 255, 0);
    text("PORT: 2345", width / 2, 400);
    portInput.display();
    fill(255, 255, 0);
    rect(width / 2, 700, 200, 100);
    fill(0);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("Save", width / 2, 700);
  }
  void mousePressed(int button) {
    ipInput.setFocus();
    portInput.setFocus();
    
    if(mouseX > width / 2 - 100 && mouseX < width / 2 + 100 && mouseY > 650 && mouseY < 750) {
      IP = ipInput.value;
      PORT = Integer.parseInt(portInput.value);
      gameState = 0;
    }
  }
  void keyPressed(char k) {
    ipInput.keyPressed(k);
    portInput.keyPressed(k);
  }
  void playMusic() {
    Beautiful_Rivalry.play();
    GunsBlazing.pause();
    FallenRival.pause();
    if(Beautiful_Rivalry.position() >= 12800){
      Beautiful_Rivalry.rewind();
    }
  }
}

class NumberInput {
  String value;
  boolean isFocus;
  int limit;
  PVector position;
  PVector size;
  NumberInput(int lim) {
    isFocus = false;
    value = "";
    position = new PVector(0, 0);
    size = new PVector(0, 0);
    limit = lim;
  }
  void display() {
    rectMode(CENTER);
    textAlign(LEFT, CENTER);
    fill(255);
    if(isFocus)
      fill(150);
    rect(position.x, position.y, size.x, size.y);
    fill(0);
    text(value, position.x - size.x / 2 + 10, position.y);
  }
  void keyPressed(char k) {
    if(value.length() >= limit || !isFocus) return;
    String numbers = "0123456789";
    if(numbers.indexOf(k) > -1)  {
      value += k;
    }
    if(k == '.') value += k;
  }
  void setFocus() {
    if(mouseX > position.x - size.x / 2 && mouseX < position.x + size.y / 2) {
      if(mouseY > position.y - size.y / 2 && mouseY < position.y + size.y / 2) {
        isFocus = true;
        value = "";
      }
    }
  }
}
