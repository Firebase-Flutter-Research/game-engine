part of "game_engine.dart";

class GameStateManager {
  final Size canvasSize; // Size of the game widget's canvas.

  GameStateManager({required this.canvasSize});

  bool _pointerDown = false;
  bool _pointerUp = false;
  bool _pointerClicking = false;
  Offset _pointerPosition = Offset.zero;

  final _instances = <int, GameObject>{};
  int _nextId = 0;

  // Get if the pointer was clicked on this frame.
  bool get pointerDown => _pointerDown;
  // Get if the pointer was released on this frame.
  bool get pointerUp => _pointerUp;
  // Get if the pointer is currently being clicked.
  bool get pointerClicking => _pointerClicking;
  // Get the current position of the pointer.
  Offset get pointerPosition => _pointerPosition;

  // Add a new GameObject instance to the game state and return its new id.
  // Allows rendering of and interactions with this instance.
  int addInstance(GameObject instance) {
    _instances[_nextId] = instance;
    instance.init(this);
    return _nextId++;
  }

  // Remove the game state's reference to this instance. Specify either the instance directly or its id.
  bool removeInstance({int? id, GameObject? instance}) {
    if (instance != null) {
      _instances.forEach((key, value) {
        if (instance == value) {
          id = key;
          return;
        }
      });
    }
    if (id == null) return false;
    return _instances.remove(id) != null;
  }

  // Get instance from its id.
  GameObject? getInstance(int id) {
    return _instances[id];
  }

  // Get all instances of the specified type.
  List<T> getInstancesWhereType<T extends GameObject>() {
    return _instances.values.whereType<T>().toList();
  }

  // Get all instances that collide with the specified instance at an optional position.
  List<GameObject> getCollisions(GameObject self, [Offset? position]) {
    return _instances.values
        .where((instance) =>
            instance != self && self.collidesWith(instance, position))
        .toList();
  }

  // Get all instances that contain the specified point.
  List<GameObject> getHits(Offset point) {
    return _instances.values
        .where((instance) => instance.containsPoint(point))
        .toList();
  }

  void _update() {
    for (var i = 0; i < _nextId; i++) {
      _instances[i]?.update(this);
    }
  }

  void _draw(Canvas canvas) {
    for (var i = 0; i < _nextId; i++) {
      _instances[i]?.draw(canvas, this);
    }
  }
}
