
  import 'package:flutter/material.dart';
    Widget styledCell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey.shade900,
        ),
      ),
    );
  }