import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/programs_model.dart';

class ProgramItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProgramModel program = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            child: Column(
              children: [
                _titles(context, program),
                _roundedItems(context, program.id)
              ],
            ),
          )
        ],
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

  Widget _titles(BuildContext context, ProgramModel program) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(program.name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text('${S.of(context).labelTotalLines} ${program.totalLines}',
              style: TextStyle(color: Colors.white, fontSize: 30))
        ],
      ),
    ));
  }

  Widget _roundedItems(BuildContext context, int programId) {
    return Table(
      children: [
        TableRow(children: [
          _buildRoundedButton(context, Colors.blue, Icons.trip_origin,
              S.of(context).labelBaseParts, 'baseParts', programId),
          _buildRoundedButton(context, Colors.red, Icons.fiber_new,
              S.of(context).labelNewParts, 'newParts', programId)
        ]),
        TableRow(children: [
          _buildRoundedButton(context, Colors.purple, Icons.cached,
              S.of(context).labelReusableParts, 'reusableParts', programId),
          _buildRoundedButton(context, Colors.pink, Icons.bug_report,
              S.of(context).appBarTitleDefectLogs, 'defectLogs', programId)
        ]),
        TableRow(children: [
          _buildRoundedButton(context, Colors.green, Icons.timer,
              S.of(context).appBarTitleTimeLogs, 'timeLogs', programId),
          _buildRoundedButton(context, Colors.indigo, Icons.description,
              S.of(context).labelTestReports, '', programId)
        ]),
      ],
    );
  }

  Widget _buildRoundedButton(BuildContext context, Color color, IconData icon,
      String text, String routeName, int programId) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, routeName, arguments: programId),
      child: ClipRect(
          child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          height: 150,
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
      )),
    );
  }
}
