class Timer {
  // value of these gets overwritten so ignore these, these were originally for testing purposes
  String time = "10";
  int t;
  int interval = 10;
  boolean done;
  color Color;

  Timer(int interval) {
    this.interval = interval;
    time = str(interval);
    done = false;
    Color = color(255);
  }
   Timer() {
    time = str(0);
    done = false;
    Color = color(255);
  }
  //starts the timer
  void countDown() {
    t = interval-int(millis()/1000);
  }
  void countUp(){
    t = int(millis()/1000);
  }
  //Shows the timer in text
  void display(float x, float y, int size) {
    fill(Color);
    textSize(size);
    textAlign(CENTER);
    if (t > 0) {
      time = nf(t, 2);
    }
    text(time, x, y);
    if ( t<= 0) {
      time= nf(0, 1);
    }
  }
  // A boolean that turns true when the time reaches 0
  boolean alarm() {
    if ( t <= 0) {
      done = true;
      return(true);
    } else {
      return(false);
    }
  }
  // Changes color of the timerDisplay, This is optional to use. The displays color will default to white if you dont use this
  // Notice: THIS ONLY ACCEPTS RGB, COLOR HEX WILL NOT WORK AND WILL CAUSE A ERROR
  void displayColor(int r, int g, int b) {
 Color = color(r,g,b);
  }

  
  // JSON 
  Timer(JSONObject timeJSON ) {
    time = timeJSON.getString("time");
    t = timeJSON.getInt("t");
    interval = timeJSON.getInt("interval");
    done = timeJSON.getBoolean("done");
  }
  JSONObject serialize() {
    JSONObject timeJSON = new JSONObject();
    timeJSON.setString("time", time);
    timeJSON.setInt("time left", t);
    timeJSON.setInt("set for", interval);
    timeJSON.setBoolean("Timer Finshed", done);

    return timeJSON;
  }
}
