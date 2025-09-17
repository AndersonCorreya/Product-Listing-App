import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:product_listing_app/core/utils/responsive.dart';

class CustomSearchField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color? hintTextColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;

  const CustomSearchField({
    Key? key,
    this.hintText = 'Search',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.hintTextColor,
    this.textStyle,
    this.hintStyle,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      height: r.h(48),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(r.w(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: r.w(8),
            offset: Offset(0, r.h(2)),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textCapitalization: TextCapitalization.words,
        onTap: onTap,
        enabled: enabled,
        style:
            textStyle ?? TextStyle(fontSize: r.sp(16), color: Colors.black87),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              hintStyle ??
              TextStyle(
                fontSize: r.sp(16),
                color: hintTextColor ?? Colors.grey[700],
                fontWeight: FontWeight.normal,
              ),
          prefixIcon: prefixIcon,
          suffixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: r.w(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.light(
                  '|',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: r.sp(30),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: r.w(8)),
                SvgPicture.asset(
                  'assets/icons/search_icon.svg',
                  height: r.w(30),
                ),
              ],
            ),
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
              contentPadding ??
              EdgeInsets.symmetric(horizontal: r.w(16), vertical: r.h(12)),
        ),
      ),
    );
  }
}
