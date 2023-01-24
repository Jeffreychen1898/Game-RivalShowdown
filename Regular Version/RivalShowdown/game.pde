class GameState extends States {
  GameMap gameMap;
  MapData sampleMap;
  PImage mapImg, matchingBackground, matchingText;
  Camera gameCamera;
  float aspectRatio;
  Player player;
  Opponent opponent;
  boolean ready;
  long lastBlastTime;
  GameState() {
    sampleMap = new MapData("res/grassyLand");
    gameMap = new GameMap();
    matchingBackground = loadImage("res/backgrounds/matchingBackground.jpg");
    matchingText = loadImage("res/backgrounds/matchingText.png");
    player = new Player();

    opponent = new Opponent();

    PVector campos = new PVector(0, 0);
    aspectRatio = float(height) / float(width);
    float camheight = 1600.f * aspectRatio;
    PVector camsize = new PVector(1600, camheight);
    gameCamera = new Camera(campos, camsize);
    ready = false;

    lastBlastTime = 0;
  }
  void update(float deltaTime) {
    //parse requests
    ArrayList<HashMap<String, String>> requests = Networking_recieve();
    if (requests != null) {
      for (HashMap<String, String> request : requests) {
        if (!request.containsKey("name")) {
          continue;
        }
        if (request.get("name").equals("opponent")) {
          //set the player position
          int player_position = Integer.parseInt(request.get("position"));
          player.position = new PVector(player_position, player_position);
          //set the opponent's sprite
          opponent.characterChoice = Integer.parseInt(request.get("character"));
          float opponent_health = character.get(opponent.characterChoice).hp;
          opponent.max_health = opponent_health;
          opponent.health = opponent_health;
          opponent.display_health = opponent_health;

          println(Integer.parseInt(request.get("map")));
          gameMap.getMap(maps.get(Integer.parseInt(request.get("map"))));
          //set ready to true
          ready = true;
        } else if (request.get("name").equals("update_character_position")) {
          float new_position_x = Float.parseFloat(request.get("positionX"));
          float new_position_y = Float.parseFloat(request.get("positionY"));
          opponent.position = new PVector(new_position_x, new_position_y);
        } else if (request.get("name").equals("send_bullets")) {
          float bullet_position_x = Float.parseFloat(request.get("positionX"));
          float bullet_position_y = Float.parseFloat(request.get("positionY"));
          float bullet_angle = Float.parseFloat(request.get("angle"));
          long bullet_start_time = Long.parseLong(request.get("time"));
          float velocity = Float.parseFloat(request.get("velocity"));
          player.addEnemyBullet(bullet_position_x, bullet_position_y, bullet_angle, velocity, bullet_start_time);
        } else if (request.get("name").equals("update_health")) {
          float opponent_health = Float.parseFloat(request.get("hp"));
          opponent.health = opponent_health;
        } else if (request.get("name").equals("victory")) {
          win = true;
          gameState = 3;
        } else if (request.get("name").equals("send_blast")) {
          opponent.blastAlpha = 255;
          if(dist(player.position.x, player.position.y, opponent.position.x, opponent.position.y) < 250) {
            player.health -= 100;
          }
        }
      }
    }

    if (ready) {
      //get the player hover path(player path to mouse)
      if (gameMap.ready) {
        PVector mouse_position = gameCamera.pointToWorldSpace(mouseX, mouseY);
        PVector player_position = player.position.copy();
        mouse_position.x = int(mouse_position.x / BLOCK_SIZE);
        mouse_position.y = int(mouse_position.y / BLOCK_SIZE);
        player_position.x = int(player_position.x / BLOCK_SIZE);
        player_position.y = int(player_position.y / BLOCK_SIZE);
        PVector start_tile = new PVector(gameCamera.position.x - gameCamera.size.x / 2, gameCamera.position.y - gameCamera.size.y / 2);
        PVector end_tile = new PVector(gameCamera.position.x + gameCamera.size.x / 2, gameCamera.position.y + gameCamera.size.y / 2);
        start_tile.x = int(start_tile.x / BLOCK_SIZE);
        start_tile.y = int(start_tile.y / BLOCK_SIZE);
        end_tile.x = int(end_tile.x / BLOCK_SIZE) + 1;
        end_tile.y = int(end_tile.y / BLOCK_SIZE) + 1;
        Astar pathfinder = new Astar(player_position, mouse_position, gameMap.tilemap, gameMap.mapInfo.tilesInfo, start_tile, end_tile);
        player.setHoverPath(pathfinder.path);
      }
      //update other parts of the game
      player.update(deltaTime, gameMap, opponent);
      //update the opponent
      opponent.update(deltaTime);

      //send the player position
      Networking_send("character_position", "positionX=" + player.position.x + "&positionY=" + player.position.y);
    }
  }
  void render() {
    if (gameState == 2) {
      Showdown.pause();
    }
    if (ready) {
      player.getPlayer(character.get(selectedPlayerIndex));
      gameMap.render(gameCamera);
      player.render(gameCamera);
      opponent.render(gameCamera);
      renderMinimap();
    } else {
      fill(255);
      image(matchingBackground, 0, 0);
      textAlign(CENTER, CENTER);
      textSize(20);
      image(matchingText, width/2-100, height/1.5-25);
      //text("Matching . . .", width / 2, height / 2);
    }
  }
  void renderMinimap() {
    fill(0);
    rect(width - 220, 20, 200, 200);

    PVector player_position = player.position.copy();
    player_position.x = map(player_position.x, 0, 10000, width-220, width-20);
    player_position.y = map(player_position.y, 0, 10000, 20, 220);
    PVector enemy_position = opponent.position.copy();
    enemy_position.x = map(enemy_position.x, 0, 10000, width-220, width-20);
    enemy_position.y = map(enemy_position.y, 0, 10000, 20, 220);
    fill(0, 255, 0);
    ellipse(player_position.x, player_position.y, 5, 5);
    fill(255, 0, 0);
    ellipse(enemy_position.x, enemy_position.y, 5, 5);
  }
  void keyPressed(char k) {
    if(k == ' ' && getTime() - lastBlastTime > 5000) {
      Networking_send("blast", "");
      player.blastAlpha = 255;
      lastBlastTime = getTime();
    }
  }
  void keyReleased(char k) {
  }
  void mouseWheel(float offset) {
    if (ready) {
      gameCamera.size.x += (gameCamera.size.x * 0.05) * offset;
      gameCamera.size.y += (gameCamera.size.y * 0.05) * offset;
      gameCamera.size.x = max(1000, gameCamera.size.x);
      gameCamera.size.y = max(1000 * aspectRatio, gameCamera.size.y);
      gameCamera.size.x = min(3000, gameCamera.size.x);
      gameCamera.size.y = min(3000 * aspectRatio, gameCamera.size.y);
    }
  }
  void mousePressed(int button) {
    if (ready && player.ready) {
      if (button == RIGHT) {
        PVector mouse_position = gameCamera.pointToWorldSpace(mouseX, mouseY);
        PVector player_position = player.position.copy();
        mouse_position.x = int(mouse_position.x / BLOCK_SIZE);
        mouse_position.y = int(mouse_position.y / BLOCK_SIZE);
        player_position.x = int(player_position.x / BLOCK_SIZE);
        player_position.y = int(player_position.y / BLOCK_SIZE);
        PVector start_tile = new PVector(gameCamera.position.x - gameCamera.size.x / 2, gameCamera.position.y - gameCamera.size.y / 2);
        PVector end_tile = new PVector(gameCamera.position.x + gameCamera.size.x / 2, gameCamera.position.y + gameCamera.size.y / 2);
        start_tile.x = int(start_tile.x / BLOCK_SIZE);
        start_tile.y = int(start_tile.y / BLOCK_SIZE);
        end_tile.x = int(end_tile.x / BLOCK_SIZE) + 1;
        end_tile.y = int(end_tile.y / BLOCK_SIZE) + 1;
        Astar pathfinder = new Astar(player_position, mouse_position, gameMap.tilemap, gameMap.mapInfo.tilesInfo, start_tile, end_tile);
        player.getPath(pathfinder.path);
      } else if (button == LEFT) {
        player.shoot();
      }
    }
  }
}
