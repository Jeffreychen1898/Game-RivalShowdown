import processing.net.*;

Terminal terminal;
PFont terminalFont;

Server server;
ServerHelper serverHelper;

ArrayList<ClientInfo> queue = new ArrayList<ClientInfo>();
HashMap<String, ClientInfo> activeClients = new HashMap<String, ClientInfo>();
void setup() {
  size(1024, 768);
  terminalFont = createFont("res/TerminalFont.ttf", 32);
  terminal = new Terminal();

  server = new Server(this, 2345);
  serverHelper = new ServerHelper();
  noStroke();
}
void draw() {
  background(255);
  terminal.render();
  
  ArrayList<HashMap<String, String>> datas = serverHelper.receive();
  if(datas != null) {
    for(HashMap<String, String> data : datas) {
      if(data.get("name").equals("confirm_selection")) {
        //store the client info in a queue
        ClientInfo new_client = new ClientInfo(data.get("id"), Integer.parseInt(data.get("character")));
        queue.add(new_client);
        println(Integer.parseInt(data.get("character")));
      } else if(data.get("name").equals("character_position") && activeClients.containsKey(data.get("id"))) {
        String partnerID = activeClients.get(data.get("id")).partnerID;
        serverHelper.send("update_character_position", partnerID, "positionX=" + data.get("positionX") + "&positionY=" + data.get("positionY"));
      } else if(data.get("name").equals("bullet") && activeClients.containsKey(data.get("id"))) {
        String partnerID = activeClients.get(data.get("id")).partnerID;
        String data_position = "&positionX=" + data.get("positionX") + "&positionY=" + data.get("positionY");
        String message = "angle=" + data.get("angle") + data_position + "&time=" + data.get("time") + "&velocity=" + data.get("velocity");
        serverHelper.send("send_bullets", partnerID, message);
      } else if(data.get("name").equals("health") && activeClients.containsKey(data.get("id"))) {
        String partnerID = activeClients.get(data.get("id")).partnerID;
        serverHelper.send("update_health", partnerID, "hp=" + data.get("hp"));
      } else if(data.get("name").equals("death") && activeClients.containsKey(data.get("id"))) {
        String partnerID = activeClients.get(data.get("id")).partnerID;
        serverHelper.send("victory", partnerID, "");
        activeClients.remove(partnerID);
        activeClients.remove(data.get("id"));
      } else if(data.get("name").equals("blast") && activeClients.containsKey(data.get("id"))) {
        String partnerID = activeClients.get(data.get("id")).partnerID;
        serverHelper.send("send_blast", partnerID, "");
      }
    }
  }
  
  //match
  if(queue.size() > 1) {
    int randomMap = int(random(0, 3));
    //match the 2 clients
    serverHelper.send("opponent", queue.get(0).clientID, "character=" + queue.get(1).clientCharacter + "&position=9900&map=" + randomMap);
    serverHelper.send("opponent", queue.get(1).clientID, "character=" + queue.get(0).clientCharacter + "&position=100&map=" + randomMap);
    
    queue.get(0).partnerID = queue.get(1).clientID;
    queue.get(1).partnerID = queue.get(0).clientID;
    //store the clients in active client table
    activeClients.put(queue.get(0).clientID, queue.get(0));
    activeClients.put(queue.get(1).clientID, queue.get(1));
    //remove them from queue
    queue.remove(0);
    queue.remove(0);
  }
}
void keyPressed() {
  terminal.keyPressed(key, keyCode);
}
