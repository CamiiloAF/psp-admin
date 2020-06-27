import 'package:flutter/cupertino.dart';

class OneLineBox extends StatelessWidget {
  final String text;

  final bool haveBorderTop;
  final bool haveBorderBottom;
  final bool haveBorderLeft;
  final bool haveBorderRight;

  OneLineBox(
      {@required this.text,
      this.haveBorderTop = true,
      this.haveBorderBottom = true,
      this.haveBorderLeft = false,
      this.haveBorderRight = false});

  @override
  Widget build(BuildContext context) {
    final borderTop = (haveBorderTop) ? BorderSide(width: 1) : BorderSide.none;
    final borderBottom =
        (haveBorderBottom) ? BorderSide(width: 1) : BorderSide.none;
    final borderLeft =
        (haveBorderLeft) ? BorderSide(width: 1) : BorderSide.none;
    final borderRight =
        (haveBorderRight) ? BorderSide(width: 1) : BorderSide.none;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border(
              top: borderTop,
              bottom: borderBottom,
              left: borderLeft,
              right: borderRight)),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class TableOneLineBox extends StatelessWidget {
  final String textTopLeft;
  final String textTopRigth;
  final String textBottomLeft;
  final String textBottomRigth;

  const TableOneLineBox(
      {@required this.textTopLeft,
      @required this.textTopRigth,
      @required this.textBottomLeft,
      @required this.textBottomRigth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Container(
              height: 70,
              child: OneLineBox(
                text: textTopLeft,
                haveBorderRight: true,
              ),
            )),
            Expanded(
                child: Container(
              height: 70,
              child: OneLineBox(
                text: textTopRigth,
              ),
            )),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: Container(
              height: 70,
              child: OneLineBox(
                text: textBottomLeft,
                haveBorderTop: false,
                haveBorderRight: true,
              ),
            )),
            Expanded(
                child: Container(
              height: 70,
              child: OneLineBox(
                text: textBottomRigth,
                haveBorderTop: false,
              ),
            )),
          ],
        ),
      ],
    );
  }
}
