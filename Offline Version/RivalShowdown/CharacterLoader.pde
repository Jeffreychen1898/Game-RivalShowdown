class CharacterLoader {

    HashMap<String, CharacterData> characters;

    CharacterLoader(String path) {
        characters = new HashMap<String, CharacterData>();

        String character_list[] = loadStrings(path + "/info.txt");
        for(String each : character_list) {
            if(each.trim().length() == 0) continue;

            String character_path = path + "/" + each + "/info.txt";
            FileFormatOuput[] character_data = loadFileFormat(character_path);
            
            int colour = 0;
            float speed = 0;
            float attack = 0;
            float health = 0;
            PVector walking = new PVector();
            PVector shooting = new PVector();
            for(FileFormatOuput each_data : character_data) {
                switch(each_data.name) {
                    case "color":
                        colour = each_data.value;
                        break;
                    case "speed":
                        speed = each_data.value;
                        break;
                    case "health":
                        health = each_data.value;
                        break;
                    case "attack":
                        attack = each_data.value;
                        break;
                    case "walking-frame-count":
                        walking.x = each_data.value;
                        break;
                    case "walking-frame-rate":
                        walking.y = each_data.value;
                        break;
                    case "shooting-frame-count":
                        shooting.x = each_data.value;
                        break;
                    case "shooting-frame-rate":
                        shooting.y = each_data.value;
                        break;
                }
            }

            CharacterData new_character = new CharacterData(speed, health, attack, walking, shooting);
            new_character.setColor(colour);
            characters.put(each, new_character);
        }
    }
}

class CharacterData {
    float speed;
    float health;
    float attack;

    color colour; //british spelling because "color" is already taken

    PVector m_walkingAnimation;
    PVector m_shootingAnimation;
    CharacterData(float _speed, float _health, float _attack, PVector walking, PVector shooting) {
        speed = _speed;
        health = _health;
        attack = _attack;

        m_walkingAnimation = walking;
        m_shootingAnimation = shooting;
    }

    void setColor(int _colour) {
        int blue = _colour & 0x0000FF;
        int green = _colour & 0x00FF00;
        int red = _colour & 0xFF0000;

        green = green >> 8;
        red = red >> 16;

        colour = color(red, green, blue);
    }

    int getWalkingFrameCount() {
        return (int)m_walkingAnimation.x;
    }

    int getWalkingFrameRate() {
        return (int)m_walkingAnimation.y;
    }

    int getShootingFrameCount() {
        return (int)m_shootingAnimation.x;
    }

    int getShootingFrameRate() {
        return (int)m_shootingAnimation.y;
    }
}