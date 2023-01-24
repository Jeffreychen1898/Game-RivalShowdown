class GameState {

    GAME_STATE m_requestState;

    GameState(CharacterLoader characterInfo) {}

    void render() {}
    void update(float deltaTime) {}

    void setRequestState() {
        m_requestState = GAME_STATE.NULL;

        onStateChanged();
    }
    GAME_STATE requestStateChange() {
        return m_requestState;
    }

    void keyPressed(int keyCode) {}
    void keyReleased(int keyCode) {}

    void reset() {}
    void onStateChanged() {}
}