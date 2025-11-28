  import 'package:flutter/widgets.dart';

Widget headerText(String text) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }