// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class msgNotification extends StatelessWidget {
  msgNotification({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
  });
  IconData icon;
  Color color;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              maxLines: 2,
            ),
          ),
          const Icon(
            Icons.close,
            color: Colors.white,
            size: 14,
          ),
        ],
      ),
    );
  }
}
