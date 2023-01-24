class Camera {
  PVector position;
  PVector size;
  Camera(PVector pos, PVector camsize) {
    position = pos;
    size = camsize;
  }

  Camera (JSONObject Obj) {
    JSONObject position_obj = Obj.getJSONObject("position");
    JSONObject size_obj = Obj.getJSONObject("size");
    position.x = position_obj.getFloat("x");
    position.y = position_obj.getFloat("y");
    size.x = size_obj.getFloat("x");
    size.y = size_obj.getFloat("y");
  }

  void drawImage(PImage img, float x, float y, float w, float h) {
    PVector new_position = calculatePosition(x, y);
    PVector new_size = calculateSize(w, h);
    image(img, new_position.x, new_position.y, new_size.x, new_size.y);
  }
  void drawImageRotated(PImage img, float x, float y, float w, float h, float angle) {
    PVector new_position = calculatePosition(x, y);
    PVector new_size = calculateSize(w, h);
    pushMatrix();
    translate(new_position.x, new_position.y);
    rotate(angle);
    image(img, 0, 0, new_size.x, new_size.y);
    popMatrix();
  }
  void drawRect(float x, float y, float w, float h) {
    PVector new_position = calculatePosition(x, y);
    PVector new_size = calculateSize(w, h);
    rect(new_position.x, new_position.y, new_size.x, new_size.y);
  }
  void drawEllipse(float x, float y, float w, float h) {
    PVector new_position = calculatePosition(x, y);
    PVector new_size = calculateSize(w, h);
    ellipse(new_position.x, new_position.y, new_size.x, new_size.y);
  }
  void drawLine(float x1, float y1, float x2, float y2) {
    PVector position_one = calculatePosition(x1, y1);
    PVector position_two = calculatePosition(x2, y2);
    line(position_one.x, position_one.y, position_two.x, position_two.y);
  }
  PVector pointToWorldSpace(float x, float y) {
    PVector camera_position_relative = new PVector(position.x / size.x, position.y / size.y);
    PVector result = new PVector(x, y);
    result.x /= width;
    result.y /= height;
    result.sub(0.5, 0.5);
    result.add(camera_position_relative);
    result.x *= size.x;
    result.y *= size.y;

    return result;
  }

  PVector calculatePosition(float x, float y) {
    //make camera position relative to camera size
    PVector camera_position_relative = new PVector(position.x / size.x, position.y / size.y);
    //make this position relative to the camera size
    PVector new_position = new PVector(x / size.x, y / size.y);
    //this position minus camera position
    new_position.sub(camera_position_relative);
    //add 0.5 to center the camera
    new_position.add(0.5, 0.5);
    //position times screen size
    new_position.x *= width;
    new_position.y *= height;

    return new_position;
  }
  PVector calculateSize(float w, float h) {
    //divide the size to make it relative to camera size
    PVector new_size = new PVector(w / size.x, h / size.y);
    //multiply the value by the screen width and height
    new_size.x *= width;
    new_size.y *= height;

    return new_size;
  }

  JSONObject serialize() {
    JSONObject position_obj = new JSONObject ();
    JSONObject size_obj = new JSONObject();
    JSONObject result = new JSONObject();
    position_obj.setFloat("x", position.x);
    position_obj.setFloat("y", position.y);
    size_obj.setFloat("x", size.x);
    size_obj.setFloat("y", size.y);
    result.setJSONObject("position", position_obj);
    result.setJSONObject("size", size_obj);
    return result;
  }
}
