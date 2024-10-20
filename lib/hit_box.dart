part of "game_engine.dart";

class HitBox {
  final Offset size; // Bounds of the hit box.

  const HitBox(this.size);

  // Determine if this hit box collides with another when at specified positions.
  bool collidesWith(Offset position, HitBox other, Offset otherPosition) {
    return (position.dx >= otherPosition.dx &&
                position.dx <= otherPosition.dx + other.size.dx ||
            otherPosition.dx >= position.dx &&
                otherPosition.dx <= position.dx + size.dx) &&
        (position.dy >= otherPosition.dy &&
                position.dy <= otherPosition.dy + other.size.dy ||
            otherPosition.dy >= position.dy &&
                otherPosition.dy <= position.dy + size.dy);
  }

  // Determine if this hit box contains the specified point when at a specified position.
  bool containsPoint(Offset position, Offset point) {
    return (point.dx >= position.dx && point.dx <= position.dx + size.dx) &&
        (point.dy >= position.dy && point.dy <= position.dy + size.dy);
  }
}
