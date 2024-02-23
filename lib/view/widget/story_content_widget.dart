import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class StoryContentWidget extends StatelessWidget {
  final String text;

  const StoryContentWidget({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      child: MarkdownBody(
        selectable: true,
        data: text,
      ),
    );
  }
}
