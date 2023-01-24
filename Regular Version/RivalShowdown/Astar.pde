class Astar {
  PVector goal;
  PVector start;
  PVector leftEdgeTile, rightEdgeTile;
  ArrayList<ArrayList<Integer>> gamemap;
  ArrayList<TileInformation> tileInformation;
  Node path;
  Astar(JSONObject object) {
    PVector start_pos = jsonToPVector(object.getJSONObject("start"));
    PVector stop_pos = jsonToPVector(object.getJSONObject("goal"));
    PVector start_tile = jsonToPVector(object.getJSONObject("leftEdgeTile"));
    PVector end_tile = jsonToPVector(object.getJSONObject("rightEdgeTile"));
    
    ArrayList<ArrayList<Integer>> map = new ArrayList<ArrayList<Integer>>();
    JSONArray jsonmap = object.getJSONArray("map");
    for(int i=0;i<jsonmap.size();i++) {
      JSONArray each_row = jsonmap.getJSONArray(i);
      ArrayList<Integer> map_each_row = new ArrayList<Integer>();
      for(int j=0;j<each_row.size();i++) {
        map_each_row.add(each_row.getInt(j));
      }
      map.add(map_each_row);
    }
    
    ArrayList<TileInformation> tileinfo = new ArrayList<TileInformation>();
    JSONArray json_tileinfo = object.getJSONArray("tileinfo");
    for(int i=0;i<json_tileinfo.size();i++) {
      JSONObject eachItem = json_tileinfo.getJSONObject(i);
      TileInformation eachtileinfo = new TileInformation(eachItem.getInt("famecount"), eachItem.getInt("framerate"));
      eachtileinfo.damage = eachItem.getInt("damage");
      eachtileinfo.speed = eachItem.getFloat("speed");
      eachtileinfo.wall = eachItem.getBoolean("wall");
      tileinfo.add(eachtileinfo);
    }
    
    startAlgorithm(start_pos, stop_pos, map, tileinfo, start_tile, end_tile);
  }
  Astar(PVector startPosition, PVector stopPosition, ArrayList<ArrayList<Integer>> map, ArrayList<TileInformation> tileinfo, PVector startTile, PVector endTile) {
    startAlgorithm(startPosition, stopPosition, map, tileinfo, startTile, endTile);
  }
  void startAlgorithm(PVector startPosition, PVector stopPosition, ArrayList<ArrayList<Integer>> map, ArrayList<TileInformation> tileinfo, PVector startTile, PVector endTile) {
    start = startPosition.copy();
    goal = stopPosition;
    gamemap = map;
    tileInformation = tileinfo;
    leftEdgeTile = startTile;
    rightEdgeTile = endTile;
    capVectorComponents(leftEdgeTile, 0, 0, map.get(0).size(), map.size());
    capVectorComponents(rightEdgeTile, 0, 0, map.get(0).size(), map.size());

    ArrayList<Node> open_list = new ArrayList<Node>();
    HashMap<String, Node> closed_set = new HashMap<String, Node>();
    HashMap<String, Node> open_set = new HashMap<String, Node>();
    //create the start node
    float heuristic = getHeuristic(startPosition);
    Node starting_node = new Node(startPosition.copy(), 0, heuristic, null);
    open_list.add(starting_node);
    open_set.put(startPosition.x + ":" + startPosition.y, starting_node);

    //Node result = null;
    Node result = runAlgorithm(open_list, closed_set, open_set);
    //reverse linked list
    Node previous = null;
    Node current = result;
    while(current != null) {
      Node next = current.parent;
      current.parent = previous;
      previous = current;
      current = next;
    }
    path = previous;
  }
  PVector jsonToPVector(JSONObject object) {
    PVector vector = new PVector(object.getFloat("x"), object.getFloat("y"));
    return vector;
  }
  JSONObject serialize() {
    //serialize the pvectors
    JSONObject s_goal = serializeVector(goal);
    JSONObject s_leftEdgeTile = serializeVector(leftEdgeTile);
    JSONObject s_rightEdgeTile = serializeVector(rightEdgeTile);
    JSONObject s_start = serializeVector(start);
    //serialize the gamemap
    JSONArray s_jsonArr = new JSONArray();
    for(int i=0;i<gamemap.size();i++) {
      JSONArray s_rowArr = new JSONArray();
      for(int j=0;j<gamemap.get(i).size();j++) {
        s_rowArr.setInt(j, gamemap.get(i).get(j));
      }
      s_jsonArr.setJSONArray(i, s_rowArr);
    }
    //serialize the tile information
    JSONArray s_tileInformation = new JSONArray();
    for(int i=0;i<tileInformation.size();i++) {
      JSONObject tileInfoObj = new JSONObject();
      tileInfoObj.setInt("framecount", tileInformation.get(i).framecount);
      tileInfoObj.setInt("framerate", tileInformation.get(i).framerate);
      tileInfoObj.setInt("damage", tileInformation.get(i).damage);
      tileInfoObj.setFloat("speed", tileInformation.get(i).speed);
      tileInfoObj.setBoolean("wall", tileInformation.get(i).wall);
      s_tileInformation.setJSONObject(i, tileInfoObj);
    }
    
    JSONObject result = new JSONObject();
    result.setJSONObject("goal", s_goal);
    result.setJSONObject("leftEdgeTile", s_leftEdgeTile);
    result.setJSONObject("rightEdgeTile", s_rightEdgeTile);
    result.setJSONObject("start", s_start);
    result.setJSONArray("map", s_jsonArr);
    result.setJSONArray("tileinfo", s_tileInformation);
    return result;
  }
  JSONObject serializeVector(PVector vector) {
    JSONObject jsonObj = new JSONObject();
    jsonObj.setFloat("x", vector.x);
    jsonObj.setFloat("y", vector.y);
    return jsonObj;
  }
  Node runAlgorithm(ArrayList<Node> open_list, HashMap<String, Node> closed_set, HashMap<String, Node> open_set) {
    if(open_list.isEmpty()) {
      return null;
    }
    //find the smallest node in open list
    Node chosen_node = null;
    int chosen_index = -1;
    for(int i=0;i<open_list.size();i++) {
      if(chosen_node == null) {
        chosen_node = open_list.get(i);
        chosen_index = i;
        continue;
      }
      if(chosen_node.gcost > open_list.get(i).gcost) {
        chosen_node = open_list.get(i);
        chosen_index = i;
      }
    }
    //store chosen node in the closed list
    open_list.remove(chosen_index);
    open_set.remove(chosen_node.location.x + ":" + chosen_node.location.y);
    closed_set.put(chosen_node.location.x + ":" + chosen_node.location.y, chosen_node);
    
    //get neighbors
    PVector[] neighbors = getNeighbors(chosen_node.location);
    
    //check if equal goal
    for(PVector neighbor : neighbors) {
      if(neighbor != null) {
        if(neighbor.x == goal.x && neighbor.y == goal.y) {
          Node goalNode = new Node(goal.copy(), chosen_node.gcost + 1, 0, chosen_node);
          return goalNode;
        }
      }
    }
    
    //process the neighbors
    for(PVector neighbor : neighbors) {
      if(neighbor != null) {
        //create the node
        float new_node_gcost = chosen_node.gcost + 1;
        float new_node_hcost = getHeuristic(neighbor);
        Node new_node = new Node(neighbor, new_node_gcost, new_node_hcost, chosen_node);
        //check if node is already visited
        if(!isVisited(new_node, open_set) && !isVisited(new_node, closed_set)) {
          //add to open list
          open_set.put(neighbor.x + ":" + neighbor.y, new_node);
          open_list.add(new_node);
        }
      }
    }
    
    Node result = runAlgorithm(open_list, closed_set, open_set);
    return result;
  }
  boolean isVisited(Node node, HashMap<String, Node> set) {
    String get_key = node.location.x + ":" + node.location.y;
    if(set.containsKey(get_key)) {
      Node existing_node = set.get(get_key);
      if(existing_node.gcost > node.gcost) {
        existing_node.gcost = node.gcost;
        existing_node.parent = node.parent;
      }
      return true;
    }
    return false;
  }
  PVector[] getNeighbors(PVector current) {
    PVector neighbors[] = new PVector[4];
    neighbors[0] = new PVector( 0, -1);
    neighbors[1] = new PVector(-1,  0);
    neighbors[2] = new PVector( 1,  0);
    neighbors[3] = new PVector( 0,  1);
    
    for(int i=0;i<neighbors.length;i++) {
      neighbors[i].x += current.x;
      neighbors[i].y += current.y;
      if(neighbors[i].x >= rightEdgeTile.x || neighbors[i].x < leftEdgeTile.x || neighbors[i].y >= rightEdgeTile.y || neighbors[i].y < leftEdgeTile.y) {
        neighbors[i] = null;
      }
    }
    //check if on wall block
    for(int i=0;i<neighbors.length;i++) {
      if(neighbors[i] != null) {
        //get tile information
        TileInformation tile = tileInformation.get(gamemap.get(int(neighbors[i].y)).get(int(neighbors[i].x)));
        if(tile.wall) {
          neighbors[i] = null;
        }
      }
    }
    return neighbors;
  }
  int getHeuristic(PVector currentPosition) {
    int delta_x = (int)abs(currentPosition.x - goal.x);
    int delta_y = (int)abs(currentPosition.y - goal.y);
    return delta_x + delta_y;
  }
  void capVectorComponents(PVector vector, float lowerX, float lowerY, float higherX, float higherY) {
    if(vector.x < lowerX) {
      vector.x = lowerX;
    }
    if(vector.x > higherX) {
      vector.x = higherX;
    }
    if(vector.y < lowerY) {
      vector.y = lowerY;
    }
    if(vector.y > higherY) {
      vector.y = higherY;
    }
  }
}

class Node {
  PVector location;
  float gcost;
  float hcost;
  Node parent;
  Node(PVector loc, float Gcost, float Hcost, Node par) {
    location = loc;
    gcost = Gcost;
    hcost = Hcost;
    parent = par;
  }
}
