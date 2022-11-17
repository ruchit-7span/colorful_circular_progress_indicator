import 'dart:math';

import 'package:flutter/material.dart';

class ColorfulCircularProgressIndicator extends StatefulWidget {
  final double strokeWidth;
  final List<Color> colors;
  final double indicatorWidth;
  final double indicatorHeight;
  const ColorfulCircularProgressIndicator(
      {Key? key,
      this.strokeWidth = 5.0,
      required this.colors,
      this.indicatorHeight = 40.0,
      this.indicatorWidth = 40.0})
      : super(key: key);

  @override
  ColorfulCircularProgressIndicatorState createState() =>
      ColorfulCircularProgressIndicatorState();
}

class ColorfulCircularProgressIndicatorState
    extends State<ColorfulCircularProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController firstAnimationController;
  late Animation<double> firstAnimation;
  late AnimationController secondAnimationController;
  late Animation<double> secondAnimation;
  Random rd = Random();
  int randomColorId = 0;
  int helpId = 0;
  int loopHelperId = 0;
  @override
  void initState() {
    super.initState();
    initAnimation();
    firstAnimationController.forward();
    secondAnimationController.forward();
  }

  @override
  void dispose() {
    firstAnimationController.dispose();
    secondAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.indicatorHeight,
      width: widget.indicatorWidth,
      child: CustomPaint(
        painter: MyCustomPainter(
            startAngle: firstAnimation.value,
            sweepAngle: secondAnimation.value,
            listColors: widget.colors,
            currentIndex: randomColorId,
            customStrokeWidth: widget.strokeWidth),
      ),
    );
  }

  void switchColors() {
    if (widget.colors.isNotEmpty) {
      final listSize = widget.colors.length;
      if (listSize == 1) {
      } else {
        if (loopHelperId > listSize - 1) {
          loopHelperId = 0;
          randomColorId = loopHelperId;
        } else {
          if (loopHelperId == 0) {
            loopHelperId++;
          }
          randomColorId = loopHelperId;
          if (loopHelperId > 0) {
            loopHelperId++;
          }
        }
      }
    }
  }

  void doColorChanges() {
    if (helpId <= 100) {
      helpId++;
      if (helpId == 100) {
        switchColors();
      }
      if (helpId > 100) {
        helpId = 0;
      }
    }
  }

  void initAnimation() {
    firstAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    firstAnimation =
        Tween<double>(begin: -pi, end: pi).animate(firstAnimationController)
          ..addListener(() {
            setState(() {
              doColorChanges();
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              firstAnimationController.repeat();
            } else if (status == AnimationStatus.dismissed) {
              firstAnimationController.forward();
            }
          });

    secondAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    secondAnimation = Tween<double>(begin: -1, end: -6).animate(CurvedAnimation(
        parent: secondAnimationController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {
          /*doColorChanges();*/
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondAnimationController.forward();
        }
      });
  }
}

class MyCustomPainter extends CustomPainter {
  final double startAngle;
  final double sweepAngle;
  final List<Color> listColors;
  final int currentIndex;
  final double customStrokeWidth;

  MyCustomPainter(
      {required this.startAngle,
      required this.sweepAngle,
      required this.listColors,
      required this.currentIndex,
      required this.customStrokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint myCircle = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    canvas.drawCircle(
      Offset(size.width * .5, size.height * .5),
      size.width * .3,
      myCircle,
    );

    Paint myArc = Paint()
      ..color = listColors[currentIndex]
      ..style = PaintingStyle.stroke
      ..strokeWidth = customStrokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTRB(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      myArc,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
