class MusicPlayer {

    GAME_STATE m_currentState;

    AudioPlayer m_musicsForEachState[] = new AudioPlayer[4];

    AudioPlayer m_bulletSound;

    MusicPlayer(PApplet applet) {
        m_currentState = GAME_STATE.NULL;

        Minim minim = new Minim(applet);

        AudioPlayer music_headedForAShowdown = minim.loadFile("res/music/HeadedForAShowdown.wav");
        AudioPlayer music_gunsBlazing = minim.loadFile("res/music/Guns Blazing.wav");
        AudioPlayer music_BeautifulRivalry = minim.loadFile("res/music/Beautiful Rivalry.wav");

        m_musicsForEachState[0] = music_headedForAShowdown;
        m_musicsForEachState[1] = music_headedForAShowdown;
        m_musicsForEachState[2] = music_gunsBlazing;
        m_musicsForEachState[3] = music_BeautifulRivalry;

        m_bulletSound = minim.loadFile("res/music/Gunshot.wav");
    }

    void checkMusicEnded() {
        int index = m_currentState.ordinal();
        AudioPlayer current_music = m_musicsForEachState[index];
        if(!current_music.isPlaying()) {
            current_music.rewind();
            current_music.play();
        }
    }

    void switchState(GAME_STATE newState) {
        int index = newState.ordinal();

        if(m_currentState != GAME_STATE.NULL) {
            int current_index = m_currentState.ordinal();

            if(m_musicsForEachState[current_index] == m_musicsForEachState[index])
                return;

            m_musicsForEachState[current_index].pause();
            m_musicsForEachState[current_index].rewind();
        }

        m_musicsForEachState[index].play();

        m_currentState = newState;
    }

    void playBulletSound() {
        m_bulletSound.rewind();
        m_bulletSound.play();
    }
}