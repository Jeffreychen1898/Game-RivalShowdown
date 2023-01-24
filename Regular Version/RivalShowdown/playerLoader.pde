class PlayerData {
  ArrayList<PImage> walkingAnimation = new ArrayList<PImage>();
  ArrayList<PImage> shootingAnimation = new ArrayList<PImage>();
  PImage bulletImage;
  PImage displayImage;

  int walkingFrameCount;
  int shootingFrameCount;
  int walkingFramerate;
  int shootingFramerate;
  int walkingSpeed;
  int firerate;
  int hp;
  int attack;
  String name;
  PlayerData(String path) {
    loadPlayerInfo(path);
    splitPlayerFrames(path);
    bulletImage = loadImage(path + "/bullet.png");
    displayImage = loadImage(path + "/display.png");
  }
  
  void splitPlayerFrames(String path) {
    PImage player_image = loadImage(path + "/player.png");
    //split the frames of the walking animation
    for(int i=0;i<walkingFrameCount;i++) {
      PImage each_frame = player_image.get(32 * i, 0, 32, 32);
      walkingAnimation.add(each_frame);
    }
    //split the frames of the shooting animation
    for(int i=0;i<shootingFrameCount;i++) {
      PImage each_frame = player_image.get(32 * i, 32, 32, 32);
      shootingAnimation.add(each_frame);
    }
  }
  void loadPlayerInfo(String path) {
    String load_info[] = loadStrings(path + "/info.txt");
    String mode = "";
    for(String each : load_info) {
      if(each.charAt(0) == '#') {
        mode = each;
      } else {
        insertValue(each, mode);
      }
    }
  }
  void insertValue(String each, String mode) {
    switch(mode) {
      case "#walking frame count":
        walkingFrameCount = Integer.parseInt(each);
        break;
      case "#walking frame rate":
        walkingFramerate = Integer.parseInt(each);
        break;
      case "#shooting frame count":
        shootingFrameCount = Integer.parseInt(each);
        break;
      case "#shooting frame rate":
        shootingFramerate = Integer.parseInt(each);
        break;
      case "#speed":
        walkingSpeed = Integer.parseInt(each);
        break;
      case "#name":
        name = each;
        break;
      case "#fire rate":
        firerate = Integer.parseInt(each);
        break;
      case "#health":
        hp = Integer.parseInt(each);
        break;
      case "#attack":
        attack = Integer.parseInt(each);
        break;
    }
  }
}
