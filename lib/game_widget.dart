part of "game_engine.dart";

abstract class GameWidget extends StatefulWidget {
  /// Size of the game canvas.
  final Size size;

  /// Fit for internal FittedBox.
  final BoxFit fit;

  const GameWidget({super.key, required this.size, this.fit = BoxFit.contain});

  @override
  State<GameWidget> createState() => _GameWidgetState();

  /// Gets called when the widget is initialized.
  void init(GameStateManager manager);

  /// Gets called on every call to the game loop.
  void update(GameStateManager manager);

  /// Gets called on every call to the rebuild of the canvas.
  void draw(Canvas canvas, GameStateManager manager);
}

class _GameWidgetState extends State<GameWidget> {
  final _key = GlobalKey();

  late Timer _timer;
  late GameStateManager _manager;

  @override
  void initState() {
    _manager = GameStateManager(canvasSize: widget.size);
    widget.init(_manager);
    _timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (_) {
      setState(() {
        widget.update(_manager);
        _manager._update();
      });
      _resetPointerValues();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _resetPointerValues() {
    _manager._pointerDown = false;
    _manager._pointerUp = false;
  }

  Offset _globalToLocal(Offset position) {
    final box = _key.currentContext?.findRenderObject() as RenderBox;
    return box.globalToLocal(position);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FittedBox(
        fit: widget.fit,
        child: Listener(
          onPointerDown: (event) {
            _manager._pointerDown = true;
            _manager._pointerClicking = true;
            _manager._pointerPosition = _globalToLocal(event.position);
          },
          onPointerUp: (event) {
            _manager._pointerUp = true;
            _manager._pointerClicking = false;
            _manager._pointerPosition = _globalToLocal(event.position);
          },
          onPointerMove: (event) {
            _manager._pointerPosition = _globalToLocal(event.position);
          },
          child: CustomPaint(
            key: _key,
            size: widget.size,
            painter: GamePainter(manager: _manager, draw: widget.draw),
          ),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final GameStateManager manager;
  final void Function(Canvas, GameStateManager) draw;

  const GamePainter({required this.manager, required this.draw});

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, manager);
    manager._draw(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
