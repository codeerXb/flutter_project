import 'package:flutter/material.dart';

typedef _BaseFunction<T> = void Function(T o);

/// 来源: https://blog.csdn.net/zhuowalun8427/article/details/121285947 。
/// 左移删除
class LeftSlideActions extends StatefulWidget {
  final double actionsWidth;
  final List<Widget> actions;
  final Widget child;
  final Decoration? decoration;
  final VoidCallback? actionsWillShow;
  final _BaseFunction<VoidCallback>? exportHideActions;

  const LeftSlideActions({
    Key? key,
    required this.actionsWidth,
    required this.actions,
    required this.child,
    this.decoration,
    this.actionsWillShow,
    this.exportHideActions,
  }) : super(key: key);

  @override
  _LeftSlideActionsState createState() => _LeftSlideActionsState();
}

class _LeftSlideActionsState extends State<LeftSlideActions>
    with TickerProviderStateMixin {
  double _translateX = 0;
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: -widget.actionsWidth,
      upperBound: 0,
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _translateX = _controller.value;
        setState(() {});
      });
    if (widget.exportHideActions != null) {
      widget.exportHideActions!(_hide);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.decoration,
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.actions,
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (v) {
              _onHorizontalDragUpdate(v);
            },
            onHorizontalDragEnd: (v) {
              _onHorizontalDragEnd(v);
            },
            child: Transform.translate(
              offset: Offset(_translateX, 0),
              child: Row(
                children: [
                  Expanded(flex: 1, child: widget.child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _translateX =
        (_translateX + details.delta.dx).clamp(-widget.actionsWidth, 0.0);
    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    _controller.value = _translateX;
    if (details.velocity.pixelsPerSecond.dx > 200) {
      _hide();
    } else if (details.velocity.pixelsPerSecond.dx < -200) {
      _show();
    } else {
      if (_translateX.abs() > widget.actionsWidth / 2) {
        _show();
      } else {
        _hide();
      }
    }
  }

  void _show() {
    if (widget.actionsWillShow != null) {
      widget.actionsWillShow!();
    }
    if (_translateX != -widget.actionsWidth) {
      _controller.animateTo(-widget.actionsWidth);
    }
  }

  void _hide() {
    if (_translateX != 0) {
      _controller.animateTo(0);
    }
  }
}
