class ServerHelper {
  ServerHelper() {
  }
  void send(String name, String id, String message) {
    String data = "name=" + name + "&" + "id=" + id + "&" + message + "\n";
    server.write(data);
  }
  ArrayList<HashMap<String, String>> receive() {
    Client c = server.available();
    if(c != null) {
      ArrayList<HashMap<String, String>> table_list = new ArrayList<HashMap<String, String>>();
      String data = c.readString();
      String datas[] = data.split("\n");
      for(String s : datas) {
        boolean skip = false;
        HashMap parsed_data = new HashMap<String, String>();
        String parameters[] = s.split("&");
        for(String each_parameter : parameters) {
          String[] key_value = each_parameter.split("=");
          if(key_value.length > 1) {
            println(key_value.length);
            parsed_data.put(key_value[0], key_value[1]);
          } else {
            skip = true;
            break;
          }
        }
        if(skip) {
          continue;
        }
        table_list.add(parsed_data);
      }
      return table_list;
    }
    return null;
  }
}
