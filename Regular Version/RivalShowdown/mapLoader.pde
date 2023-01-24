class MapData {
  //images
  PImage map;
  ArrayList<ArrayList<PImage>> tileImages = new ArrayList<ArrayList<PImage>>();
  //map information
  int tilecount;
  int tilesize;
  HashMap<String, Integer> colorToIndexMap = new HashMap<String, Integer>();
  ArrayList<TileInformation> tilesInfo = new ArrayList<TileInformation>();
  //json parser
  JSONArray tileInfo;
  MapData(String path) {
    map = loadImage(path + "/map.jpg");
    tileInfo = loadJSONArray(path + "/info.json");
    parseTileInfo();

    PImage tiles = loadImage(path + "/tiles.png");
    splitTiles(tiles);
  }
  int getIndexWithColor(int r, int g, int b) {
    String hashmap_key = r + ":" + g + ":" + b;
    return colorToIndexMap.get(hashmap_key);
  }

  void parseTileInfo() {
    //map info
    JSONObject map_info = tileInfo.getJSONObject(0);
    tilesize = map_info.getInt("tilesize");
    tilecount = map_info.getInt("tilecount");
    //tile info
    for(int i=1;i<tileInfo.size();i++) {
      /* color to index */
      JSONObject tile_info_object = tileInfo.getJSONObject(i);
      JSONObject map_color = tile_info_object.getJSONObject("color");

      int red_color = map_color.getInt("red");
      int green_color = map_color.getInt("green");
      int blue_color = map_color.getInt("blue");
      String colorkey = red_color + ":" + green_color + ":" + blue_color;
      int map_index = tile_info_object.getInt("index");

      colorToIndexMap.put(colorkey, map_index);
      /* tile information */
      TileInformation info = new TileInformation(tile_info_object.getInt("framecount"), tile_info_object.getInt("framerate"));
      info.damage = tile_info_object.getInt("damage");
      info.speed = tile_info_object.getFloat("speed");
      info.wall = tile_info_object.getBoolean("wall");
      tilesInfo.add(info);
    }
  }
  void splitTiles(PImage tiles) {
    for(int i=0;i<tilecount;i++) {
      ArrayList<PImage> each_tile = new ArrayList<PImage>();
      for(int j=0;j<tilesInfo.get(i).framecount;j++) {
        PImage tileframe = tiles.get(j * tilesize, i * tilesize, tilesize, tilesize);
        each_tile.add(tileframe);
      }
      tileImages.add(each_tile);
    }
  }
}
class TileInformation {
  int framecount, framerate;
  int damage;
  float speed;
  boolean wall;
  TileInformation(int frames, int fps) {
    framecount = frames;
    framerate = fps;
    damage = 0;
    speed = 1;
    wall = false;
  }
}
