String firstPlayerCharacter = "";
String secondPlayerCharacter = "";

class SelectionState extends GameState {
    PImage m_backgroundImage;

    SelectorUI m_firstCharacterSelection;
    SelectorUI m_secondCharacterSelection;

    CharacterLoader m_characterData;
    HashMap<Integer, String> m_characterIndex;

    SelectionState(CharacterLoader characterInfo) {
        super(characterInfo);

        m_characterData = characterInfo;

        m_backgroundImage = loadImage("res/backgrounds/selectionBackground.jpg");

        createSelectors();
    }

    void update(float deltaTime) {
        super.update(deltaTime);

        m_firstCharacterSelection.update(deltaTime);
        m_secondCharacterSelection.update(deltaTime);
    }

    void render() {
        super.render();

        imageMode(CENTER);
        drawBackground();
        textSize(48);
        {
            text("Player 1 Character", 50 * WIDTH_PERCENT, 5 * HEIGHT_PERCENT);
            PGraphics selector_image = m_firstCharacterSelection.render();
            image(selector_image, 50 * WIDTH_PERCENT, 15 * HEIGHT_PERCENT);
        }
        {
            text("Player 2 Character", 50 * WIDTH_PERCENT, 25 * HEIGHT_PERCENT);
            PGraphics selector_image = m_secondCharacterSelection.render();
            image(selector_image, 50 * WIDTH_PERCENT, 35 * HEIGHT_PERCENT);
        }

        {
            int character_index = m_firstCharacterSelection.getCurrentIndex();
            String name = m_characterIndex.get(character_index);
            firstPlayerCharacter = name;

            drawPlayerStats(25 * WIDTH_PERCENT, name);
        }
        {
            int character_index = m_secondCharacterSelection.getCurrentIndex();
            String name = m_characterIndex.get(character_index);
            secondPlayerCharacter = name;

            drawPlayerStats(75 * WIDTH_PERCENT, name);
        }
        imageMode(CORNER);
    }

    void keyPressed(int keyCode) {
        if(keyCode == keyBindings.get("left-player-left")) {
            m_firstCharacterSelection.previousItem();
        }
        if(keyCode == keyBindings.get("left-player-right")) {
            m_firstCharacterSelection.nextItem();
        }
        if(keyCode == keyBindings.get("right-player-left")) {
            m_secondCharacterSelection.previousItem();
        }
        if(keyCode == keyBindings.get("right-player-right")) {
            m_secondCharacterSelection.nextItem();
        }

        if(keyCode == keyBindings.get("game-state-transition")) {
            if(firstPlayerCharacter.length() > 0 && secondPlayerCharacter.length() > 0) {
                m_requestState = GAME_STATE.GAME;
            }
        }
    }

    //private
    void drawPlayerStats(float xPosition, String characterName) {
        CharacterData info = m_characterData.characters.get(characterName);

        rectMode(CENTER);
        fill(50);
        rect(xPosition, 75 * HEIGHT_PERCENT, 30 * WIDTH_PERCENT, 40 * HEIGHT_PERCENT);
        rectMode(CORNER);

        fill(info.colour);
        textSize(48);
        text(characterName, xPosition, 60 * HEIGHT_PERCENT);

        fill(200);
        textSize(32);
        text("Speed: " + (int)info.speed, xPosition, 60 * HEIGHT_PERCENT + 75);
        text("Health: " + (int)info.health, xPosition, 60 * HEIGHT_PERCENT + 125);
        text("Attack: " + (int)info.attack, xPosition, 60 * HEIGHT_PERCENT + 175);
        
        fill(0);
    }
    void createSelectors() {
        m_characterIndex = new HashMap<Integer, String>();
        String characters[] = loadStrings("res/characters/info.txt");
        PImage character_images[] = new PImage[characters.length];
        for(int i=0;i<characters.length;i++) {
            m_characterIndex.put(i, characters[i]);
            String character = characters[i];

            String path = "res/characters/" + character + "/display.png";
            PImage new_image = loadImage(path);

            character_images[i] = new_image;
        }

        m_firstCharacterSelection = new SelectorUI(width - 200, 10 * HEIGHT_PERCENT);
        m_firstCharacterSelection.setBackgroundColor(color(87, 87, 87));
        m_firstCharacterSelection.setItemSize(10 * HEIGHT_PERCENT - 5, 10 * HEIGHT_PERCENT - 5);
        m_firstCharacterSelection.setGap(20);

        for(PImage each : character_images)
            m_firstCharacterSelection.addItem(each);

        m_secondCharacterSelection = new SelectorUI(width - 200, 10.f * HEIGHT_PERCENT);
        m_secondCharacterSelection.setBackgroundColor(color(87, 87, 87));
        m_secondCharacterSelection.setItemSize(10 * HEIGHT_PERCENT - 5, 10 * HEIGHT_PERCENT - 5);
        m_secondCharacterSelection.setGap(20);

        for(PImage each : character_images)
            m_secondCharacterSelection.addItem(each);
    }

    void drawBackground() {
        float image_width = width;
        float image_height = height;
        if(width > height * 2)
            image_height = width / 2;
        else
            image_width = height * 2;

        image(m_backgroundImage, width / 2, height / 2, image_width, image_height);
    }

    void reset() {
        super.reset();

        m_firstCharacterSelection.reset();
        m_secondCharacterSelection.reset();
    }
}