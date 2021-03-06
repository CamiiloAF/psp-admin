import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/pages/base_parts/base_parts_page.dart';
import 'package:psp_admin/src/pages/defect_logs/defect_logs_page.dart';
import 'package:psp_admin/src/pages/new_parts/new_parts_page.dart';
import 'package:psp_admin/src/pages/program_summary/program_summary_page.dart';
import 'package:psp_admin/src/pages/reusable_parts/reusable_parts_page.dart';
import 'package:psp_admin/src/pages/test_reports/test_reports_page.dart';
import 'package:psp_admin/src/pages/time_logs/time_logs_page.dart';
import 'package:psp_admin/src/utils/token_handler.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:psp_admin/src/widgets/custom_popup_menu.dart';
import 'package:psp_admin/src/widgets/not_authorized_screen.dart';

class ProgramItemsPage extends StatelessWidget {
  static const ROUTE_NAME = 'program-items';

  @override
  Widget build(BuildContext context) {
    if (!TokenHandler.existToken()) return NotAuthorizedScreen();

    final ProgramModel program = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(context),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 4, left: 4),
                  child: SafeArea(
                    child: Row(
                      children: [
                        _buildAppBar(context),
                        Expanded(child: Container()),
                        IconButton(
                          icon: Icon(
                            Icons.rate_review,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              _goToProgramSummary(context, program.id),
                        ),
                        CustomPopupMenu(),
                      ],
                    ),
                  ),
                ),
                _titles(context, program),
                SizedBox(
                  height: 10,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(program.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Text(
            '${S.of(context).labelLines} ${program.totalLines}',
            style: TextStyle(color: Colors.white, fontSize: 22),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  Widget _roundedItems(BuildContext context, int programId) {
    return Table(
      children: [
        TableRow(children: [
          _buildRoundedButton(
              context,
              Color(0xFFf4511e),
              Icons.trip_origin,
              S.of(context).appBarTitleBaseParts,
              BasePartsPage.ROUTE_NAME,
              programId),
          _buildRoundedButton(
              context,
              Color(0xFFf4511e),
              Icons.fiber_new,
              S.of(context).appBarTitleNewParts,
              NewPartsPage.ROUTE_NAME,
              programId)
        ]),
        TableRow(children: [
          _buildRoundedButton(
              context,
              Color(0xFFf4511e),
              Icons.cached,
              S.of(context).appBarTitleReusableParts,
              ReusablePartsPage.ROUTE_NAME,
              programId),
          _buildRoundedButton(
              context,
              Color(0xFFf4511e),
              Icons.bug_report,
              S.of(context).appBarTitleDefectLogs,
              DefectLogsPage.ROUTE_NAME,
              programId)
        ]),
        TableRow(children: [
          _buildRoundedButton(
              context,
              Color(0xFFf4511e),
              Icons.timer,
              S.of(context).appBarTitleTimeLogs,
              TimeLogsPage.ROUTE_NAME,
              programId),
          _buildRoundedButton(
              context,
              Color(0xFFf4511e),
              Icons.description,
              S.of(context).appBarTitleTestReports,
              TestReportsPage.ROUTE_NAME,
              programId)
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

  void _goToProgramSummary(BuildContext context, int programId) {
    Navigator.pushNamed(context, ProgramSummary.ROUTE_NAME,
        arguments: programId);
  }
}
