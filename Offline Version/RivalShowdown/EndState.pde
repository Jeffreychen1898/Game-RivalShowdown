class EndState extends GameState {
    PImage m_backgroundImage;

    ArrayList<PImage> m_characterImages;
    CharacterLoader m_characterData;
    HashMap<String, Integer> m_playerIndex;

    int m_winningPlayer;
    String m_winningPlayerName;
    float m_displayPosition;

    EndState(CharacterLoader characterInfo) {
        super(characterInfo);

        m_characterData = characterInfo;

        m_backgroundImage = loadImage("res/backgrounds/endBackground.jpg");

        m_characterImages = new ArrayList<PImage>();
        m_playerIndex = new HashMap<String, Integer>();
        String characters[] = loadStrings("res/characters/info.txt");
        for(int i=0;i<characters.length;i++) {
            String path = "res/characters/" + characters[i] + "/display.png";
            PImage character_image = loadImage(path);
            m_characterImages.add(character_image);
            m_playerIndex.put(characters[i], i);
        }
    }

    void reset() {
        super.reset();

        m_winningPlayer = -1;
        m_displayPosition = -25 * HEIGHT_PERCENT;
    }

    void update(float deltaTime) {
        super.update(deltaTime);

        if(firstPlayerCharacter == "") {
            m_winningPlayer = 1;
            m_winningPlayerName = secondPlayerCharacter;
        } else {
            m_winningPlayer = 0;
            m_winningPlayerName = firstPlayerCharacter;
        }

        m_displayPosition = lerp(m_displayPosition, 25 * HEIGHT_PERCENT + 10 * WIDTH_PERCENT, 15 * deltaTime);
    }

    void render() {
        super.render();

        imageMode(CENTER);

        drawBackground();

        if(m_winningPlayer > -1) {
            int player_index = m_playerIndex.get(m_winningPlayerName);
            PImage player_display = m_characterImages.get(player_index);

            image(player_display, m_displayPosition, 50 * HEIGHT_PERCENT, 50 * HEIGHT_PERCENT, 50 * HEIGHT_PERCENT);

            fill(255);
            String winner_display_string = "Player " + (m_winningPlayer + 1) + " won with\n" + m_winningPlayerName;
            text(winner_display_string, 75 * WIDTH_PERCENT, 10 * HEIGHT_PERCENT);

            CharacterData character_data = m_characterData.characters.get(m_winningPlayerName);
            {
                String title_text = "Stats:";
                String health_text = "Health: " + (int)(character_data.health);
                String attack_text = "Attack: " + (int)(character_data.attack);
                String speed_text = "Speed " + (int)(character_data.speed);

                String display_text = title_text + "\n" + health_text + "\n" + attack_text + "\n" + speed_text;
                text(display_text, 75 * WIDTH_PERCENT, 50 * HEIGHT_PERCENT);
            }
            fill(0);
        }

        imageMode(CORNER);
    }

    void keyPressed(int keyCode) {
        if(keyCode == keyBindings.get("game-state-transition"))
            m_requestState = GAME_STATE.RESET;
    }

    //private
    void drawBackground() {
        float image_width = width;
        float image_height = height;
        if(width > height * 2)
            image_height = width / 2;
        else
            image_width = height * 2;

        image(m_backgroundImage, width / 2, height / 2, image_width, image_height);
    }
}