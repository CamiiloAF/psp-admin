import 'package:flutter/material.dart';

class OneSimpleRow extends StatelessWidget {
  final String label;
  final String text;

  const OneSimpleRow({@required this.label, @required this.text});

  @override
  Widget build(BuildContext context) {
    final fontSize = 18.0;
    return Row(
      children: [
        Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),),
        Expanded(
          child: Container(),
        ),
        Text(text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: fontSize)),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}
