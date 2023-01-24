FileFormatOuput[] loadFileFormat(String file) {
    String data[] = loadStrings(file);

    int valid_data_count = 0;
    for(String each : data) {
        if(each.length() > 0) {
            if(each.charAt(0) == '#')
                continue;
        }

        if(each.trim().length() > 0)
            valid_data_count ++;
    }

    FileFormatOuput result[] = new FileFormatOuput[valid_data_count];
    int index_counter = 0;
    for(String each : data) {
        if(each.length() > 0) {
            if(each.charAt(0) == '#')
                continue;
        }

        if(each.trim().length() == 0)
            continue;

        String name;
        int value;

        String[] split_string = each.split("=");
        if(split_string.length != 2) return null;

        name = split_string[0].trim();
        value = StringToInt(split_string[1]);

        result[index_counter] = new FileFormatOuput(name, value);

        index_counter ++;
    }

    return result;
}

class FileFormatOuput {
    String name;
    int value;

    FileFormatOuput(String _name, int _value) {
        name = _name;
        value = _value;
    }
}

//limitation: no check for number being greater than what int can hold
//error: return 0 when an error is encountered
int StringToInt(String number) {
    String trim_number = number.trim();

    boolean began = false;
    int parsed_number = 0;
    char sign = '+';

    for(int i=0;i<trim_number.length();i++) {
        char character = trim_number.charAt(i);
        int ascii = (int)character;

        if(ascii > 47 && ascii < 58)
            began = true;

        if(!began) {
            if(character == '+' || character == '-') {
                if(character == sign)
                    sign = '+';
                else
                    sign = '-';
                
                continue;
            }
            if(character != ' ') {
                return 0;
            }
        } else {
            if(ascii > 47 && ascii < 58)
                parsed_number = parsed_number * 10 + (ascii - 48);
            else
                return 0;
        }
    }

    if(sign == '-')
        return -parsed_number;
    
    return parsed_number;
}