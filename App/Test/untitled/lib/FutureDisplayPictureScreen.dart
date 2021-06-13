import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:untitled/Base64Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FutureDisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const FutureDisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  _FutureDisplayPictureScreenState createState() =>
      _FutureDisplayPictureScreenState();
}

class _FutureDisplayPictureScreenState
    extends State<FutureDisplayPictureScreen> {
  final String testImagePath = 'assets/images/T.jpg';

  Future<String> convertToBase64() async {
    List<int> bytes;

    // var file = File(widget.imagePath);
    // var file = await getImageFileFromAssets('assets/images/T.jpg');
    String path = 'assets/images/T.jpg';
    // final file = File('${(await getTemporaryDirectory()).path}/$path');
    // bytes = await file.readAsBytes();
    // String base64Image = base64Encode(bytes);
    String base64Image = await getFileData("assets/res/TestBase64.txt");
    // print(base64Image.substring(0, 30));
    return base64Image;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    //await file.writeAsBytes(byteData.buffer
    //    .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context) {
    String base64img;
    convertToBase64().then((String result) {
      setState(() {
        base64img = result;
      });
    });
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(title: Text('Show the picture')),
          body: Center(
            child: Column(children: <Widget>[
              Image.asset(testImagePath)
            ]), // Image.file(File(widget.imagePath))
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(20),
            child: ElevatedButton(
              child: Text('Evaluate'),
              onPressed: () {
                var test = createAlbum(base64img);
                //sendToHttp(base64img);

                print("response:");
                print(test.toString());
                test.then((value) {
                  // print response data
                  print("then response:");
                  print(value);
                  print(jsonDecode(value.body));
                  int statusCode = value.statusCode;
                  Map<String, String> headers = value.headers;
                  String contentType = headers['content-type'];
                  String json = value.body;

                  // transform returned data into objects
                  // List<Base64Model> models = parseModel(json);
                  // Base64Model model = parseModel(json);
                  String modelBase64 = parseJson(json);
                  print("base64:");
                  // print(models[0].base64);
                  print(modelBase64);
                  // for some reason there is b' at the start -> remove it
                  // also remove the ' at the end
                  modelBase64 =
                      modelBase64.substring(2, modelBase64.length - 1);
                  print("cut base64 start:");
                  print(modelBase64.substring(0, 50));
                  print("cut end:");
                  print(modelBase64.substring(
                      modelBase64.length - 50, modelBase64.length));

                  print("status:");
                  print(statusCode);
                  print("headers:");
                  print(headers);
                  print("contentType:");
                  print(contentType);
                  print("body:");
                  print(json);

                  //write data to file
                  // writeBase64(model);
                  var decoded = base64.decode(modelBase64);
                  print(decoded);

                  saveFile(decoded);
                  print("file saved");
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

readFilesFromCustomDevicePath() async {
  // Retrieve "External Storage Directory" for Android and "NSApplicationSupportDirectory" for iOS
  Directory directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();

  // Create a new file. You can create any kind of file like txt, doc , json etc.
  File file = await File("${directory.path}/model.glb").create();

  // Read the file content
  Uint8List fileContent = await file.readAsBytes();
  print("fileContent : ${fileContent}");
}

Future<String> getFileData(String path) async {
  return await rootBundle.loadString(path);
}

void saveFile(Uint8List content) async {
  Directory directory = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationSupportDirectory();
  // String path = await _localPath;
  final _modelFile = File('${directory.path}/model.glb');
  print("path: ${directory.path}");
  // final _textController = TextEditingController();

  // await _modelFile.writeAsString(_textController.text);
  // _textController.clear();
  await _modelFile.writeAsBytes(content);
  // var check = await getFileData("${directory.path}/model.glb");
  // print("check:$check");
  readFilesFromCustomDevicePath();
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  print("path:");
  print(path);
  return File('$path/base64-output.txt');
}

Future<File> writeBase64(String base64) async {
  final file = await _localFile;

  // Write the file
  return file.writeAsString(base64);
}

String parseJson(String responseBody) {
  final parsed = json.decode(responseBody);
  return parsed['result'];
}
/*
Base64Model parseModel(String responseBody) {
  // final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  final Map<String, dynamic> parsed = json.decode(responseBody);
  // return parsed
  //     .map<Base64Model>((json) => Base64Model.fromJson(json))
  //     .toList();
  // final Map<String, dynamic> parsed = json.decode(responseBody);
  return new Base64Model(parsed);
  // return List<Base64Model>.from(
  //    parsed["result"].map((x) => Base64Model.fromJson(x)));
}
*/

Future<http.Response> createAlbum(String base64img) {
  print("sending....");
  // String url = 'https://10.0.2.2:5000/measure';
  String url = 'https://tkr.myqnapcloud.com/zozo/measure';
  return http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    // change gender in settings
    body: jsonEncode(<String, String>{"params": base64img, "gender": "female"}),
  );
}
