class TitleState extends GameState {
    PImage m_backgroundImage;
    PImage m_titleImage;

    TitleState(CharacterLoader characterInfo) {
        super(characterInfo);

        m_backgroundImage = loadImage("res/backgrounds/titleBackground.jpg");
        m_titleImage = loadImage("res/texts/RivalShowdown.png");
    }

    void render() {
        super.render();

        imageMode(CENTER);
        drawBackground();
        drawTitle();
        imageMode(CORNER);
    }

    void keyPressed(int keyCode) {
        if(keyCode == keyBindings.get("game-state-transition"))
            m_requestState = GAME_STATE.SELECTION;
    }

    //private
    void drawTitle() {
        image(m_titleImage, 50 * WIDTH_PERCENT, 50 * HEIGHT_PERCENT);
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
}