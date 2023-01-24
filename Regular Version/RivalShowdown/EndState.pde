class EndState extends States {
PImage loseendBackground,winendbackground;
  EndState() {
    loseendBackground = loadImage("res/backgrounds/loseendBackground.jpg");
    winendbackground = loadImage("res/backgrounds/winendBackground.jpg");
  }

  void render() {
    if (win == false) {
      if (gameState == 3) {
        FallenRival.play();
      } else {
        FallenRival.pause();
      }
      if (FallenRival.position() >= 12800) {
        FallenRival.rewind();
      }
      //background(135, 166, 247, 70);
      image(loseendBackground,0,0);
      fill(255, 255, 0);
      textSize(60);
      textAlign(CENTER, TOP);
      text("You Lose...", width/2, height/4);
      image(returnPrompt, width/2-450, height/1.5);
    }
    if (win == true) {
      if(gameState == 3){
        GunsBlazing.play();
      } else {
       GunsBlazing.pause(); 
      }
      if(GunsBlazing.position() >= 12800){
       GunsBlazing.rewind(); 
      }
     // background(138, 201, 232, 70);
      image(winendbackground,0,0);
      fill(255, 255, 0);
      textSize(60);
      textAlign(CENTER, TOP);
      text("You Win!", width/2, height/4);
      image(returnPrompt, width/2-450, height/1.5);
    }
  }

  void keyPressed(char k) {
    if (key == 'r') {
      setupGame();
    }
  }
}
