import 'dart:math' as math;

import 'package:flutter/material.dart';

class HeroPhoto extends StatelessWidget {
  HeroPhoto({
    Key key,
    this.photo,
    this.height,
    this.width,
    this.fit,
  }) : super(key: key);
  final String photo;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: Image.asset(
            photo,
            fit: fit,
          ),
        ),
      ),
    );
  }
}

RectTween _createRectTween(Rect begin, Rect end) {
  return MaterialRectCenterArcTween(begin: begin, end: end);
}

class RadialHeroPhoto extends StatelessWidget {
  RadialHeroPhoto({
    Key key,
    this.imageName,
    this.height,
    this.width,
    this.fit,
    this.isNeedClip,
  }) : super(key: key);
  final String imageName;
  final double width;
  final double height;
  final BoxFit fit;
  final bool isNeedClip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Hero(
        createRectTween: _createRectTween,
        tag: imageName,
        child: RadialExpansion(
          height: height,
          width: width,
          isNeedClip: isNeedClip,
          child: Photo(
            photo: imageName,
          ),
        ),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  RadialExpansion({
    Key key,
    this.width,
    this.height,
    this.child,
    this.isNeedClip,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final bool isNeedClip;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: isNeedClip ? 2.0 * (width / math.sqrt2) : width,
          height: isNeedClip ? 2.0 * (height / math.sqrt2) : height,
          child: ClipRect(
            child: child, // Photo
          ),
        ),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  Photo({Key key, this.photo, this.color}) : super(key: key);

  final String photo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Slightly opaque color appears where the image has transparency.
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: Image.asset(
        photo,
        fit: BoxFit.contain,
      ),
    );
  }
}
