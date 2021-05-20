import 'dart:convert';
import 'dart:io';
import 'dart:ui';

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
  Future convertToBase64() async {
    List<int> bytes;
    bytes = await File(widget.imagePath).readAsBytes();
    String base64Image = base64Encode(bytes);
    print(base64Image);
    return base64Image;
  }

  @override
  Widget build(BuildContext context) {
    Future base64 = convertToBase64();
    return Scaffold(
      appBar: AppBar(title: Text('Show the picture')),
      body: Center(child: Image.file(File(widget.imagePath))),
    );
  }
}
