class EnemyBullet {
  PImage bulletImage;
  PVector initial_position, current_position;
  float angle;
  long start_time;
  float velocity;
  boolean bullet_started;
  EnemyBullet(PImage img, PVector pos, float ang, long time, float velo) {
    bulletImage = img;
    initial_position = pos;
    current_position = pos.copy();
    angle = ang;
    start_time = time;
    velocity = velo;
    bullet_started = false;
  }
  void update() {
    //get the current time
    long current_time = getTime();
    //difference in time, convert to seconds, convert to float
    float deltaTime = (float)((current_time - start_time) / 1000.f);
    if(deltaTime > 0) {
      float speed = velocity * deltaTime;
      current_position.x = initial_position.x + cos(angle) * speed;
      current_position.y = initial_position.y + sin(angle) * speed;
    }
    
  }
  void render(Camera cam) {
    imageMode(CENTER);
    cam.drawImageRotated(bulletImage, current_position.x, current_position.y, 45, 45, angle);
  }
}
