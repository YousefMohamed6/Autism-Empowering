import 'package:autism_empowering/View/puzzle_game/res/palette.dart';
import 'package:flutter/material.dart';

class NameField extends StatefulWidget {
  final FocusNode focusNode;
  final Function(String) onChange;

  const NameField({
    super.key,
    required this.focusNode,
    required this.onChange,
  });

  @override
  State<NameField> createState() => _NameFieldState();
}

class _NameFieldState extends State<NameField> {
  late final TextEditingController _nameTextController;
  late final FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _nameFocusNode = widget.focusNode;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _nameTextController,
      focusNode: _nameFocusNode,
      style: const TextStyle(
        fontSize: 24,
        color: Palette.crimson,
      ),
      cursorColor: Palette.violet,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Palette.violet,
            width: 3,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Palette.violet.withOpacity(0.5),
            width: 2,
          ),
        ),
        hintText: 'Enter your name',
        hintStyle: TextStyle(
          fontSize: 22,
          color: Palette.violet.withOpacity(0.2),
        ),
      ),
      onChanged: (value) => widget.onChange(value),
    );
  }
}
