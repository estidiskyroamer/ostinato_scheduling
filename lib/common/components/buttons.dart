import 'package:flutter/material.dart';
import 'package:ostinato/common/components/theme_extension.dart';
import 'package:ostinato/common/config.dart';

class OutlineButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const OutlineButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, color: Theme.of(context).extension<OstinatoThemeExtension>()!.buttonBackgroundColor)),
          padding: padding8),
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 3,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

class StyledTextButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const StyledTextButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 4,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium),
      ),
    );
  }
}

class RowIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const RowIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: padding16,
          margin: padding8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).extension<OstinatoThemeExtension>()!.rowIconColor
          ),
          child: Column(
            children: [
              Icon(
                icon,
              ),
              Padding(
                padding: padding4,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SolidButton extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const SolidButton({super.key, required this.action, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).extension<OstinatoThemeExtension>()!.buttonBackgroundColor,
          shape: const LinearBorder(),
          padding: padding8),
      onPressed: action,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 3,
            maxWidth: MediaQuery.of(context).size.width),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .merge(TextStyle(color: Theme.of(context).extension<OstinatoThemeExtension>()!.buttonForegroundColor)),
        ),
      ),
    );
  }
}
