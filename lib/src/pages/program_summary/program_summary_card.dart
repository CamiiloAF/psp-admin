import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';

class ProgramSummaryCard extends StatelessWidget {
  final String title;
  final List<TableRow> items;

  const ProgramSummaryCard({this.title, this.items});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeChanger>(context).isDarkTheme;
    final tableBorderColor = (isDarkTheme) ? Colors.white : Colors.black;

    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          SizedBox(
            height: 20,
          ),
          Table(
            border: TableBorder(
                bottom: BorderSide(width: .2, color: tableBorderColor),
                horizontalInside: BorderSide(width: .2, color: tableBorderColor)),
            children: [...items],
          ),
        ]),
      ),
    );
  }
}
