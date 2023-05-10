import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

Widget customTableCell(String text) {
  return ResponsiveConstraints(
    constraintsWhen: const [
      Condition.smallerThan(
          name: DESKTOP,
          value: BoxConstraints(
            maxWidth: 100,
          ))
    ],
    child: Text(
      text,
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
