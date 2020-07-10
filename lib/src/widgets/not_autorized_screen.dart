import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/pages/login/login_page.dart';
import 'package:psp_admin/src/widgets/buttons_widget.dart';

class NotAutorizedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PSP'),
        ),
        body: (kIsWeb)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).titleNotAutorized,
                      style: TextStyle(fontSize: 35.0),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    CustomRaisedButton(
                        buttonText: S.of(context).loginButton,
                        onPress: () => Navigator.pushNamedAndRemoveUntil(
                            context, LoginPage.ROUTE_NAME, (route) => false))
                  ],
                ),
              )
            : Container());
  }
}
