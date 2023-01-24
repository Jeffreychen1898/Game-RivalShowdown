class Camera {
    PVector position, size, m_displaySize;
    Camera() {
        position = new PVector(0, 0);
        size = new PVector(0, 0);
        m_displaySize = new PVector(0, 0);
    }

    void setDisplaySize() {
        m_displaySize = size.copy();
    }

    void update(float deltaTime) {
        if(size.y > 400) {
            if(size.x > m_displaySize.x)
                m_displaySize = size.copy();
            else {
                m_displaySize.x = lerp(m_displaySize.x, size.x, 2.f * deltaTime);
                m_displaySize.y = lerp(m_displaySize.y, size.y, 2.f * deltaTime);
            }
        }
    }

    void drawRect(float x, float y, float w, float h) {
        PVector shape_position = new PVector(x, y);
        PVector shape_size = new PVector(w, h);

        calculatePosition(shape_position);
        calculateSize(shape_size);

        rect(shape_position.x, shape_position.y, shape_size.x, shape_size.y);
    }

    void drawImage(PImage img, float x, float y, float w, float h) {
        PVector shape_position = new PVector(x, y);
        PVector shape_size = new PVector(w, h);

        calculatePosition(shape_position);
        calculateSize(shape_size);

        image(img, shape_position.x, shape_position.y, shape_size.x, shape_size.y);
    }

    void drawRotatedImage(PImage img, float x, float y, float w, float h, float ang) {
        PVector shape_position = new PVector(x, y);
        PVector shape_size = new PVector(w, h);

        calculatePosition(shape_position);
        calculateSize(shape_size);

        pushMatrix();
        translate(shape_position.x, shape_position.y);
        rotate(ang);
        image(img, 0, 0, shape_size.x, shape_size.y);
        popMatrix();
    }

    //private
    void calculatePosition(PVector inputPosition) {
        PVector camera_position = position.copy();
        camera_position.x = (camera_position.x / m_displaySize.x) - 0.5;
        camera_position.y = (camera_position.y / m_displaySize.y) - 0.5;

        inputPosition.x /= m_displaySize.x;
        inputPosition.y /= m_displaySize.y;

        inputPosition.x -= camera_position.x;
        inputPosition.y -= camera_position.y;

        inputPosition.x *= width;
        inputPosition.y *= height;
    }

    void calculateSize(PVector inputSize) {
        inputSize.x = (inputSize.x / m_displaySize.x) * width;
        inputSize.y = (inputSize.y / m_displaySize.y) * height;
    }
}