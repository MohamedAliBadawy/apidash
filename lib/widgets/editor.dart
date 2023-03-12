import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apidash/consts.dart';

class TextFieldEditor extends StatefulWidget {
  const TextFieldEditor(
      {Key? key, required this.fieldKey, this.onChanged, this.initialValue})
      : super(key: key);

  final String fieldKey;
  final Function(String)? onChanged;
  final String? initialValue;
  @override
  State<TextFieldEditor> createState() => _TextFieldEditorState();
}

class _TextFieldEditorState extends State<TextFieldEditor> {
  final TextEditingController controller = TextEditingController();
  final editorFocusNode = FocusNode();
  final keyboardListnerFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void insertTab() {
    String sp = "    ";
    int offset = math.min(
        controller.selection.baseOffset, controller.selection.extentOffset);
    String text = controller.text.substring(0, offset) +
        sp +
        controller.text.substring(offset);
    controller.value = TextEditingValue(
      text: text,
      selection: controller.selection.copyWith(
        baseOffset: controller.selection.baseOffset + sp.length,
        extentOffset: controller.selection.extentOffset + sp.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    return RawKeyboardListener(
      focusNode: keyboardListnerFocusNode,
      onKey: (RawKeyEvent event) {
        if (event.runtimeType == RawKeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.tab)) {
          if (kIsWeb) {
            FocusScope.of(context).previousFocus();
          } else {
            editorFocusNode.requestFocus();
          }
          insertTab();
        }
      },
      child: TextFormField(
        key: Key(widget.fieldKey),
        controller: controller,
        focusNode: editorFocusNode,
        keyboardType: TextInputType.multiline,
        expands: true,
        maxLines: null,
        style: kCodeStyle,
        textAlignVertical: TextAlignVertical.top,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: "Enter content (body)",
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline.withOpacity(
                  kHintOpacity,
                ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(
                    kHintOpacity,
                  ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    keyboardListnerFocusNode.dispose();
    editorFocusNode.dispose();
    super.dispose();
  }
}