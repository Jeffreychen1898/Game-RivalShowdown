class Bullet {
    PImage m_image;

    float m_angle;

    PVector m_initialPosition;
    PVector m_position;
    PVector m_velocity;

    Bullet(PImage img, PVector position, PVector velocity) {
        m_image = img;
        m_initialPosition = position.copy();
        m_position = position.copy();
        m_velocity = velocity.copy();

        m_angle = atan2(velocity.y, velocity.x);
    }

    float getDistanceBetweenBullet(PVector target) {
        return dist(target.x, target.y, m_position.x, m_position.y);
    }

    boolean checkWallCollision(int map[], Tilemap tilemap) {
      int current_index_x = (int)(m_position.x / 50);
      int current_index_y = (int)(m_position.y / 50);
      if(current_index_y < 50 && current_index_x < 50 && current_index_y > -1 && current_index_x > -1) {
        TileInfo current_tile = tilemap.getTileInfo(map[current_index_y * 50 + current_index_x]);
        return current_tile.isWall;
      }

      return true;
    }

    void update(float deltaTime) {
        m_position.x += m_velocity.x * deltaTime;
        m_position.y += m_velocity.y * deltaTime;
    }

    void render(Camera camera) {
        imageMode(CENTER);

        camera.drawRotatedImage(m_image, m_position.x, m_position.y, 32, 32, m_angle);

        imageMode(CORNER);
    }

    boolean isDead() {
        return dist(m_position.x, m_position.y, m_initialPosition.x, m_initialPosition.y) > 500;
    }
}
