abstract class GameObject {

  protected float x;
  protected float y;
  protected float w;
  protected float h;

  GameObject(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  abstract void update();
  abstract void display();
}
