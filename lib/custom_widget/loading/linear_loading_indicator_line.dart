part of linear_loading_indicator;

const double _blockWidth = 16.0;

class _AnimatedLine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AnimatedLineState();
  }
}

class _AnimatedLineState extends State<_AnimatedLine> with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: _Curve(),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double animationValue) {
    return Container(
      constraints: const BoxConstraints.tightFor(
        width: double.infinity,
        height: 8.0,
      ),
      child: CustomPaint(
        painter: _Painter(
          backgroundColor: AppColors.lightGrey3,
          valueColor: AppColors.borderSideGray,
          animationValue: animationValue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return _buildIndicator(context, _animation.value);
      },
    );
  }
}

class _Curve extends Curve {
  @override
  double transform(double t) {
    return 1000 * t;
  }
}

class _Painter extends CustomPainter {
  const _Painter({
    this.backgroundColor,
    this.valueColor,
    this.animationValue,
  });

  final Color backgroundColor;
  final Color valueColor;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, paint);

    paint.color = valueColor;
    var startX = animationValue - _blockWidth;
    var endX = startX + _blockWidth;
    var x = startX.clamp(0.0, size.width).toDouble();
    var width = endX.clamp(0.0, size.width).toDouble() - x;
    canvas.drawRect(Offset(x, 0.0) & Size(width, size.height), paint);
  }

  @override
  bool shouldRepaint(_Painter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.animationValue != animationValue;
  }
}
