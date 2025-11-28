
  import 'package:flutter/widgets.dart';

Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }

