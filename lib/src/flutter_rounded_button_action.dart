import 'package:flutter/material.dart';

class FlutterRoundedButtonAction extends StatelessWidget {
  final String? textButtonNegative;
  final String? textButtonPositive;
  final String? textActionButton;
  final VoidCallback? onTapButtonNegative; // Default is "Cancel" button.
  final VoidCallback? onTapButtonPositive; // Default is "OK" button.
  final VoidCallback?
      onTapButtonAction; // Default is "Action" button which will be on the left.
  final TextStyle? textStyleButtonAction;
  final TextStyle? textStyleButtonPositive;
  final TextStyle? textStyleButtonNegative;
  final MaterialLocalizations localizations;
  final double borderRadius;
  final EdgeInsets? paddingActionBar;
  final Color? background;

  const FlutterRoundedButtonAction(
      {Key? key,
      required this.localizations,
      this.textButtonNegative,
      this.textButtonPositive,
      this.textActionButton,
      this.onTapButtonAction,
      this.onTapButtonPositive,
      this.onTapButtonNegative,
      this.textStyleButtonPositive,
      this.textStyleButtonNegative,
      this.textStyleButtonAction,
      required this.borderRadius,
      this.paddingActionBar,
      this.background})
      : super(key: key);

  List<Widget> _buildActionsButton() {
    final Widget negativeButton = GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: 125,
          decoration: BoxDecoration(
            color: const Color(0xFF7FB7E2).withOpacity(0.05),
            borderRadius: BorderRadius.circular(90),
          ),
          child: Center(
            child: Text(
              textButtonNegative ?? localizations.cancelButtonLabel,
              style: textStyleButtonNegative,
            ),
          ),
        ),
        onTap: onTapButtonNegative);

    final Widget positiveButton = GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          width: 125,
          decoration: BoxDecoration(
            color: const Color(0xFF7FB7E2).withOpacity(0.10),
            borderRadius: BorderRadius.circular(90),
          ),
          child: Center(
            child: Text(
              textButtonPositive ?? localizations.okButtonLabel,
              style: textStyleButtonPositive,
            ),
          ),
        ),
        onTap: onTapButtonPositive);

    if (textActionButton != null) {
      final Widget leftButton = FlatButton(
        child: Text(textActionButton!, style: textStyleButtonAction),
        onPressed: onTapButtonAction,
      );
      return [
        leftButton,
        Row(children: <Widget>[negativeButton, positiveButton])
      ];
    }

    return [
      negativeButton,
      SizedBox(
        width: 20,
      ),
      positiveButton
    ];
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      padding: paddingActionBar,
      decoration: BoxDecoration(
          color: background,
          borderRadius: orientation == Orientation.landscape
              ? BorderRadius.only(bottomRight: Radius.circular(borderRadius))
              : BorderRadius.vertical(bottom: Radius.circular(borderRadius))),
      child: ButtonBar(
        alignment: textActionButton != null
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: _buildActionsButton(),
      ),
    );
  }
}
