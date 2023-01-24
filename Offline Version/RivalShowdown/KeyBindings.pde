class KeyBindings {

    /*
    KeyBindings
        game-state-transition
    */
    HashMap<String, Integer> m_keyBindings;

    KeyBindings(String file) {
        m_keyBindings = new HashMap<String, Integer>();

        FileFormatOuput[] bindings = loadFileFormat(file);
        for(FileFormatOuput each_binding : bindings)
            m_keyBindings.put(each_binding.name, each_binding.value);
    }

    int get(String name) {
        if(m_keyBindings.containsKey(name))
            return m_keyBindings.get(name);

        return 0;
    }
}