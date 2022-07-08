// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

class JumboLabel extends StatelessWidget {
  const JumboLabel(this.content, {super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
