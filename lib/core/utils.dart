import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

String getNameFromEmail(String email) {
  //developermalay@gmail.com --------> developermalay
  return email.split('@')[0];
}
