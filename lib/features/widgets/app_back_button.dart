import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final String assetPath;

  const AppBackButton({
    super.key,
    this.onTap,
    this.height = 46,
    this.width = 45,
    this.borderRadius = 12,
    this.margin,
    this.assetPath = 'assets/icons/back_arrow.svg',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(assetPath),
      ),
    );
  }
}
