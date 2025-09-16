import 'package:flutter/material.dart';

enum AppTextType { heading, title, body, caption, light }

class AppText extends StatelessWidget {
  final String data;
  final AppTextType type;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextStyle? style; // additional custom overrides

  const AppText(
    this.data, {
    Key? key,
    this.type = AppTextType.body,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.style,
  }) : super(key: key);

  const AppText.heading(
    this.data, {
    Key? key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.style,
  }) : type = AppTextType.heading,
       super(key: key);

  const AppText.light(
    this.data, {
    Key? key,
    this.textAlign,
    this.color,
    this.maxLines,
    this.overflow,
    this.style,
  }) : type = AppTextType.light,
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle resolved = _resolveStyle(context).merge(style);
    return Text(
      data,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: color != null ? resolved.copyWith(color: color) : resolved,
    );
  }

  TextStyle _resolveStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    switch (type) {
      case AppTextType.heading:
        // Oxygen Bold, large size for main headings
        return (theme.textTheme.headlineMedium ?? const TextStyle(fontSize: 28))
            .copyWith(fontWeight: FontWeight.w700, fontFamily: 'Oxygen');
      case AppTextType.title:
        return (theme.textTheme.titleMedium ?? const TextStyle(fontSize: 18))
            .copyWith(fontWeight: FontWeight.w600);
      case AppTextType.body:
        return (theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14));
      case AppTextType.caption:
        return (theme.textTheme.bodySmall ?? const TextStyle(fontSize: 12))
            .copyWith(color: Colors.grey[600]);
      case AppTextType.light:
        return (theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14))
            .copyWith(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w300,
              color: const Color(0xFF4E4D4D),
            );
    }
  }
}
