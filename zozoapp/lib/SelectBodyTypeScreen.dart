import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:zozoapp/DisplayTestPictureScreen.dart';
import 'package:zozoapp/TakePictureScreen.dart';

class SelectBodyTypeScreen extends StatelessWidget {
  final CameraDescription backCamera;
  const SelectBodyTypeScreen({
    Key key,
    @required this.backCamera,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        appBar: AppBar(title: Text('Select your body type')),
        backgroundColor: Colors.white24,
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
          child: ElevatedButton(
            child: Text('Male'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                        backCamera: backCamera, gender: "male")),
              );
            },
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 200),
          child: ElevatedButton(
            child: Text('Female'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TakePictureScreen(
                        backCamera: backCamera, gender: "female")),
              );
            },
          ),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.all(20),
          child: ElevatedButton(
            child: Text('Use testing image'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayTestPictureScreen(
                          imagePath: "assets/images/T.jpg", gender: "male")));
            },
          ),
        ),
      )
    ]);
  }
}
