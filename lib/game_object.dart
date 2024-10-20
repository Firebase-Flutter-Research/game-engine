part of "game_engine.dart";

abstract class GameObject {
  /// Position of the object in the game state.
  Offset position;

  /// Optional bounds of the object.
  final HitBox? hitBox;

  GameObject({required this.position, this.hitBox});

  /// Gets called when the object has been instantiated in the game state.
  void init(GameStateManager manager);

  /// Gets called on every call to the game loop.
  void update(GameStateManager manager);

  /// Gets called on every call to the rebuild of the canvas.
  void draw(Canvas canvas, GameStateManager manager);

  /// Determine if this instance collides with another.
  bool collidesWith(GameObject other, [Offset? position]) {
    position ??= this.position;
    if (hitBox == null || other.hitBox == null) return false;
    return hitBox!.collidesWith(position, other.hitBox!, other.position);
  }

  /// Determine if this instance contains the specified point.
  bool containsPoint(Offset point) {
    if (hitBox == null) return false;
    return hitBox!.containsPoint(position, point);
  }
}
