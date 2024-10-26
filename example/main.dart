import 'package:flutter/material.dart';

import 'particle_simulator_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: const ParticleSimulatorWidget(size: Size(100, 100)),
          ),
        ),
      ),
    );
  }
}
