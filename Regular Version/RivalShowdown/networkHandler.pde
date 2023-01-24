void Networking_send(String name, String message) {
  String data = "name=" + name + "&id=" + id + "&" + message + "\n";
  client.write(data);
}
ArrayList<HashMap<String, String>> Networking_recieve() {
  if(client.available() > 0) {
    ArrayList<HashMap<String, String>> return_result = new ArrayList<HashMap<String, String>>();
    String get_string = client.readString();
    String datas[] = get_string.split("\n");
    //for each message recieved
    for(String data : datas) {
      boolean skip = false;
      HashMap parsed_data = new HashMap<String, String>();
      String parameters[] = data.split("&");
      //for each parameter
      for(String parameter : parameters) {
        String[] key_value = parameter.split("=");
        if(key_value.length > 1) {
          if(key_value[0].equals("id") && !key_value[1].equals(id)) {
            skip = true;
            break;
          }
          parsed_data.put(key_value[0], key_value[1]);
        } else {
          skip = true;
          break;
        }
      }
      if(skip) {
        continue;
      }
      //add the hashmap to the array of hashmaps
      return_result.add(parsed_data);
    }
    return return_result;
  }
  return null;
}
