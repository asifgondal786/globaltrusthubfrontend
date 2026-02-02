import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:global_trust_hub/core/constants/colors.dart';

/// Custom Text Input Widget
/// Enhanced input field with label, icons, and validation support
class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? hintText; // Backwards compatibility
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final bool isPassword;
  final bool obscureText; // For password visibility toggle
  final bool isRequired;
  final bool enabled;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function()? onSuffixTap; // Callback for suffix icon tap
  final bool readOnly;

  const CustomInput({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconColor,
    this.isPassword = false,
    this.obscureText = false, // Default to not obscured
    this.isRequired = false,
    this.enabled = true,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.onTap,
    this.onSuffixTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with required indicator
        if (label != null) ...[
          Row(
            children: [
              Text(
                label!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        
        // Text Field
        TextFormField(
          controller: controller,
          obscureText: isPassword || obscureText,
          validator: validator ?? (isRequired ? _defaultValidator : null),
          keyboardType: keyboardType,
          maxLines: (isPassword || obscureText) ? 1 : maxLines,
          enabled: enabled,
          readOnly: readOnly,
          onChanged: onChanged,
          onTap: onTap,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: enabled ? Colors.black87 : Colors.grey[600],
          ),
          decoration: InputDecoration(
            hintText: hint ?? hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[400],
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: enabled ? AppColors.primary.withValues(alpha: 0.7) : Colors.grey[400],
                    size: 20,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(
                      suffixIcon,
                      color: suffixIconColor ?? AppColors.primary,
                      size: 20,
                    ),
                  )
                : null,
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  String? _defaultValidator(String? value) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }
    return null;
  }
}
