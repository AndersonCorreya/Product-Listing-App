import 'package:flutter/material.dart';

enum AppButtonType { filled, outlined, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final bool expand;

  final Widget? leading;
  final Widget? trailing;

  // Style overrides
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final TextStyle? textStyle;
  final ButtonStyle? style; // Full style override if needed

  const AppButton({
    Key? key,
    this.label,
    required this.onPressed,
    this.type = AppButtonType.filled,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = false,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.width,
    this.elevation,
    this.textStyle,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle resolvedStyle = style ?? _buildStyle(context);
    final Widget content = _buildContent();

    final Widget buttonChild = switch (type) {
      AppButtonType.filled => ElevatedButton(
        onPressed: _effectiveOnPressed,
        style: resolvedStyle,
        child: content,
      ),
      AppButtonType.outlined => OutlinedButton(
        onPressed: _effectiveOnPressed,
        style: resolvedStyle,
        child: content,
      ),
      AppButtonType.text => TextButton(
        onPressed: _effectiveOnPressed,
        style: resolvedStyle,
        child: content,
      ),
    };

    if (expand) {
      return SizedBox(width: width ?? double.infinity, child: buttonChild);
    }
    return buttonChild;
  }

  VoidCallback? get _effectiveOnPressed =>
      (isEnabled && !isLoading) ? onPressed : null;

  ButtonStyle _buildStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final (
      EdgeInsetsGeometry basePadding,
      TextStyle baseTextStyle,
    ) = switch (size) {
      AppButtonSize.small => (
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        theme.textTheme.labelLarge ??
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      AppButtonSize.medium => (
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        theme.textTheme.titleSmall ??
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      AppButtonSize.large => (
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        theme.textTheme.titleMedium ??
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    };

    final ColorScheme colors = theme.colorScheme;

    final Color defaultBg = switch (type) {
      AppButtonType.filled => backgroundColor ?? colors.primary,
      AppButtonType.outlined => backgroundColor ?? Colors.transparent,
      AppButtonType.text => backgroundColor ?? Colors.transparent,
    };

    final Color defaultFg = switch (type) {
      AppButtonType.filled => foregroundColor ?? colors.onPrimary,
      AppButtonType.outlined => foregroundColor ?? colors.primary,
      AppButtonType.text => foregroundColor ?? colors.primary,
    };

    final Color disabledBg =
        disabledBackgroundColor ??
        defaultBg.withOpacity(type == AppButtonType.filled ? 0.38 : 0.0);
    final Color disabledFg =
        disabledForegroundColor ?? defaultFg.withOpacity(0.38);

    final BorderSide side = BorderSide(
      color:
          borderColor ??
          (type == AppButtonType.outlined
              ? (colors.outline)
              : Colors.transparent),
      width: borderWidth ?? (type == AppButtonType.outlined ? 1.2 : 0),
    );

    final double radius = borderRadius ?? 10;
    final double resolvedElevation =
        elevation ?? (type == AppButtonType.filled ? 1 : 0);

    return ButtonStyle(
      elevation: WidgetStateProperty.resolveWith<double?>((states) {
        if (states.contains(WidgetState.disabled)) return 0;
        return resolvedElevation;
      }),
      padding: WidgetStatePropertyAll(padding ?? basePadding),
      textStyle: WidgetStatePropertyAll((textStyle ?? baseTextStyle)),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) return disabledFg;
        return defaultFg;
      }),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.disabled)) return disabledBg;
        return defaultBg;
      }),
      side: WidgetStatePropertyAll(side),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? Colors.white,
          ),
        ),
      );
    }

    final List<Widget> rowChildren = [];

    if (leading != null) {
      rowChildren.add(
        Padding(padding: const EdgeInsets.only(right: 8), child: leading!),
      );
    }

    if (label != null) {
      rowChildren.add(
        Flexible(
          child: Text(label!, overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
      );
    }

    if (trailing != null) {
      rowChildren.add(
        Padding(padding: const EdgeInsets.only(left: 8), child: trailing!),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowChildren,
    );
  }
}
