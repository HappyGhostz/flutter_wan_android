import 'dart:math';

import 'package:flutter/material.dart';

List<String> images = [
  "assets/no_data_one.png",
  "assets/no_data_two.png",
  "assets/no_data_three.png",
  "assets/no_data_four.png",
  "assets/no_data_five.png",
  "assets/no_data_sex.png",
  "assets/no_data_seven.png",
  "assets/no_data_eight.png",
  "assets/no_data_nine.png",
  "assets/no_data_ten.png",
];

String getAssetsImage() {
  var nextInt = Random().nextInt(images.length - 1);
  return images[nextInt];
}

List<Color> colors = [
  Colors.red,
  Colors.yellow[600],
  Colors.purpleAccent,
  Colors.blue,
  Colors.pink[300],
  Colors.cyan[400],
  Colors.green[400],
  Colors.lime[400],
  Colors.orange,
];
Color getAssetsColor() {
  var nextInt = Random().nextInt(colors.length);
  return colors[nextInt];
}
