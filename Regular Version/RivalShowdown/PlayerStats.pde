class PlayerStats extends States {

  PlayerStats() {
    
  }
}

void render() {
  if (gameState == 4 || gameState == 0) {
    Beautiful_Rivalry.play();
  } else if (gameState != 4 || gameState != 0) {
    Beautiful_Rivalry.pause();
  }

  background(0);
  textSize(60);
  textAlign(CENTER, TOP);
  fill(255);
  text("Player Stats", width/2, height/4);
}
