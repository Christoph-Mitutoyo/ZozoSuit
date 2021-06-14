import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:zozoapp/ViewModel.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String gender;
  const DisplayPictureScreen(
      {Key key, @required this.imagePath, @required this.gender})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  Future<String> convertToBase64() async {
    List<int> bytes;

    var file = File(widget.imagePath);
    bytes = await file.readAsBytes();
    String base64Image = base64Encode(bytes);

    return base64Image;
  }

  @override
  Widget build(BuildContext context) {
    String base64img;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(title: Text('Your picture')),
          body: Center(
            child:
                Column(children: <Widget>[Image.file(File(widget.imagePath))]),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 150,
            height: 40,
            margin: EdgeInsets.all(20),
            child: ProgressButton(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              strokeWidth: 2,
              child: Text('Evaluate'),
              onPressed: (AnimationController controller) async {
                if (controller.isCompleted) {
                  controller.reverse();
                } else {
                  controller.forward();

                  base64img = await convertToBase64();
                  print(base64img);
                  var response = sendPictureToServer(base64img, widget.gender);
                  response.then((value) async {
                    print(value);
                    print(value.body.substring(100));
                    String json = value.body;
                    String modelBase64 = parseJson(json);
                    // for some reason there is b' at the start -> remove it
                    // also remove the ' at the end
                    modelBase64 =
                        modelBase64.substring(2, modelBase64.length - 1);
                    var decoded = base64.decode(modelBase64);
                    File modelFile = await saveFileReturnFile(decoded);

                    print("finished");
                    // display model
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewModel(
                          file: modelFile,
                        ),
                      ),
                    );
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

Future<File> saveFileReturnFile(Uint8List content) async {
  // get directory for Android/IOS
  Directory directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();
  final _modelFile = File('${directory.path}/model.glb');
  _modelFile.create();
  await _modelFile.writeAsBytes(content);
  await _modelFile.create();
  return _modelFile;
}

String parseJson(String responseBody) {
  final parsed = json.decode(responseBody);
  return parsed['result'];
}

Future<http.Response> sendPictureToServer(String base64img, String gender) {
  print("sending....");
  //String url = 'https://10.0.2.2:5000/measure';
  String url = 'https://tkr.myqnapcloud.com/zozo/measure';
  return http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{"params": base64img, "gender": gender}),
  );
}
