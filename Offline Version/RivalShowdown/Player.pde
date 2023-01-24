class Player {
    CharacterData m_characterData;

    PVector m_position;
    PVector m_velocity;
    PVector m_size;

    float m_animationCounter;
    ArrayList<PImage> m_walkingAnimations;
    ArrayList<PImage> m_shootingAnimations;

    PImage m_bulletImage;
    ArrayList<Bullet> m_bullets;

    float m_maxHealthPoint;
    float m_healthPoint;
    float m_displayHealth;

    Player(CharacterData character_info, String path, PVector position) {
        m_position = position;
        m_characterData = character_info;

        m_size = new PVector(50, 50);
        m_velocity = new PVector(0, 0);
        m_bullets = new ArrayList<Bullet>();
        m_maxHealthPoint = character_info.health;
        m_healthPoint = m_maxHealthPoint;
        m_displayHealth = m_healthPoint;

        loadSpriteSheet(path);
        m_bulletImage = loadImage(path + "/bullet.png");
    }

    void update(float deltaTime, int map[], Tilemap tilemap) {
        if(Math.abs(m_velocity.x) > 1 || Math.abs(m_velocity.y) > 1)
            m_animationCounter += deltaTime;
        else
            m_animationCounter = 0;

        calculateCollision(deltaTime, map, tilemap);
        for(int i=0;i<m_bullets.size();i++) {
          if(m_bullets.get(i).checkWallCollision(map, tilemap)) {
            m_bullets.remove(i);
            i --;
          }
        }

        m_position.x += m_velocity.x * deltaTime;
        m_position.y += m_velocity.y * deltaTime;

        m_velocity.mult(0.5);

        for(int i=0;i<m_bullets.size();i++) {
            m_bullets.get(i).update(deltaTime);
            if(m_bullets.get(i).isDead()) {
                m_bullets.remove(i);
                i --;
            }
        }

        m_displayHealth = lerp(m_displayHealth, m_healthPoint, 10.f * deltaTime);
        if(m_displayHealth < 0) m_displayHealth = 0;
    }

    void checkBulletCollision(Player enemy) {
        for(int i=0;i<m_bullets.size();i++) {
            if(m_bullets.get(i).getDistanceBetweenBullet(enemy.getPosition()) < m_size.x / 2.f) {
                enemy.loseHealth(m_characterData.attack);
                m_bullets.remove(i);
                i --;
            }
        }
    }

    void loseHealth(float health) {
        m_healthPoint -= health;
    }

    void render(Camera camera) {
        imageMode(CENTER);

        float frame_duration = 1.f / m_characterData.getWalkingFrameRate();
        int frame = (int)(m_animationCounter / frame_duration) % m_characterData.getWalkingFrameCount();
        camera.drawImage(m_walkingAnimations.get(frame), m_position.x, m_position.y, m_size.x, m_size.y);

        for(Bullet each : m_bullets)
            each.render(camera);

        imageMode(CORNER);
    }

    void renderHealthPoints(float x, float y, boolean leaningLeft) {
        float health_bar_width = 40 * WIDTH_PERCENT;

        fill(0, 255, 0);
        rect(x - 2, y - 2, health_bar_width + 4, 54);

        fill(0);
        rect(x, y, health_bar_width, 50);

        {
            float health_width = health_bar_width / m_maxHealthPoint * m_displayHealth;
            float x_position = (leaningLeft)?x:x + health_bar_width - health_width;

            fill(255, 0, 0);
            rect(x_position, y, health_width, 50);
        }

        fill(0, 255, 0);
        textSize(32);
        text("Health: " + (int)(m_healthPoint), x + health_bar_width / 2.f, y + 25.f);
        textSize(48);

        fill(0);

    }

    PVector getPosition() {
        return m_position;
    }

    float getHealth() {
        return m_healthPoint;
    }

    void shootBullet(Player enemy) {
        musicPlayer.playBulletSound();

        PVector enemy_position = enemy.getPosition();

        PVector velocity = new PVector(enemy_position.x - m_position.x, enemy_position.y - m_position.y);
        velocity.normalize();
        velocity.rotate(random(-PI / 8.f, PI / 8.f));
        velocity.mult(300);

        Bullet new_bullet = new Bullet(m_bulletImage, m_position, velocity);
        m_bullets.add(new_bullet);
    }

    void applyForce(float x, float y) {
        m_velocity.x += x;
        m_velocity.y += y;
    }

    void walk(int xDirection, int yDirection, float deltaTime) {
        float walking_speed = m_characterData.speed * 10.f * deltaTime;
        applyForce(xDirection * walking_speed, yDirection * walking_speed);
    }


    //private
    void calculateCollision(float deltaTime, int map[], Tilemap tilemap) {
        PVector velocity = m_velocity.copy();
        velocity.mult(deltaTime);
        
        //out of bounds
        if(m_position.y + velocity.y < m_size.y / 2.f) {
            m_position.y = m_size.y / 2.f;
            m_velocity.y = 0;
            velocity.y = 0;
        } else if(m_position.y + velocity.y > 2500 - m_size.y / 2.f - 1) {
            m_position.y = 2500 - m_size.y / 2.f - 1;
            m_velocity.y = 0;
            velocity.y = 0;
        }

        if(m_position.x + velocity.x < m_size.x / 2.f) {
            m_position.x = m_size.x / 2.f;
            m_velocity.x = 0;
            velocity.x = 0;
        } else if(m_position.x + velocity.x > 2500 - m_size.x / 2.f - 1) {
            m_position.x = 2500 - m_size.x / 2.f - 1;
            m_velocity.x = 0;
            velocity.x = 0;
        }

        int top_position_index    = (int)((m_position.y - m_size.y / 2.f + 1) / 50);
        int bottom_position_index = (int)((m_position.y + m_size.y / 2.f - 1) / 50);
        int left_position_index   = (int)((m_position.x - m_size.x / 2.f + 1) / 50);
        int right_position_index  = (int)((m_position.x + m_size.x / 2.f - 1) / 50);

        //vertical collision
        {
            int next_top_position_index = (int)((m_position.y - m_size.y / 2.f + velocity.y) / 50);
            int next_bottom_position_index = (int)((m_position.y + m_size.y / 2.f + velocity.y) / 50);

            TileInfo bottom_left_tile = tilemap.getTileInfo(map[next_bottom_position_index * 50 + left_position_index]);
            TileInfo bottom_right_tile = tilemap.getTileInfo(map[next_bottom_position_index * 50 + right_position_index]);

            TileInfo top_left_tile = tilemap.getTileInfo(map[next_top_position_index * 50 + left_position_index]);
            TileInfo top_right_tile = tilemap.getTileInfo(map[next_top_position_index * 50 + right_position_index]);

            if(bottom_left_tile.isWall || bottom_right_tile.isWall) {
                if(m_velocity.y > 0) {
                    m_position.y = next_bottom_position_index * 50.f - m_size.y * 0.5;
                    m_velocity.y = 0;
                }
            }
            if(top_left_tile.isWall || top_right_tile.isWall) {
                if(m_velocity.y < 0) {
                    m_position.y = next_top_position_index * 50.f + m_size.y * 1.5;
                    m_velocity.y = 0;
                }
            }
        }

        //horizontal collision
        {
            int next_left_position_index = (int)((m_position.x - m_size.x / 2.f + velocity.x) / 50);
            int next_right_position_index = (int)((m_position.x + m_size.x / 2.f + velocity.x) / 50);

            TileInfo right_bottom_tile = tilemap.getTileInfo(map[bottom_position_index * 50 + next_right_position_index]);
            TileInfo right_top_tile = tilemap.getTileInfo(map[top_position_index * 50 + next_right_position_index]);

            TileInfo left_bottom_tile = tilemap.getTileInfo(map[bottom_position_index * 50 + next_left_position_index]);
            TileInfo left_top_tile = tilemap.getTileInfo(map[top_position_index * 50 + next_left_position_index]);

            if(right_bottom_tile.isWall || right_top_tile.isWall) {
                if(m_velocity.x > 0) {
                    m_position.x = next_right_position_index * 50.f - m_size.x * 0.5;
                    m_velocity.x = 0;
                }
            }
            if(left_bottom_tile.isWall || left_top_tile.isWall) {
                if(m_velocity.x < 0) {
                    m_position.x = next_left_position_index * 50.f + m_size.x * 1.5;
                    m_velocity.x = 0;
                }
            }
        }

        //slow down player based on the tile
        {
            int index_x = (int)(m_position.x / 50);
            int index_y = (int)(m_position.y / 50);
            TileInfo current_tile = tilemap.getTileInfo(map[index_y * 50 + index_x]);
            
            m_velocity.mult(current_tile.speed);
        }
    }

    void loadSpriteSheet(String path) {
        PImage load_image = loadImage(path + "/player.png");

        int walking_frame_count = m_characterData.getWalkingFrameCount();
        int shooting_frame_count = m_characterData.getShootingFrameCount();

        m_walkingAnimations = new ArrayList<PImage>();
        m_shootingAnimations = new ArrayList<PImage>();

        for(int i=0;i<walking_frame_count;i++) {
            m_walkingAnimations.add(load_image.get(i * 32, 0, 32, 32));
        }

        for(int i=0;i<shooting_frame_count;i++) {
            m_shootingAnimations.add(load_image.get(i * 32, 32, 32, 32));
        }
    }
}
