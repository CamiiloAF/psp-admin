import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgramItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          buildBackButton(context),
          SingleChildScrollView(
            child: Column(
              children: [_titles(), _roundedItems()],
            ),
          )
        ],
      ),
    );
  }

  SafeArea buildBackButton(BuildContext context) {
    return SafeArea(
      child: Positioned(
        left: 0,
        child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 35,
            ),
            onPressed: () => Navigator.pop(context)),
      ),
    );
  }

  Widget _buildBackground() {
    final gradient = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.6),
              end: FractionalOffset(0.0, 1.0),
              colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0),
          ])),
    );

    final boxPink = Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360,
        width: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(236, 98, 188, 1.0),
              Color.fromRGBO(241, 148, 172, 1.0)
            ])),
      ),
    );

    return Stack(
      children: [
        gradient,
        Positioned(
          child: boxPink,
          top: -100,
        )
      ],
    );
  }

  Widget _titles() {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Titulo',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text('SUb Titulo',
              style: TextStyle(color: Colors.white, fontSize: 30))
        ],
      ),
    ));
  }

  Widget _roundedItems() {
    return Table(
      children: [
        TableRow(children: [
          _buildRoundedButton(Colors.blue, Icons.border_all, 'General'),
          _buildRoundedButton(Colors.blue, Icons.directions_bus, 'Bus')
        ])
      ],
    );
  }

  Widget _buildRoundedButton(Color color, IconData icon, String text) {
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        height: 180,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Color.fromRGBO(62, 66, 107, 0.7),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 5,
            ),
            CircleAvatar(
                backgroundColor: color,
                radius: 35,
                child: Icon(icon, color: Colors.white, size: 30)),
            Text(text, style: TextStyle(color: color)),
            SizedBox(height: 5),
          ],
        ),
      ),
    ));
  }
}
