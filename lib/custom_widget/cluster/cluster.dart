import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ActionCluster extends MultiChildRenderObjectWidget {
  ActionCluster({Key key, @required List<Widget> children})
      : assert(children != null),
        assert(children.isNotEmpty),
        assert(children.length <= 2),
        super(key: key, children: children);

  @override
  _RenderActionCluster createRenderObject(BuildContext context) => _RenderActionCluster();
}

class _ActionClusterParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderActionCluster extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ActionClusterParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ActionClusterParentData>,
        DebugOverflowIndicatorMixin {
  _RenderActionCluster({
    List<RenderBox> children,
  }) {
    addAll(children);
  }

  Axis get direction => _direction;
  Axis _direction;

  set direction(Axis value) {
    assert(value != null);
    if (_direction != value) {
      _direction = value;
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ActionClusterParentData) child.parentData = _ActionClusterParentData();
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.constrain(Size(constraints.maxWidth, constraints.maxHeight));
      return;
    }

    if (childCount == 1) {
      direction = Axis.horizontal;

      var child = firstChild;
      var inner = BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
      );
      child.layout(inner, parentUsesSize: true);

      // ignore: avoid_as
      var parentData = child.parentData as BoxParentData;
      parentData.offset = const Offset(0.0, 0.0);

      size = constraints.constrain(Size(constraints.maxWidth, child.size.height));
      return;
    }

    if (childCount > 1) {
      direction = Axis.horizontal;

      var _action1 = firstChild;
      // ignore: avoid_as
      var childParentData = _action1.parentData as _ActionClusterParentData;
      var _action2 = childParentData.nextSibling;
      var _divider = 16.0;

      var firstLayoutConstraints = BoxConstraints(
        minWidth: 0.0,
        maxWidth: constraints.maxWidth,
      );

      _action1.layout(firstLayoutConstraints, parentUsesSize: true);
      _action2.layout(firstLayoutConstraints, parentUsesSize: true);

      var w1 = _action1.size.width;
      var w2 = _action2.size.width;

      // both smaller than half
      var half = (constraints.maxWidth - _divider) / 2;
      if (w1 < half && w2 < half) {
        var inner = BoxConstraints(
          minWidth: half,
          maxWidth: constraints.maxWidth,
        );
        _action1.layout(inner, parentUsesSize: true);
        _action2.layout(inner, parentUsesSize: true);

        // ignore: avoid_as
        var parentData1 = _action1.parentData as BoxParentData;
        parentData1.offset = const Offset(0.0, 0.0);

        // ignore: avoid_as
        var parentData2 = _action2.parentData as BoxParentData;
        parentData2.offset = Offset(half + _divider, 0.0);

        var height = math.max(_action1.size.height, _action2.size.height);
        size = constraints.constrain(Size(constraints.maxWidth, height));
        return;
      }

      // one is larger than half, sum smaller than total
      /*
      double space = constraints.maxWidth - _divider - w1 - w2;
      if (space > 0) {
        var ds = space / 2;

        _action1.layout(BoxConstraints(
          minWidth: w1 + ds,
          maxWidth: constraints.maxWidth,
        ), parentUsesSize: true);

        _action2.layout(BoxConstraints(
          minWidth: w2 + ds,
          maxWidth: constraints.maxWidth,
        ), parentUsesSize: true);

        BoxParentData parentData1 = _action1.parentData;
        parentData1.offset = Offset(0.0, 0.0);

        BoxParentData parentData2 = _action2.parentData;
        parentData2.offset = Offset(w1 + ds + _divider, 0.0);

        double height = math.max(_action1.size.height, _action2.size.height);
        size = constraints.constrain(Size(constraints.maxWidth, height));
        return;
      }
      */

      direction = Axis.vertical;

      // sum larger than total
      _divider = 8.0;

      var inner = BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
      );
      _action1.layout(inner, parentUsesSize: true);
      _action2.layout(inner, parentUsesSize: true);

      var h1 = _action1.size.height;
      var h2 = _action2.size.height;

      // ignore: avoid_as
      var parentData1 = _action1.parentData as BoxParentData;
      parentData1.offset = Offset(0.0, h2 + _divider);

      // ignore: avoid_as
      var parentData2 = _action2.parentData as BoxParentData;
      parentData2.offset = const Offset(0.0, 0.0);

      size = constraints.constrain(Size(constraints.maxWidth, h1 + h2 + _divider));
    }
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    // ignore: avoid_as
    return defaultHitTestChildren(result as BoxHitTestResult, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
