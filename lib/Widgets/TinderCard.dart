import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Provider/Provider.dart';
import 'package:provider/provider.dart';

class TinderCard extends StatefulWidget {
  final String urlImage;
  final bool isFront;
  final String prid;
  // final Size cardSize;

  const TinderCard({
    super.key,
    required this.urlImage,
    required this.isFront,
    required this.prid,
    // required this.cardSize,
  });

  @override
  _TinderCardState createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final size = MediaQuery.of(context).size;
  //     final provider = Provider.of<CardProvider>(context, listen: false);
  //     provider.setScreenSize(size);
  //   });
  // }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CardProvider>(context, listen: false);
      final size = MediaQuery.of(context).size;
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) => Center(
        child: SizedBox(
          height: Provider.of<CardProvider>(context, listen: false)
                  .screenSize
                  .height /
              1.3,
          width: Provider.of<CardProvider>(context, listen: false)
                  .screenSize
                  .width /
              1.05,
          child: widget.isFront ? buildFrontCard() : buildCard(),
        ),
      );

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;
            final milliseconds = provider.isDragging ? 0 : 400;

            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: milliseconds),
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: buildCard(),
            );
          },
        ),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition(widget.prid);
        },
      );

  Widget buildCard() => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.urlImage),
              fit: BoxFit.cover,
              alignment: const Alignment(-0.3, 0),
            ),
          ),
        ),
      );
}
