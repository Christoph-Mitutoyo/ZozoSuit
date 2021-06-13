import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer/model_viewer.dart';

// todo: add custom path (see save file)
class ViewModel extends StatelessWidget {
  final File file;
  const ViewModel({Key key, @required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final exists = file.existsSync();
    print(exists);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Your generated 3d model"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Icon(Icons.home),
                )),
          ],
        ),
        body: ModelViewer(
          src: "file://${file.path}",
          ar: true,
          autoRotate: true,
          cameraControls: true,
        ),
      ),
    );
  }
}
