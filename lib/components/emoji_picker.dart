// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

class EmojiPickerWidget extends StatelessWidget {
  final ValueChanged<String> onEmojiSelected;

  const EmojiPickerWidget({
    Key? key,
    required this.onEmojiSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => EmojiPicker(
        rows: 5,
        columns: 7,
        onEmojiSelected: (emoji, category) => onEmojiSelected(emoji.emoji),
      );
}
