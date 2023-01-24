class MenuState extends States {

  MenuState() {
  }

  void render() {
    if(gameState == 0){
      Beautiful_Rivalry.play();
      GunsBlazing.pause();
      FallenRival.pause();
    }else{
      Beautiful_Rivalry.pause();
      FallenRival.pause();
      GunsBlazing.pause();
    }
    if(Beautiful_Rivalry.position() >= 12800){
      Beautiful_Rivalry.rewind();
    }
    background(127, 0, 255);
    image(titleBackground,0,0);
    fill(255, 255, 0);
    textAlign(CENTER, TOP);
    textSize(60);
     image(title,width/2-700,height/2-200);
     image(selectPrompt,width/2-450,height/1.5);
    //text("Press Space To Select", width/2, height/4 + height/2);
    
    fill(255, 255, 0);
    textSize(30);
    text("Currently connected to " + IP + " at port " + PORT, width / 2, 100);
  }

  void keyPressed(char k) {
    if (k == ' ') {
      connectClient();
      gameState = 1;
    }
    if (k == 'p'){
      gameState = 4;
    }
  }
  
  void mousePressed(int button) {
    if(mouseY > 100 && mouseY < 150) {
      gameState = 5;
    }
  }
}
