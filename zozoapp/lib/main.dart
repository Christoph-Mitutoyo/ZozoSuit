import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:zozoapp/SelectBodyTypeScreen.dart';
import 'package:zozoapp/ViewModel.dart';

CameraDescription backCamera;
File modelFile;

// accept all certificates
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  // allow all certificates
  HttpOverrides.global = new MyHttpOverrides();
  // todo: remove and add real certificate
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  imageCache.clear();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  CameraDescription camera;
  // Get a back facing camera from the list of available cameras.
  for (camera in cameras) {
    if (camera.lensDirection == CameraLensDirection.back) {
      backCamera = camera;
      break;
    }
  }
  Directory directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();
  modelFile = File("${directory.path}/model.glb");
  //firstCamera = cameras.first;
  runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        //secondaryHeaderColor: Colors.amber,
        //colorScheme: ColorScheme.dark(),
        canvasColor: Colors.white24,
        brightness: Brightness.dark,
      ),
      home: MainScreen()));
}

class MainScreen extends StatelessWidget {
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('No model available'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "No model available. Try taking a picture with the ZOZOSUIT first."),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        //Here you can set what ever background color you need.
        backgroundColor: Colors.white24,
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
          child: ElevatedButton(
            child: Text('Take picture'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SelectBodyTypeScreen(backCamera: backCamera)),
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
            child: Text('View previous model'),
            onPressed: () {
              if (modelFile.existsSync()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewModel(file: modelFile)),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              }
            },
          ),
        ),
      ),
    ]);
  }
}
