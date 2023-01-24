class SelectionState extends States {

  int player, buttonTransparency, playerTransparency;
  int pSpeed, pFirerate, pAttack, pHealth;

  ScrollBar scrollbar;

  SelectionState() {
    buttonTransparency = 127;
    player = 1;
    scrollbar = new ScrollBar(width / 2, height/6, 400, 100);
  }

  void render() {
    //println(Showdown.position());
    if(gameState == 1){
      Beautiful_Rivalry.pause();
      FallenRival.pause();
      GunsBlazing.pause();
      Showdown.play();
    }else{
      Showdown.pause();
    }
    if(Showdown.position() >= 3428){
      Showdown.rewind();
    }
    pSpeed = character.get(scrollbar.selectedIndex).walkingSpeed;
    pFirerate = character.get(scrollbar.selectedIndex).firerate;
    pAttack = character.get(scrollbar.selectedIndex).attack;
    pHealth = character.get(scrollbar.selectedIndex).hp;
    
    background(127);
    /*render the players onto the scrollbar*/
    scrollbar.render();
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(60);
    text("Choose Your Character!", width/2, height/6 - height/7);

    //Confirm Selection Button
    rectMode(CENTER);
    fill(20, 255, 0, buttonTransparency);
    rect(width/2, height - height/8, width/4, height/16);
    textAlign(CENTER, CENTER);
    fill(0, buttonTransparency);
    textSize(40);
    text("Confirm Selection", width/2, height - height/7);

    if (player > 0) {
      buttonTransparency = 255;
    } else
      buttonTransparency = 127;

    //Stats
    fill(155, 0, 220);
    text(character.get(scrollbar.selectedIndex).name, width/2, height/2 - height / 20);
    fill(0);
    text("Stats: ", width/2, height/2);
    text("Health: " + pHealth, width/2, height/2 + height/20 + height/20);
    text("Speed: " + pSpeed, width/2, height/2 + height/20 + height/20 + height/20);
    text("Attack: " + pAttack, width/2, height/2 + height/20 + height/20 + height/20 + height/20);
  }

  void mousePressed(int button) {

    if (mouseX > width/2 - width/2/4) {
      if (mouseX < width/2 + width/2/4) {
        if (mouseY > height - height/8 - (height - height/8)/16) {
          if (mouseY < height - height/8 + (height - height/8)/16) {
            Networking_send("confirm_selection", "character=" + selectedPlayerIndex);
            gameState = 2;
          }
        }
      }
    }
    
    scrollbar.mousePressed();
  }
}
