import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;

//import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
//import 'package:web_socket_channel/io.dart';

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
  Future<String> convertToBase64() async {
    List<int> bytes;
    bytes = await File(widget.imagePath).readAsBytes();
    String base64Image = base64Encode(bytes);
    // print(base64Image);
    return base64Image;
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
          body: Center(child: Image.file(File(widget.imagePath))),
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
                  //print(jsonDecode(value.body));
                  int statusCode = value.statusCode;
                  Map<String, String> headers = value.headers;
                  String contentType = headers['content-type'];
                  String json = value.body;

                  print(statusCode);
                  print(headers);
                  print(contentType);
                  print(json);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

void sendToHttp(String base64img) {
  print("sending http....");
  try {
    HttpClient client = new HttpClient();
    client
        .getUrl(Uri.parse("https://10.0.2.2:5000/measure"))
        .then((HttpClientRequest request) {
      request.headers.set(
          HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.write('{"params": base64img}');
      // Optionally set up headers...
      // Optionally write to the request object...
      // Then call close.
      print("sent request");

      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      response.transform(utf8.decoder).listen((contents) {
        print("response:");
        print(contents);
      });
    });
  } catch (e) {
    // do nothing
  }
}

Future<http.Response> createAlbum(String base64img) {
  print("sending....");
  // values for uri.hhtp
  final _authority = "10.0.2.2";
  final _path = "/measure";
  final _params = {
    "params": base64img,
  };
  // Uri.http(_authority, _path, _params)

  // client
  //var client = new HttpClient();
  //client.get(new Uri.https("locahost:8000", "/category"));
  //client.post(
  //  "10.0.2.2",
  //  5000,
  //  "",
  //);

  return http.post(
    Uri.parse('https://10.0.2.2:5000/measure'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      //'title': base64str,
      "params": base64img
    }),
  );
}
