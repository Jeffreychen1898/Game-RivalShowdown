class Tilemap {

    ArrayList<ArrayList<PImage>> m_images;
    ArrayList<TileInfo> m_tileInfo;

    float m_timePassed;

    Tilemap(String path) {
        JSONArray tiles_info = loadJSONArray(path + "/info.json");
        int tile_size, tile_count;
        {
            JSONObject object = tiles_info.getJSONObject(0);
            tile_size = object.getInt("tilesize");
            tile_count = object.getInt("tilecount");
        }

        m_tileInfo = new ArrayList<TileInfo>();
        for(int i=1;i<tiles_info.size();i++) {
            JSONObject object = tiles_info.getJSONObject(i);

            int frame_count = object.getInt("framecount");
            int frame_rate = object.getInt("framerate");
            float player_speed = object.getFloat("speed");
            boolean is_wall = object.getBoolean("wall");

            TileInfo new_tile = new TileInfo(frame_count, frame_rate, player_speed, is_wall);
            m_tileInfo.add(new_tile);
        }

        m_images = new ArrayList<ArrayList<PImage>>();
        PImage spritesheet = loadImage(path + "/tiles.png");
        for(int i=0;i<tile_count;i++) {

            TileInfo tile_info = m_tileInfo.get(i);
            ArrayList<PImage> each_tile_sprites = new ArrayList<PImage>();

            for(int j=0;j<tile_info.tileFrameCount;j++) {
                PImage each_frame = spritesheet.get(j * tile_size, i * tile_size, tile_size, tile_size);
                each_tile_sprites.add(each_frame);
            }

            m_images.add(each_tile_sprites);
        }

        m_timePassed = 0;
    }

    TileInfo getTileInfo(int tile) {
        return m_tileInfo.get(tile);
    }

    void update(float deltaTime) {
        m_timePassed += deltaTime;
    }

    void renderTileMap(Camera camera, int tilemap[]) {
        for(int i=0;i<50;i++) {
            for(int j=0;j<50;j++) {
                TileInfo tile_info = m_tileInfo.get(tilemap[i * 50 + j]);
                float frame_duration = 1.f / tile_info.tileFrameRate;
                int frame = (int)(m_timePassed / frame_duration) % tile_info.tileFrameCount;

                PImage tile_image = m_images.get(tilemap[i * 50 + j]).get(frame);
                camera.drawImage(tile_image, j * 50, i * 50, 50, 50);
            }
        }
    }
}

class TileInfo {

    int tileFrameCount, tileFrameRate;
    float speed;
    boolean isWall;

    TileInfo(int _frameCount, int _frameRate, float _speed, boolean _isWall) {
        tileFrameCount = _frameCount;
        tileFrameRate = _frameRate;
        speed = _speed;
        isWall = _isWall;
    }
}