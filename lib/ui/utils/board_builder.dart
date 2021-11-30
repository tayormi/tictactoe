import 'package:flutter/material.dart';

class BoardBuilder {
  static List<Widget> buildBoard<T>(
      List<T> models, Function(int index, T model) builder) {
    return models
        .asMap()
        .map<int, Widget>((key, model) {
          return MapEntry(key, builder(key, model));
        })
        .values
        .toList();
  }
}
