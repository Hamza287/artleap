import 'package:Artleap.ai/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';

class AppCommonTextfield extends ConsumerStatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final ObsecureText? obsecureTextType;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool autoFocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final bool isDense;
  final EdgeInsetsGeometry? contentPadding;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? errorBorderColor;
  final String? errorText;

  const AppCommonTextfield({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obsecureTextType,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.validator,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.isDense = false,
    this.contentPadding,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.errorBorderColor,
    this.errorText,
  });

  @override
  ConsumerState<AppCommonTextfield> createState() => _AppCommonTextfieldState();
}

class _AppCommonTextfieldState extends ConsumerState<AppCommonTextfield> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final auth = ref.watch(authprovider);

    // Determine if text should be obscured
    bool obscure = false;
    if (widget.obsecureTextType == ObsecureText.loginPassword) {
      obscure = auth.loginPasswordHideShow;
    } else if (widget.obsecureTextType == ObsecureText.signupPassword) {
      obscure = auth.signupPasswordHideShow;
    } else if (widget.obsecureTextType == ObsecureText.confirmPassword) {
      obscure = auth.confirmPasswordHideShow;
    }

    // Theme-aware colors
    final backgroundColor = isDark
        ? theme.colorScheme.surface.withOpacity(0.8)
        : AppColors.white;

    final borderColor = _isFocused
        ? widget.focusedBorderColor ?? theme.colorScheme.primary
        : widget.enabledBorderColor ?? theme.colorScheme.outline.withOpacity(0.3);

    final hintColor = isDark
        ? theme.colorScheme.onSurface.withOpacity(0.5)
        : AppColors.black.withOpacity(0.5);

    final textColor = isDark
        ? theme.colorScheme.onSurface
        : AppColors.black;

    final iconColor = isDark
        ? theme.colorScheme.onSurface.withOpacity(0.7)
        : AppColors.black.withOpacity(0.7);

    final errorColor = widget.errorBorderColor ?? theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor,
            border: Border.all(
              color: widget.errorText != null ? errorColor : borderColor,
              width: _isFocused ? 1.5 : 1.0,
            ),
            boxShadow: _isFocused ? [
              BoxShadow(
                color: (widget.focusedBorderColor ?? theme.colorScheme.primary).withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obsecureTextType != null ? obscure : false,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            validator: widget.validator,
            autofocus: widget.autoFocus,
            enabled: widget.enabled,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              isDense: widget.isDense,
              contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: hintColor,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: widget.prefixIcon,
              )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              suffixIcon: _buildSuffixIcon(auth, iconColor, theme),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
            ),
          ),
        ),

        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: errorColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon(AuthProvider auth, Color iconColor, ThemeData theme) {
    // Custom suffix icon takes priority
    if (widget.suffixIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: widget.suffixIcon,
      );
    }

    // Password visibility toggle
    if (widget.obsecureTextType != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: IconButton(
          icon: Icon(
            _getVisibilityIcon(auth),
            color: iconColor,
            size: 20,
          ),
          onPressed: () {
            ref.read(authprovider).obsecureTextFtn(widget.obsecureTextType!);
          },
          splashRadius: 20,
          padding: EdgeInsets.zero,
        ),
      );
    }

    return null;
  }

  IconData _getVisibilityIcon(AuthProvider auth) {
    bool isObscured = false;

    if (widget.obsecureTextType == ObsecureText.loginPassword) {
      isObscured = auth.loginPasswordHideShow;
    } else if (widget.obsecureTextType == ObsecureText.signupPassword) {
      isObscured = auth.signupPasswordHideShow;
    } else if (widget.obsecureTextType == ObsecureText.confirmPassword) {
      isObscured = auth.confirmPasswordHideShow;
    }

    return isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined;
  }
}