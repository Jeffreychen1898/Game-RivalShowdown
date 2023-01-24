class ScrollBar {
  PGraphics scrollbar;
  PVector position;
  PVector size;
  float scrollPos;
  int selectedIndex;
  ScrollBar(int x, int y, int w, int h) {
    position = new PVector(x, y);
    size = new PVector(w, h);
    scrollPos = -w / 2;
    scrollbar = createGraphics(w, h);
    selectedIndex = 0;
  }
  void render() {
    scrollPos = lerp(scrollPos, selectedIndex * 100 - size.x / 2, 0.3);
    scrollbar.beginDraw();
    scrollbar.background(0);
    scrollbar.rectMode(CENTER);
    scrollbar.imageMode(CENTER);
    for(int i=0;i<character.size();i++) {
      scrollbar.fill(255, 0, 255);
      if(selectedIndex == i) {
        scrollbar.fill(255, 255, 0);
        scrollbar.rect(100 * i - scrollPos, 50, 90, 90);
      }
      scrollbar.image(character.get(i).displayImage, 100 * i - scrollPos, 50, 80, 80);
    }
    scrollbar.endDraw();
    image(scrollbar, position.x - size.x / 2, position.y - size.y / 2, size.x, size.y);
    //left
    fill(0);
    if(buttonHover(position.x - size.x / 2 - 30, position.y - size.y / 2)) {
      fill(255);
    }
    triangle(position.x - 30 - size.x / 2, position.y, position.x - 10 - size.x / 2, position.y - size.y / 2, position.x - 10 - size.x / 2, position.y + size.y / 2);
    //right
    fill(0);
    if(buttonHover(position.x + size.x / 2 + 10, position.y - size.y / 2)) {
      fill(255);
    }
    triangle(position.x + 30 + size.x / 2, position.y, position.x + 10 + size.x / 2, position.y - size.y / 2, position.x + 10 + size.x / 2, position.y + size.y / 2);
  }
  boolean buttonHover(float x, float y) {
    if(mouseX > x && mouseX < x + 20 && mouseY > y && mouseY < y + size.y) {
      return true;
    }
    return false;
  }
  void mousePressed() {
    if(buttonHover(position.x - size.x / 2 - 30, position.y - size.y / 2)) {
      selectedIndex --;
    }
    if(buttonHover(position.x + size.x / 2 + 10, position.y - size.y / 2)) {
      selectedIndex ++;
    }
    selectedIndex = max(0, selectedIndex);
    selectedIndex = min(selectedIndex, character.size() - 1);
    selectedPlayerIndex = selectedIndex;
  }
}
