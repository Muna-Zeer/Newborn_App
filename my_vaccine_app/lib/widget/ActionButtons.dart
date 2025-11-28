import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const ActionButtons({
    required this.onEdit,
    required this.onView,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEdit),
        IconButton(icon: const Icon(Icons.visibility, color: Colors.green), onPressed: onView),
        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
      ],
    );
  }
}
