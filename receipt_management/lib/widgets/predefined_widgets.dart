import 'package:flutter/material.dart';

Widget spacerSizedBox({double h = 0, double w = 0}) {
  return SizedBox(
    height: h,
    width: w,
  );
}

Widget greenLineBreak() {
  return Container(
    height: 0.5,
    color: const Color(0xff74F2C4),
  );
}
