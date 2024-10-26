import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';

class Wall extends GameObject {
  Wall({required super.position, required super.hitBox});

  @override
  void draw(Canvas canvas, GameStateManager manager) {
    canvas.drawRect(
        Rect.fromLTWH(
            position.dx, position.dy, hitBox!.size.dx, hitBox!.size.dy),
        Paint()..color = Colors.grey[700]!);
  }

  @override
  void init(GameStateManager manager) {}

  @override
  void update(double deltaTime, GameStateManager manager) {}
}

class Dot extends GameObject {
  Offset direction;
  bool attached = true;
  late Offset startPosition;

  Dot(
      {required this.direction,
      required super.position,
      required super.hitBox});

  @override
  void draw(Canvas canvas, GameStateManager manager) {
    final offset = hitBox!.size / 2;
    final red = Paint()..color = Colors.red;
    final black = Paint()..color = Colors.black;
    final redOutline = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    if (attached) {
      var direction = normalize(position - startPosition);
      canvas.drawLine(position + offset, startPosition + direction * 0.5, red);
      canvas.drawCircle(startPosition, 0.5, redOutline);
    }

    canvas.drawCircle(position + offset, offset.dx, black);
  }

  @override
  void init(GameStateManager manager) {
    startPosition = position;
  }

  @override
  void update(double deltaTime, GameStateManager manager) {
    if (attached) {
      if (manager.pointerUp) {
        final direction = startPosition - manager.pointerPosition;
        if (direction.distanceSquared == 0) {
          manager.removeInstance(instance: this);
        } else {
          this.direction =
              normalize(direction) * min(direction.distance * 4, 200);
        }
        attached = false;
      }
      position = manager.pointerPosition - hitBox!.size / 2;
    } else {
      if (manager
          .getCollisions(this, position + direction.scale(1, 0) * deltaTime)
          .whereType<Wall>()
          .isNotEmpty) {
        direction = direction.scale(-1, 1);
      }
      if (manager
          .getCollisions(this, position + direction.scale(0, 1) * deltaTime)
          .whereType<Wall>()
          .isNotEmpty) {
        direction = direction.scale(1, -1);
      }
      final dots = manager
          .getCollisions(this, position + direction * deltaTime)
          .where((e) => e is Dot && !e.attached);
      if (dots.isNotEmpty) {
        final other = dots.first as Dot;
        final direction = other.position - position;
        if (direction.distanceSquared != 0) {
          final selfProjection = project(this.direction, direction);
          final otherProjection = project(other.direction, -direction);
          this.direction += otherProjection - selfProjection;
          other.direction += selfProjection - otherProjection;
        }
      }
      position += direction * deltaTime;
    }
  }

  static Offset normalize(Offset offset) {
    return offset / offset.distance;
  }

  static Offset project(Offset from, Offset to) {
    final normalized = normalize(to);
    final dot = from.dx * normalized.dx + from.dy * normalized.dy;
    return normalized * dot;
  }
}
