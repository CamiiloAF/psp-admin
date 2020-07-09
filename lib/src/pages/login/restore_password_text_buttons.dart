import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/pages/login/restore_password_dialog.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';

class RestorePasswordTextButtons extends StatelessWidget {
  final sessionProvider;
  final scaffoldKey;

  const RestorePasswordTextButtons({this.sessionProvider, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;
    final s = S.of(context);

    final textStyle = TextStyle(
      color: (isDarkTheme)
          ? Colors.white.withOpacity(0.6)
          : Theme.of(context).primaryColor,
    );

    return Column(
      children: [
        GestureDetector(
          onTap: () => _showRestorePasswordDialog(context, true),
          child: Text(
            s.labelRestorePasswordByEmail,
            style: textStyle,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () => _showRestorePasswordDialog(context, false),
          child: Text(
            s.labelRestorePasswordByPhoneNumber,
            style: textStyle,
          ),
        ),
      ],
    );
  }

  void _showRestorePasswordDialog(BuildContext context, bool isByEmail) {
    showDialog(
        context: context,
        builder: (context) => RestorePasswordDialog(
            isByEmail: isByEmail,
            sessionProvider: sessionProvider,
            scaffoldKey: scaffoldKey));
  }
}
