public enum GAME_STATE {
    TITLE,
    SELECTION,
    GAME,
    END,
    RESET,
    NULL
}

class GameStates {

    CharacterLoader m_gameCharacters;

    GameState m_gameStates[] = new GameState[4];
    int m_currentState;

    GameStates() {
        m_gameCharacters = new CharacterLoader("res/characters");

        m_gameStates[0] = new TitleState(m_gameCharacters);
        m_gameStates[1] = new SelectionState(m_gameCharacters);
        m_gameStates[2] = new GameplayState(m_gameCharacters);
        m_gameStates[3] = new EndState(m_gameCharacters);

        reset();
    }

    void update() {
        GameState current_state = m_gameStates[m_currentState];
        float delta_time = (frameRate > 0)?1.f/frameRate:0;

        current_state.render();
        current_state.update(delta_time);
        
        {
            GAME_STATE new_state = current_state.requestStateChange();
            if(new_state != GAME_STATE.NULL) {
                if(new_state == GAME_STATE.RESET) {
                    reset();
                } else {
                    m_currentState = new_state.ordinal();
                    m_gameStates[m_currentState].setRequestState();

                    musicPlayer.switchState(new_state);
                }
            }
        }

        musicPlayer.checkMusicEnded();
    }

    void keyPressed(int keyCode) {
        if(keyCode == keyBindings.get("restart")) {
            reset();
            return;
        }

        m_gameStates[m_currentState].keyPressed(keyCode);
    }

    void keyReleased(int keyCode) {
        m_gameStates[m_currentState].keyReleased(keyCode);
    }

    // private
    void reset() {
        for(GameState each : m_gameStates) {
            each.reset();
        }

        m_currentState = GAME_STATE.TITLE.ordinal();
        m_gameStates[m_currentState].setRequestState();

        musicPlayer.switchState(GAME_STATE.TITLE);
    }
}