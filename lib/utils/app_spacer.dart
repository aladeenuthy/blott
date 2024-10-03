import 'package:flutter/material.dart';

extension AppSpacer on int {
  Widget get heightSpace => SizedBox(height: toDouble());
  Widget get widthSpace => SizedBox(width: toDouble());
}