import 'package:flutter/material.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/utils/utils.dart' as utils;

class CommonListOfModels extends StatelessWidget {
  final Stream<dynamic> stream;
  final Function onRefresh;
  final Widget Function(List<dynamic> item, int index) buildItemList;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CommonListOfModels(
      {@required this.stream,
      @required this.onRefresh,
      @required this.buildItemList,
      @required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data.item2 ?? [];

        final statusCode = snapshot.data.item1;

        if (statusCode != 200) {
          utils.showSnackBar(ctx, scaffoldKey.currentState, statusCode);
        }

        if (items.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              children: [
                Center(
                  child: Text(S.of(context).thereIsNoInformation),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: _buildListView(items),
        );
      },
    );
  }

  ListView _buildListView(List<dynamic> items) {
    return ListView.separated(
        itemCount: items.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) => buildItemList(items, i),
        separatorBuilder: (BuildContext context, int index) => Divider(
              thickness: 1.0,
            ));
  }
}
