class Bullet {
  PVector initalPosition, position;
  float bspeed, bdamage, ang;
  PImage img;
  long start_time;
  //int bulletCount;
  // load image in external variable and place into constructior
  Bullet(float x, float y, float bspeed, float bdamage, float ang, PImage image) {
    initalPosition = new PVector(x, y);
    position = new PVector(x, y);
    this.ang = ang;
    this.bspeed = bspeed;
    this.bdamage = bdamage;
    img = image;
    img.resize(45, 45);
  }


  void display(Camera cam) {
    imageMode(CENTER);
    cam.drawImageRotated(img, position.x, position.y, 45, 45, ang);
  }

  //void bulletFired() {
  //  bulletCount+= -1;
  //}

//SERIALIZATION STUFF
  Bullet (JSONObject bulletJSON) {
    JSONObject initalPosition_obj = bulletJSON.getJSONObject("initalPosition");
    JSONObject position_obj = bulletJSON.getJSONObject("position");
    initalPosition.x = position_obj.getFloat("x");
    initalPosition.y = position_obj.getFloat("y");
    position.x = position_obj.getFloat("x");
    position.y = position_obj.getFloat("y");
    bspeed = bulletJSON.getFloat("bspeed");
    bdamage = bulletJSON.getFloat("bspeed");
    ang = bulletJSON.getFloat("bspeed");
  }

  JSONObject serialize() {
    JSONObject bulletJSON = new JSONObject();
    JSONObject initalPosition_obj = new JSONObject ();
    JSONObject position_obj = new JSONObject();
    JSONObject result = new JSONObject();
    initalPosition_obj.setFloat("x", initalPosition.x);
    initalPosition_obj.setFloat("y", initalPosition.y);
    position_obj.setFloat("x", position.x);
    bulletJSON.setFloat("bspeed", bspeed);
    bulletJSON.setFloat("bdamage", bdamage);
    bulletJSON.setFloat("ang", ang);
    position_obj.setFloat("y", position.y);
    result.setJSONObject("initialPosition", initalPosition_obj);
    result.setJSONObject("position", position_obj);
    return result;
  }
}
