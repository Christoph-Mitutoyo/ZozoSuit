import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:camera/camera.dart';

import 'package:untitled/TakePictureScreen.dart';
import 'package:untitled/PickImageFromGallery.dart';
import 'package:untitled/TestImageFromGallery.dart';
import 'package:untitled/TestViewModel.dart';

// min sdk: 21, due to camera

CameraDescription backCamera;

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
  //firstCamera = cameras.first;
  runApp(MaterialApp(theme: ThemeData.dark(), home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Names Generator',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        //secondaryHeaderColor: Colors.amber,
        //colorScheme: ColorScheme.dark(),
        canvasColor: Colors.white24,
        brightness: Brightness.dark,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({
    Key key,
  }) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return Stack(children: <Widget>[
      ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();

            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(generateWordPairs().take(10));
            }
            return _buildRow(_suggestions[index]);
          }),
      Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.all(20),
          child: ElevatedButton(
            child: Text('Camera'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TakePictureScreen(camera: backCamera)),
              );
            },
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.all(20),
          child: ElevatedButton(
            child: Text('View Model'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestViewModel()),
              );
            },
          ),
        ),
      ),
      // alignment: Alignment.bottomLeft,
      //  child: Container(
      //    margin: EdgeInsets.all(20),
      //    child: ElevatedButton(
      //      child: Text('Gallery'),
      //      onPressed: () {
      //        Navigator.push(
      //          context,
      //          MaterialPageRoute(builder: (context) => TestImageFromGallery()),
      //        );
      //      },
      //    ),
      //  ),
      //),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
