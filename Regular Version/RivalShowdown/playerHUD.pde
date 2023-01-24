class playerHUD {
  int reloadSpeed;
  int hp;
  int ammo;
Timer matchtimer;
  playerHUD() {
   //hp needs to be loaded in but idk how
   matchtimer = new Timer(300);
  }

  void render() {
    if (gameState == 2) {
      matchtimer.countDown();
      matchtimer.displayColor(255,0,128);
      matchtimer.display(width/2,height/4,25);
      //
      textSize(25);
      text("Health Remaining: ", width/8, height/2 - height/2.5);
      text("Time to reload: N/A", width/2 + width/3, height - height/8);
      text("Ammo Remaining: ∞", width/6, height - height/8);
    }
  }
}
