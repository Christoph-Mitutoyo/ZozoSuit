import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageFromGallery extends StatefulWidget {
  const PickImageFromGallery({Key key}) : super(key: key);

  final String title = 'Select image from Gallery';

  @override
  _PickImageFromGalleryState createState() => _PickImageFromGalleryState();
}

class _PickImageFromGalleryState extends State<PickImageFromGallery> {
  File _imageFile;
  ImagePicker picker = ImagePicker();

  pickImageFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: _imageFile as Future<File>,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
        snapshot.data != null) {
          return Image.file(
              snapshot.data,
            width: 1000,
            height: 1000,
          );
        } else if (snapshot.error != null) {
          return const Text('Error picking image',
          textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No image selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showImage(),
            ElevatedButton(
                onPressed: () {
                  pickImageFromGallery();
                },
                child: Text('Select image from gallery')
            )
          ],
        ),
      ),
    );
  }
}
