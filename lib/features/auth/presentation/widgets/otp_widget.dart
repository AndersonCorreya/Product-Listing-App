import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:pinput/pinput.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';

class OtpInputWidget extends StatefulWidget {
  final int length;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;
  final String? errorText;
  final bool autoFocus;
  final TextEditingController? controller;

  const OtpInputWidget({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.onChanged,
    this.errorText,
    this.autoFocus = true,
    this.controller,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  late TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    _pinController = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // Define the pin theme to match your UI exactly
    final defaultPinTheme = PinTheme(
      width: 75,
      height: 58,
      textStyle: const TextStyle(
        fontSize: 24,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Light grey background
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: const [
          BoxShadow(
            offset: Offset(-2, -2),
            blurRadius: 4,
            color: Colors.white,
            inset: true,
          ),
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            color: Color(0xFFBEBEBE),
            inset: true,
          ),
        ],
      ),
    );

    // Theme for focused field
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-3, -3),
            blurRadius: 6,
            color: Colors.white,
            inset: true,
          ),
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 6,
            color: Color(0xFFBEBEBE),
            inset: true,
          ),
        ],
      ),
    );

    // Theme for submitted field
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-2, -2),
            blurRadius: 4,
            color: Colors.white,
            inset: true,
          ),
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            color: Color(0xFFBEBEBE),
            inset: true,
          ),
        ],
      ),
    );

    // Theme for error state
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-2, -2),
            blurRadius: 4,
            color: Colors.white,
            inset: true,
          ),
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            color: Color(0xFFBEBEBE),
            inset: true,
          ),
        ],
      ),
    );

    return Column(
      children: [
        Pinput(
          controller: _pinController,
          length: widget.length,
          autofocus: widget.autoFocus,
          defaultPinTheme: widget.errorText != null
              ? errorPinTheme
              : defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorPinTheme: errorPinTheme,
          showCursor: true,
          cursor: Container(
            width: 2,
            height: 24,
            decoration: BoxDecoration(
              color: widget.errorText != null
                  ? Colors.red[400]
                  : AppColors.blue,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          onCompleted: widget.onCompleted,
          onChanged: widget.onChanged,
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: TextStyle(color: Colors.red[400], fontSize: 12),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _pinController.dispose();
    }
    super.dispose();
  }
}

// Extension to add helper methods
extension OtpInputWidgetExtension on OtpInputWidget {
  /// Clear the OTP input
  void clear() {
    if (controller != null) {
      controller!.clear();
    }
  }

  /// Get current OTP value
  String get value {
    return controller?.text ?? '';
  }

  /// Check if OTP is complete
  bool get isComplete {
    return value.length == length;
  }
}
