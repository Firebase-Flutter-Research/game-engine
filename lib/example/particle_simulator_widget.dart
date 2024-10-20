import 'package:flutter/material.dart';
import 'package:game_engine/example/particle_simulator_objects.dart';
import 'package:game_engine/game_engine.dart';

class ParticleSimulatorWidget extends GameWidget {
  const ParticleSimulatorWidget({super.key, required super.size});

  @override
  void draw(Canvas canvas, GameStateManager manager) {}

  @override
  void init(GameStateManager manager) {
    manager.addInstance(Wall(
        position: const Offset(0, 0),
        hitBox: HitBox(Offset(manager.canvasSize.width, 8))));
    manager.addInstance(Wall(
        position: Offset(0, manager.canvasSize.height - 8),
        hitBox: HitBox(Offset(manager.canvasSize.width, 8))));
    manager.addInstance(Wall(
        position: const Offset(0, 0),
        hitBox: HitBox(Offset(8, manager.canvasSize.height))));
    manager.addInstance(Wall(
        position: Offset(manager.canvasSize.width - 8, 0),
        hitBox: HitBox(Offset(8, manager.canvasSize.height))));
  }

  @override
  void update(GameStateManager manager) {
    if (manager.pointerDown) {
      manager.addInstance(Dot(
          direction: Offset.zero,
          position: manager.pointerPosition,
          hitBox: const HitBox(Offset(4, 4))));
    }
  }
}
