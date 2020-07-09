import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';

class LoginBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final backgroundColor = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        (Provider.of<ThemeChanger>(context).isDarkTheme)
            ? Colors.white.withOpacity(0)
            : Color(0xFF78909c),
        Theme.of(context).primaryColor
      ])),
    );

    final circle = Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05),
        ));

    return Stack(
      children: <Widget>[
        backgroundColor,
        Positioned(top: 90.0, left: 30.0, child: circle),
        Positioned(top: -40.0, right: -30.0, child: circle),
        Positioned(bottom: -50.0, right: -10.0, child: circle),
        Positioned(bottom: 120.0, right: 20.0, child: circle),
        Positioned(bottom: -50.0, left: -20.0, child: circle),
        SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Container(width: 200, height: 200, child: _buildLogo()),
                SizedBox(height: 10.0, width: double.infinity),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLogo() => (kIsWeb)
      ? Image.asset('assets/img/psp.png')
      : SvgPicture.asset('assets/svg/psp.svg');
}
