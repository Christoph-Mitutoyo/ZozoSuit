import 'package:flutter/cupertino.dart';

class Base64Model {
  final String base64;

  Base64Model({@required this.base64});

  factory Base64Model.fromJson(Map<String, dynamic> json) {
    return Base64Model(
      base64: json['result'] as String,
    );
  }
}
