import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import java.time.*;
import java.util.UUID;
import processing.net.*;

/*
 * Game States
 *
 * 0 - Menu
 * 1 - Selection
 * 2 - Game
 * 3 - End
 * 4 - Player Stats
 * 5 - Network Connection change
 */
boolean win = false;

long ARTIFICIAL_LAG = 200;
States states[] = new States[6];
int gameState = 0;
ArrayList<PlayerData> character;
ArrayList<MapData> maps;
int selectedPlayerIndex;
PImage title,returnPrompt,titleBackground,selectPrompt;
Minim minim;
AudioPlayer GunsBlazing;
AudioPlayer FallenRival;
AudioPlayer Beautiful_Rivalry;
AudioPlayer Showdown;
AudioPlayer GunShot;

Client client;
String IP = "127.0.0.1";//public ipv4 address
int PORT = 2345;//port 
String id;

void setup() {
  //fullScreen(P2D);
  size(1024, 768);
  id = UUID.randomUUID().toString();
  
  returnPrompt = loadImage("res/backgrounds/return.png");
  returnPrompt.resize(1200,60);
  selectPrompt= loadImage("res/backgrounds/selectPrompt.png");
  titleBackground= loadImage("res/backgrounds/titleBackground.jpg");
   title = loadImage("res/backgrounds/title.png");
  minim = new Minim(this);
  Beautiful_Rivalry = minim.loadFile("Beautiful Rivalry.wav");
  Showdown = minim.loadFile("HeadedForAShowdown.wav");
  GunsBlazing = minim.loadFile("Guns Blazing.wav");
  FallenRival = minim.loadFile("Fallen Rival.wav");
  GunShot = minim.loadFile("Gunshot.wav");
  //((PGraphicsOpenGL)g).textureSampling(3);
  loadPlayers();
  loadMaps();
  setupGame();
}
void setupGame() {
  win = false;
  gameState = 0;
  states[0] = new MenuState();
  states[1] = new SelectionState();
  states[2] = new GameState();
  states[3] = new EndState();
  states[4] = new PlayerStats();
  states[5] = new NetworkingSetupState();
  
}
void loadMaps() {
  maps = new ArrayList<MapData>();
  String[] map_list = loadStrings("res/map/info.txt");
  for(String each_map : map_list) {
    MapData new_map = new MapData("res/map/" + each_map);
    maps.add(new_map);
  }
}
void loadPlayers() {
  character = new ArrayList<PlayerData>();
  String[] character_list = loadStrings("res/characters/info.txt");
  for (String each_char : character_list) {
    PlayerData new_player = new PlayerData("res/characters/" + each_char);
    character.add(new_player);
  }
}
void draw() {
  // println(gameState);
  rectMode(CORNER);
  imageMode(CORNER);
  textAlign(LEFT, TOP);
  float delta_time = 1.f / frameRate;
  states[gameState].update(delta_time);

  noStroke();
  background(0);
  states[gameState].render();
}
void connectClient() {
  client = new Client(this, IP, PORT);
}
void mousePressed() {
  states[gameState].mousePressed(mouseButton);
}
void mouseReleased() {
  states[gameState].mouseReleased(mouseButton);
}
void keyPressed() {
  states[gameState].keyPressed(key);
}
void keyReleased() {
  states[gameState].keyReleased(key);
}
void mouseWheel(MouseEvent evt) {
  states[gameState].mouseWheel(evt.getCount());
}

long getTime() {
  //return new Date().getTime();
  return Instant.now().toEpochMilli();
}
