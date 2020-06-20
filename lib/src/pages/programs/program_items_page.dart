import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/widgets/custom_app_bar.dart';

class ProgramItemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProgramModel program = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(context),
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    _buildAppBar(context),
                    _titles(context, program),
                    Expanded(child: Container()),
                    CustomPopupMenu(),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                _roundedItems(context, program.id)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;

    final gradient = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.1),
              end: FractionalOffset(0.0, 1.0),
              colors: [
            (isDarkTheme) ? Colors.white.withOpacity(0) : Color(0xFF78909c),
            Colors.black
          ])),
    );

    final box = Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360,
        width: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80),
            gradient: LinearGradient(colors: [
              (isDarkTheme) ? Colors.white.withOpacity(0.1) : Color(0xFFf4511e),
              (isDarkTheme)
                  ? Colors.white.withOpacity(0.5)
                  : Theme.of(context).accentColor
            ])),
      ),
    );

    return Stack(
      children: [
        gradient,
        Positioned(
          child: box,
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
          Text(
            '${S.of(context).labelLines} ${program.totalLines}',
            style: TextStyle(color: Colors.white, fontSize: 30),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ));
  }

  Widget _roundedItems(BuildContext context, int programId) {
    return Table(
      children: [
        TableRow(children: [
          _buildRoundedButton(context, Color(0xFFf4511e), Icons.trip_origin,
              S.of(context).appBarTitleBaseParts, 'baseParts', programId),
          _buildRoundedButton(context, Color(0xFFf4511e), Icons.fiber_new,
              S.of(context).appBarTitleNewParts, 'newParts', programId)
        ]),
        TableRow(children: [
          _buildRoundedButton(
              context,
              Color(0xFFf4511e),
              Icons.cached,
              S.of(context).appBarTitleReusableParts,
              'reusableParts',
              programId),
          _buildRoundedButton(context, Color(0xFFf4511e), Icons.bug_report,
              S.of(context).appBarTitleDefectLogs, 'defectLogs', programId)
        ]),
        TableRow(children: [
          _buildRoundedButton(context, Color(0xFFf4511e), Icons.timer,
              S.of(context).appBarTitleTimeLogs, 'timeLogs', programId),
          _buildRoundedButton(context, Color(0xFFf4511e), Icons.description,
              S.of(context).appBarTitleTestReports, 'testReports', programId)
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
              color: Colors.black.withOpacity(0.5),
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

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context))
      ],
    );
  }
}
