import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final ShapeBorder shape;
  final Color color;
  final Alignment alignment;
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final void Function() onTap;
  final double width;
  final double height;

  CustomButton({
    @required this.child,
    this.alignment,
    this.color,
    this.shape,
    this.margin,
    this.padding,
    this.onTap,
    this.height,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    final _color=color??Theme.of(context).primaryColor;
    final _alignment=alignment??Alignment.center;
    final _shape=shape??StadiumBorder();
    final _padding=padding??EdgeInsets.all(8);
    final _margin=margin??EdgeInsets.all(0);
    return Container(
      margin: _margin,
      padding: _padding,
      width: width,
      height: height,
      child:Material(
        shape: _shape,
        color: _color,
        child:InkWell(
          customBorder: _shape,
          child:Container(
            alignment: _alignment,
            child: child,
            padding: EdgeInsets.all(6),
          ),
          onTap: onTap,
        )
      )
    );
  }
}