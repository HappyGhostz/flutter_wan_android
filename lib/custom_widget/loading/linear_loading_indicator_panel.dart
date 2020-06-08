part of linear_loading_indicator;

class _IndicatorPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: _AnimatedLine(),
            width: 94.0,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: _AnimatedLine(),
            width: 224.0,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16.0),
            child: _AnimatedLine(),
            width: 200.0,
          ),
        ],
      ),
    );
  }
}
