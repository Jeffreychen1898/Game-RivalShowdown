class Player {
  PlayerData playerData;
  float frameElapsedtime;
  boolean ready;
  PVector position;
  float speed;
Timer remainingTime;
  Node path;
  Node hoverPath;
  ArrayList<Bullet> bullets;
  ArrayList<EnemyBullet> enemyBullets;

  boolean shooting;

  float health;
  float displayHealth;
  float maxHealth;

  PVector mousePosition;

  float blastAlpha;
  Player() {
    ready = false;
    frameElapsedtime = 0;
    path = null;
    hoverPath = null;
    position = new PVector(100, 100);
    bullets = new ArrayList<Bullet>();
    mousePosition = new PVector(0, 0);
    enemyBullets = new ArrayList<EnemyBullet>();
    health = 1;
    displayHealth = 1;
    shooting = false;
    remainingTime = new Timer(300);
    blastAlpha = 0;
  }
  void getPlayer(PlayerData player) {
    if (!ready) {
      health = player.hp;
      displayHealth = player.hp;
      maxHealth = player.hp;
    }
    playerData = player;
    ready = true;
  }
  void update(float deltaTime, GameMap map, Opponent opponent) {
    if(blastAlpha > 0) {
      blastAlpha -= deltaTime * 100;
      if(blastAlpha < 0) {
        blastAlpha = 0;
      }
    }

    int index_x = int(position.x / BLOCK_SIZE);
    int index_y = int(position.y / BLOCK_SIZE);
    int map_index = map.tilemap.get(index_y).get(index_x);
    health -= map.mapInfo.tilesInfo.get(map_index).damage;
    if (ready) {
      frameElapsedtime += deltaTime;
      speed = min(playerData.walkingSpeed * deltaTime, 99);
      int stepping_on_tile = map.tilemap.get(int(position.y / BLOCK_SIZE)).get(int(position.x / BLOCK_SIZE));
      TileInformation tile_info = map.mapInfo.tilesInfo.get(stepping_on_tile);
      speed *= tile_info.speed;
      remainingTime.countDown();
    }

    /*
    if path exist
     get the direction
     check to see if the next's parent exist
     get the direction
     if both direction are not the same
     if approaching the next tile
     set to next tile location
     path = path.parent
     */
    if (path != null) {
      PVector direction = new PVector(path.parent.location.x - path.location.x, path.parent.location.y - path.location.y);
      PVector next_direction = null;
      if (path.parent.parent != null) {
        Node next_node = path.parent;
        Node node_after = path.parent.parent;
        next_direction = new PVector(node_after.location.x - next_node.location.x, node_after.location.y - next_node.location.y);
      }
      if (!matchingPVector(direction, next_direction)) {
        PVector next_tile_position = path.parent.location.copy();
        next_tile_position.mult(BLOCK_SIZE);
        float distance = dist(position.x, position.y, next_tile_position.x, next_tile_position.y);
        if (distance < speed) {
          position.x = next_tile_position.x;
          position.y = next_tile_position.y;
          path = path.parent;
          if (path.parent == null) {
            path = null;
          }
        } else {
          direction.mult(speed);
          position.add(direction);
        }
      } else {
        PVector next_tile_position = path.parent.location.copy();
        next_tile_position.mult(BLOCK_SIZE);
        if (dist(position.x, position.y, next_tile_position.x, next_tile_position.y) < speed) {
          path = path.parent;
        }
        direction.mult(speed);
        position.add(direction);
      }
    }
    //update the bullet position
    for (int i=0; i<bullets.size(); i++) {
      //bullet move
      Bullet bullet = bullets.get(i);
      //bullet.position.x += cos(bullet.ang) * bullet.bspeed * deltaTime;
      //bullet.position.y += sin(bullet.ang) * bullet.bspeed * deltaTime;
      float travel_distance = (float)((getTime() - bullet.start_time) / 1000.0);
      if(travel_distance < 0) {
        continue;
      }
      bullet.position.x = bullet.initalPosition.x + cos(bullet.ang) * bullet.bspeed * travel_distance;
      bullet.position.y = bullet.initalPosition.y + sin(bullet.ang) * bullet.bspeed * travel_distance;

      //check for collision on blocks
      PVector tile_position = bullet.position.copy();
      tile_position.x = int(tile_position.x / BLOCK_SIZE);
      tile_position.y = int(tile_position.y / BLOCK_SIZE);
      boolean bullet_collision = false;

      //check if out of range
      if (dist(bullet.position.x, bullet.position.y, bullet.initalPosition.x, bullet.initalPosition.y) > 1000) {
        bullet_collision = true;
      }
      //check if bullet on enemy
      if (isOverlappingPlayer(bullet.position, opponent.position)) {
        bullet_collision = true;
      }
      //remove the bullet
      if (bullet_collision) {
        bullets.remove(i);
        i --;
      }
    }
    for (int i=0; i<enemyBullets.size(); i++) {
      EnemyBullet bullet = enemyBullets.get(i);
      long current_time = getTime();
      //difference in time, convert to seconds, convert to float
      float dt = (float)((current_time - bullet.start_time) / 1000.f);
      bullet.bullet_started = dt > 0;
      if(!bullet.bullet_started) {
        continue;
      }
      bullet.update();

      //check for collision on blocks
      PVector tile_position = bullet.current_position.copy();
      tile_position.x = int(tile_position.x / BLOCK_SIZE);
      tile_position.y = int(tile_position.y / BLOCK_SIZE);
      boolean bullet_collision = false;

      //check if bullet on player
      if (isOverlappingPlayer(bullet.current_position, position)) {
        bullet_collision = true;
        health -= character.get(opponent.characterChoice).attack;
      }
      if (dist(bullet.current_position.x, bullet.current_position.y, bullet.initial_position.x, bullet.initial_position.y) > 1000) {
        bullet_collision = true;
      }
      //remove the bullet
      if (bullet_collision) {
        enemyBullets.remove(i);
        i --;
      }
    }
    //lerp the hp
    if (health < 0) {
      Networking_send("death", "");
      gameState = 3;
      health = 0;
    }
    /*if(remainingTime.alarm() == true){
      Networking_send("death","");
      gameState = 3;
         health = 0;
    }*/
    displayHealth = lerp(displayHealth, health, 10.f * deltaTime);
    Networking_send("health", "hp=" + health);
  }
  boolean isOverlappingPlayer(PVector position, PVector objectPosition) {
    if (position.x > objectPosition.x && position.x < objectPosition.x + BLOCK_SIZE && position.y > objectPosition.y && position.y < objectPosition.y + BLOCK_SIZE) {
      return true;
    }
    return false;
  }
  void render(Camera cam) {
    mousePosition = cam.pointToWorldSpace(mouseX, mouseY);

    cam.position.x = lerp(cam.position.x, position.x, 0.1);
    cam.position.y = lerp(cam.position.y, position.y, 0.1);
    //render the path that player is following
    Node current = path;
    stroke(255, 0, 255);
    strokeWeight(10);
    while (current != null) {
      if (current.parent != null) {
        PVector position_one = current.location.copy();
        PVector position_two = current.parent.location.copy();
        position_one.mult(BLOCK_SIZE);
        position_two.mult(BLOCK_SIZE);
        position_one.add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
        position_two.add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
        cam.drawLine(position_one.x, position_one.y, position_two.x, position_two.y);
      }
      current = current.parent;
    }
    //render the path from the player position to the mouse
    if (path == null) {
      Node hoverpath_current = hoverPath;
      stroke(255, 255, 0);
      strokeWeight(10);
      while (hoverpath_current != null) {
        if (hoverpath_current.parent != null) {
          PVector position_one = hoverpath_current.location.copy();
          PVector position_two = hoverpath_current.parent.location.copy();
          position_one.mult(BLOCK_SIZE);
          position_two.mult(BLOCK_SIZE);
          position_one.add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
          position_two.add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
          cam.drawLine(position_one.x, position_one.y, position_two.x, position_two.y);
        }
        hoverpath_current = hoverpath_current.parent;
      }
    }
    //render the bullets
    for (Bullet bullet : bullets) {
      bullet.display(cam);
    }
    for (EnemyBullet bullet : enemyBullets) {
      bullet.render(cam);
    }

    if (ready) {
      //render the player
      renderPlayer(cam);
      noStroke();
      fill(0, 255, 0, blastAlpha);
      cam.drawEllipse(position.x + BLOCK_SIZE / 2.f, position.y + BLOCK_SIZE / 2.f, 500, 500);
      //render the hp bar
      fill(45);
      rect(50, 50, width / 2, 30);
      float pixels_per_hp = (width / 2.f) / maxHealth;
      fill(255, 0, 0);
      rect(50, 50, pixels_per_hp * displayHealth, 30);
    }
  }
  void renderPlayer(Camera cam) {
    PImage player_image = playerData.walkingAnimation.get(0);
    imageMode(CORNER);
    
    if(path != null) {
      float time_per_frame = 1.f / playerData.walkingFramerate;
      int frame_count = int(frameElapsedtime / time_per_frame) % playerData.walkingFrameCount;
      player_image = playerData.walkingAnimation.get(frame_count);
    }
    cam.drawImage(player_image, position.x, position.y, BLOCK_SIZE, BLOCK_SIZE);
  }
  boolean matchingPVector(PVector first, PVector second) {
    if (first == null || second == null) {
      return false;
    }
    return first.x == second.x && first.y == second.y;
  }
  void setHoverPath(Node start_node) {
    hoverPath = start_node;
  }
  void getPath(Node new_path) {
    if (path == null) {
      path = new_path;
    }
  }
  void shoot() {
    long bullet_shot_time = getTime() + ARTIFICIAL_LAG;
    //add bullet
    GunShot.rewind();
    GunShot.play();
    float bullet_speed = 1000;
    PVector bullet_position = position.copy().add(BLOCK_SIZE / 2.f, BLOCK_SIZE / 2.f);
    float bullet_angle = atan2(mousePosition.y - bullet_position.y, mousePosition.x - bullet_position.x);
    Bullet new_bullet = new Bullet(bullet_position.x, bullet_position.y, bullet_speed, playerData.attack, bullet_angle, playerData.bulletImage);
    new_bullet.start_time = bullet_shot_time;
    bullets.add(new_bullet);

    String data_position = "&positionX=" + bullet_position.x + "&positionY=" + bullet_position.y;
    String time = String.valueOf(bullet_shot_time);
    Networking_send("bullet", "angle=" + bullet_angle + data_position + "&time=" + time + "&velocity=" + bullet_speed);
  }
  void addEnemyBullet(float x, float y, float ang, float velo, long time) {
    PVector position = new PVector(x, y);
    EnemyBullet enemy_bullet = new EnemyBullet(playerData.bulletImage, position, ang, time, velo);
    enemyBullets.add(enemy_bullet);
  }
}
