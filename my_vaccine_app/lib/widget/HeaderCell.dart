  import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget headerCell(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.swap_vert, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }