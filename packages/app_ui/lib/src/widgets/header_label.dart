// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class HeaderLabel extends StatelessWidget {
  const HeaderLabel(this.content, {super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}
