import 'package:flutter/material.dart';

mixin TimeInPhaseMixinWithDefects {
  int calculateTotal(List<int> items) {
    var total = 0;

    items.forEach((item) {
      if(item == null){
        total = null;
        return null;
      }
        total += item;
    });

    return total;
  }

  TableRow buildTableRow(String label, {dynamic planned, dynamic current,
      dynamic toDate, dynamic percent}) {
    return TableRow(children: [
      _buildTableRowItem(
        padding: EdgeInsets.only(left: 8, top: 5),
        child: Text(label ?? '', overflow: TextOverflow.ellipsis),
      ),
      if (planned != null)
        _buildTableRowItem(
          child: Center(
              child: Text(
            '$planned',
            overflow: TextOverflow.ellipsis,
          )),
        ),
      _buildTableRowItem(
        child: Center(
            child: Text(
          '$current',
          overflow: TextOverflow.ellipsis,
        )),
      ),
      if (toDate != null)
        _buildTableRowItem(
          child: Center(
              child: Text(
            '$toDate',
            overflow: TextOverflow.ellipsis,
          )),
        ),
      if (percent != null)
        _buildTableRowItem(
            child: Center(
                child: Text(
          '$percent',
          overflow: TextOverflow.ellipsis,
        )))
    ]);
  }

  Widget _buildTableRowItem(
      {EdgeInsets padding = const EdgeInsets.all(5), Widget child}) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
