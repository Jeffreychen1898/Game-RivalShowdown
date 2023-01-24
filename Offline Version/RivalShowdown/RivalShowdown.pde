import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import java.util.HashSet;

float WIDTH_PERCENT;
float HEIGHT_PERCENT;

GameStates gameStates;
KeyBindings keyBindings;
MusicPlayer musicPlayer;

void setup() {
    fullScreen(P2D);
    ((PGraphicsOpenGL)g).textureSampling(3);

    //number of pixels per percent of the computer resolution
    WIDTH_PERCENT = width / 100.f;
    HEIGHT_PERCENT = height / 100.f;

    keyBindings = new KeyBindings("res/gameData/keyBindings.txt");
    musicPlayer = new MusicPlayer(this);
    gameStates = new GameStates();

    //default modes
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(48);
    noStroke();
}
void draw() {
    background(0);

    gameStates.update();
}

void keyPressed() {
    println(keyCode);
    gameStates.keyPressed(keyCode);
}

void keyReleased() {
    gameStates.keyReleased(keyCode);
}
