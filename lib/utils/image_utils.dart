import 'dart:math';

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
