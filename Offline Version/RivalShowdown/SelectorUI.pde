class SelectorUI {
    PGraphics m_selector;
    PVector m_itemSize;
    float m_gap;
    color m_backgroundColor;

    ArrayList<PImage> m_items;

    int m_currentIndex;
    float m_displayPosition;
    float m_actualPosition;

    SelectorUI(float w, float h) {
        m_selector = createGraphics((int)w, (int)h);
        m_selector.noSmooth();

        m_items = new ArrayList<PImage>();
        m_itemSize = new PVector(w, h);
        m_gap = 0;
        m_backgroundColor = color(0);

        reset();
    }

    void reset() {
        m_currentIndex = 0;
        m_actualPosition = m_selector.width / 2;
        m_displayPosition = m_actualPosition;
    }

    void update(float deltaTime) {
        m_displayPosition = lerp(m_displayPosition, m_actualPosition, 6 * deltaTime);
    }

    PGraphics render() {
        m_selector.beginDraw();
        //m_selector.background(m_backgroundColor);
        m_selector.background(199, 93, 6);
        m_selector.imageMode(CENTER);

        for(int i=0;i<m_items.size();i++) {
            float position_x = m_displayPosition + i * (m_itemSize.x + m_gap);
            float position_y = m_selector.height / 2;

            float distance = Math.abs(position_x - m_selector.width / 2);

            float image_width = m_itemSize.x * Math.max((1 - distance * 0.003), 0.5);
            float image_height = m_itemSize.y * Math.max((1 - distance * 0.003), 0.5);

            m_selector.image(m_items.get(i), position_x, position_y, image_width, image_height);
        }

        m_selector.endDraw();

        return m_selector;
    }

    int getCurrentIndex() {
        return m_currentIndex;
    }

    void nextItem() {
        if(m_currentIndex < m_items.size() - 1) {
            m_actualPosition -= m_itemSize.x + m_gap;
            m_currentIndex ++;
        }
    }

    void previousItem() {
        if(m_currentIndex > 0) {
            m_actualPosition += m_itemSize.x + m_gap;
            m_currentIndex --;
        }
    }

    void addItem(PImage image) {
        m_items.add(image);
    }

    void setBackgroundColor(color backgroundColor) {
        m_backgroundColor = backgroundColor;
    }

    void setGap(float gap) {
        m_gap = gap;
    }

    void setItemSize(float w, float h) {
        m_itemSize.x = w;
        m_itemSize.y = h;
    }
}
