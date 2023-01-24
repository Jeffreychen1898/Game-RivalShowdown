class GameplayState extends GameState {

    Camera m_camera;
    float m_aspectRatio;

    Tilemap m_tilemapHandler;
    int m_tilemap[] = new int[2500];

    CharacterLoader m_characterInfo;

    Player m_firstPlayer;
    Player m_secondPlayer;

    // a better implementation would be to use an array of booleans
    // however, I do not know the range of the key codes (ie. ASCII
    // displayable characters go from 32[" "] to 126["~"]), therefore
    // I cannot determine the size of the boolean array
    HashSet<Integer> m_keysHeld;

    GameplayState(CharacterLoader characterInfo) {
        super(characterInfo);

        m_characterInfo = characterInfo;

        loadTilemap("res/map/map.txt");
        m_tilemapHandler = new Tilemap("res/map");

        m_aspectRatio = (float)width / (float)height;
    }

    void reset() {
        super.reset();

        m_keysHeld = new HashSet<Integer>();

        m_camera = new Camera();
        m_camera.size = new PVector(100 * m_aspectRatio, 100);
        m_camera.setDisplaySize();
    }

    void onStateChanged() {
        super.onStateChanged();

        {
            PVector player_position = new PVector(100, 100);
            CharacterData character_data = m_characterInfo.characters.get(firstPlayerCharacter);
            String spritesheet_path = "res/characters/" + firstPlayerCharacter;
            m_firstPlayer = new Player(character_data, spritesheet_path, player_position);
        }
        {
            PVector player_position = new PVector(2400, 2400);
            CharacterData character_data = m_characterInfo.characters.get(secondPlayerCharacter);
            String spritesheet_path = "res/characters/" + secondPlayerCharacter;
            m_secondPlayer = new Player(character_data, spritesheet_path, player_position);
        }
    }

    void render() {
        super.render();

        m_tilemapHandler.renderTileMap(m_camera, m_tilemap);

        if(m_firstPlayer != null) {
            m_firstPlayer.render(m_camera);
            m_firstPlayer.renderHealthPoints(5 * WIDTH_PERCENT, 50, true);
        }
        if(m_secondPlayer != null) {
            m_secondPlayer.render(m_camera);
            m_secondPlayer.renderHealthPoints(55 * WIDTH_PERCENT, 50, false);
        }
    }

    void update(float deltaTime) {
        super.update(deltaTime);

        m_tilemapHandler.update(deltaTime);

        if(m_firstPlayer != null) {
            m_firstPlayer.update(deltaTime, m_tilemap, m_tilemapHandler);
            m_firstPlayer.checkBulletCollision(m_secondPlayer);

            if(m_firstPlayer.getHealth() < 1) {
                firstPlayerCharacter = "";
                m_requestState = GAME_STATE.END;
            }
        }
        if(m_secondPlayer != null) {
            m_secondPlayer.update(deltaTime, m_tilemap, m_tilemapHandler);
            m_secondPlayer.checkBulletCollision(m_firstPlayer);

            if(m_secondPlayer.getHealth() < 1) {
                secondPlayerCharacter = "";
                m_requestState = GAME_STATE.END;
            }
        }

        keyPressActions(deltaTime);

        {
            m_camera.update(deltaTime);

            PVector first_player_position = m_firstPlayer.getPosition();
            PVector second_player_position = m_secondPlayer.getPosition();

            m_camera.position.x = (first_player_position.x + second_player_position.x) / 2.f;
            m_camera.position.y = (first_player_position.y + second_player_position.y) / 2.f;

            m_camera.size.x = Math.abs(second_player_position.x - first_player_position.x) + (150 * m_aspectRatio);
            m_camera.size.y = Math.abs(second_player_position.y - first_player_position.y) + 150;
            if(m_camera.size.x > m_camera.size.y * m_aspectRatio)
                m_camera.size.y = m_camera.size.x / m_aspectRatio;
            else
                m_camera.size.x = m_camera.size.y * m_aspectRatio;
        }
    }

    void keyPressed(int keyCode) {
        super.keyPressed(keyCode);

        if(!m_keysHeld.contains(keyCode))
            m_keysHeld.add(keyCode);

        if(keyCode == keyBindings.get("left-player-shoot"))
            m_firstPlayer.shootBullet(m_secondPlayer);

        if(keyCode == keyBindings.get("right-player-shoot")) {
            m_secondPlayer.shootBullet(m_firstPlayer);
        }
    }

    void keyReleased(int keyCode) {
        super.keyReleased(keyCode);
        
        if(m_keysHeld.contains(keyCode))
            m_keysHeld.remove(keyCode);
    }

    //private
    void keyPressActions(float deltaTime) {
        if(m_keysHeld.contains(keyBindings.get("left-player-up"))) {
            if(m_firstPlayer != null)
                m_firstPlayer.walk(0, -1, deltaTime);
        }
        if(m_keysHeld.contains(keyBindings.get("left-player-down"))) {
            if(m_firstPlayer != null)
                m_firstPlayer.walk(0, 1, deltaTime);
        }
        if(m_keysHeld.contains(keyBindings.get("left-player-left"))) {
            if(m_firstPlayer != null)
                m_firstPlayer.walk(-1, 0, deltaTime);
        }
        if(m_keysHeld.contains(keyBindings.get("left-player-right"))) {
            if(m_firstPlayer != null)
                m_firstPlayer.walk(1, 0, deltaTime);
        }

        if(m_keysHeld.contains(keyBindings.get("right-player-up"))) {
            if(m_secondPlayer != null)
                m_secondPlayer.walk(0, -1, deltaTime);
        }
        if(m_keysHeld.contains(keyBindings.get("right-player-down"))) {
            if(m_secondPlayer != null)
                m_secondPlayer.walk(0, 1, deltaTime);
        }
        if(m_keysHeld.contains(keyBindings.get("right-player-left"))) {
            if(m_secondPlayer != null)
                m_secondPlayer.walk(-1, 0, deltaTime);
        }
        if(m_keysHeld.contains(keyBindings.get("right-player-right"))) {
            if(m_secondPlayer != null)
                m_secondPlayer.walk(1, 0, deltaTime);
        }
    }

    void loadTilemap(String path) {
        String file[] = loadStrings(path);
        for(int i=0;i<50;i++) {
            String tiles[] = file[i].split(" ");
            for(int j=0;j<50;j++) {
                int number = StringToInt(tiles[j]);
                m_tilemap[i * 50 + j] = number;
            }
        }
    }
}