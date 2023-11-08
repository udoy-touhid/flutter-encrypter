import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  BaseButton(
      {super.key,
      required this.onClick,
      this.iconVisible = true,
      this.fontSize = 16,
      this.buttonHeight = 48,
      this.buttonWidth = double.infinity,
      this.buttonLabel = "Continue",
      this.buttonColor,
      Color? textColorEnabled,
      Color? textColorDisabled,
      this.enabled = true}) {
    buttonColor ??= enabled ? Colors.green : Colors.grey.shade200;
    if (textColorEnabled == null) {
      textColor = enabled ? Colors.white : Colors.black12;
    } else {
      textColor = enabled ? textColorEnabled : textColorDisabled!;
    }
  }

  late bool iconVisible;
  late double fontSize;
  late double buttonHeight;
  late double buttonWidth;
  late Color? buttonColor;
  final String buttonLabel;
  final bool enabled;
  late Color textColor;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
          maximumSize: MaterialStateProperty.all(Size(buttonWidth, double.infinity)),
          padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(8)),
          foregroundColor: MaterialStateProperty.all<Color>(buttonColor!),
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor!),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ))),
      onPressed: enabled ? onClick : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(buttonLabel,
              style: TextStyle(fontSize: fontSize, color: textColor, fontWeight: FontWeight.w700)),
          const SizedBox(
            width: 12,
          ),
          Visibility(
              visible: iconVisible,
              child: Icon(Icons.upload))
        ],
      ),
    );
  }
}
