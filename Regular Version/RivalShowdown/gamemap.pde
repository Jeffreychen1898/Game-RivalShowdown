int BLOCK_SIZE = 100;

class GameMap {
  ArrayList<ArrayList<Integer>> tilemap;
  boolean ready;
  MapData mapInfo;
  GameMap() {
    mapInfo = null;
    ready = false;
    tilemap = new ArrayList<ArrayList<Integer>>();
  }
  void getMap(MapData mapdata) {

    mapInfo = mapdata;

    HashMap<String, Integer> color_to_index = mapdata.colorToIndexMap;

    tilemap.clear();
    PImage mapimage = mapdata.map;
    for(int i=0;i<mapimage.height;i++) {
      ArrayList<Integer> eachrow = new ArrayList<Integer>();
      for(int j=0;j<mapimage.width;j++) {
        color getmapcolor = mapimage.get(j, i);
        int red_color = int(red(getmapcolor));
        int green_color = int(green(getmapcolor));
        int blue_color = int(blue(getmapcolor));
        String color_key = red_color + ":" + green_color + ":" + blue_color;
        
        eachrow.add(color_to_index.get(color_key));
      }
      tilemap.add(eachrow);
    }
    ready = true;
  }
  void render(Camera gameCamera) {
    if(ready) {
      PVector starting_tile = new PVector(gameCamera.position.x - gameCamera.size.x / 2, gameCamera.position.y - gameCamera.size.y / 2);
      PVector ending_tile = new PVector(gameCamera.position.x + gameCamera.size.x / 2, gameCamera.position.y + gameCamera.size.y / 2);
      starting_tile.x = int(starting_tile.x / BLOCK_SIZE);
      starting_tile.y = int(starting_tile.y / BLOCK_SIZE);
      ending_tile.x = int(ending_tile.x / BLOCK_SIZE) + 1;
      ending_tile.y = int(ending_tile.y / BLOCK_SIZE) + 1;
      int currentMillisecond = millis();
      for(int i=max(0, int(starting_tile.y));i<min(tilemap.size(), ending_tile.y);i++) {
        for(int j=max(0, int(starting_tile.x));j<min(tilemap.get(i).size(), ending_tile.x);j++) {
          int current_tile = tilemap.get(i).get(j);
          int framecount = mapInfo.tilesInfo.get(current_tile).framecount;
          float animation_deltatime = 1000.f / mapInfo.tilesInfo.get(current_tile).framerate;
          int milliseconds = int(currentMillisecond / animation_deltatime);
          int current_frame = milliseconds % framecount;
          gameCamera.drawImage(mapInfo.tileImages.get(current_tile).get(current_frame), j * BLOCK_SIZE, i * BLOCK_SIZE, BLOCK_SIZE + 1, BLOCK_SIZE + 1);
        }
      }
    }
  }
}
