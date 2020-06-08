import 'package:flutter/material.dart';

class LoadMorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/load_more.gif",
            width: 160,
            height: 60,
            fit: BoxFit.contain,
          )
        ],
      ),
    );
  }
}
