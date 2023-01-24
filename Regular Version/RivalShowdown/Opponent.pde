class Opponent {
  int characterChoice;
  PVector position;
  float health;
  float display_health;
  float max_health;
  float blastAlpha;
  Opponent() {
    characterChoice = 0;
    position = new PVector(0, 0);
    health = 1;
    display_health = 1;
    max_health = 1;
    blastAlpha = 0;
  }
  void update(float deltaTime) {
    if(blastAlpha > 0) {
      blastAlpha -= 100 * deltaTime;
      if(blastAlpha < 0) {
        blastAlpha = 0;
      }
    }
    display_health = lerp(display_health, health, 10.f * deltaTime);
  }
  void render(Camera cam) {
    imageMode(CORNER);
    cam.drawImage(character.get(characterChoice).walkingAnimation.get(0), position.x, position.y, BLOCK_SIZE, BLOCK_SIZE);
    noStroke();
    fill(255, 0, 0, blastAlpha);
    cam.drawEllipse(position.x + BLOCK_SIZE / 2, position.y + BLOCK_SIZE / 2, 500, 500);

    fill(45);
    cam.drawRect(position.x, position.y + BLOCK_SIZE + 20, BLOCK_SIZE, 10);
    fill(255, 0, 0);
    float pixels_per_hp = BLOCK_SIZE / max_health;
    cam.drawRect(position.x, position.y + BLOCK_SIZE + 20, pixels_per_hp * display_health, 10);
  }
}
