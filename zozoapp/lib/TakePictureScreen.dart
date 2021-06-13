import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zozoapp/DisplayPictureScreen.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription backCamera;
  final String gender;
  const TakePictureScreen(
      {Key key, @required this.backCamera, @required this.gender})
      : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // create Controller to display current output
    _controller = CameraController(
      widget.backCamera,
      ResolutionPreset.medium,
    );
    // initialize controller
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    //dispose controller when widget is closed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                    imagePath: image?.path, gender: widget.gender),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
