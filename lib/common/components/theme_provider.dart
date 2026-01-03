import 'package:flutter/material.dart';
import 'package:ostinato/services/theme_service.dart';

/// InheritedWidget to provide ThemeService throughout the widget tree
class ThemeProvider extends InheritedNotifier<ThemeService> {
  const ThemeProvider({
    super.key,
    required ThemeService themeService,
    required super.child,
  }) : super(notifier: themeService);

  static ThemeService of(BuildContext context) {
    final ThemeProvider? provider = context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(provider != null, 'No ThemeProvider found in context');
    return provider!.notifier!;
  }

  /// Get ThemeService without subscribing to changes
  static ThemeService read(BuildContext context) {
    final ThemeProvider? provider = context.getInheritedWidgetOfExactType<ThemeProvider>();
    assert(provider != null, 'No ThemeProvider found in context');
    return provider!.notifier!;
  }
}
