import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer/model_viewer.dart';

// todo: add custom path (see save file)
class TestViewModel extends StatelessWidget {
  final File file = File(
      "/storage/emulated/0/Android/data/com.example.untitled/files/model.glb");

  @override
  Widget build(BuildContext context) {
    final exists = file.existsSync();
    print(exists);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Model Viewer")),
        body: ModelViewer(
          src: "file://${file.path}",
          alt: "A 3D model of an astronaut",
          ar: true,
          autoRotate: true,
          cameraControls: true,
        ),
      ),
    );
  }
}
