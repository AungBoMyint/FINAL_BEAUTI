import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String emptyText;
  final double? topPadding;
  const EmptyWidget(this.emptyText, {Key? key, this.topPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding ?? 0),
        child: Text(emptyText),
      ),
    );
  }
}
