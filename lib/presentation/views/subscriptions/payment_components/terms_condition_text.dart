import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Artleap.ai/shared/constants/app_textstyle.dart';

class TermsAndConditions extends StatefulWidget {
  final Function(bool?) onTermsChanged;
  final bool isAccepted;

  const TermsAndConditions({
    super.key,
    required this.onTermsChanged,
    required this.isAccepted,
  });

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _safeOnChanged(bool? value) {
    if (_isMounted) {
      widget.onTermsChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: widget.isAccepted ? theme.colorScheme.primary : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: widget.isAccepted ? theme.colorScheme.primary : theme.colorScheme.outline,
                width: 2,
              ),
            ),
            child: Checkbox(
              value: widget.isAccepted,
              onChanged: _safeOnChanged,
              activeColor: Colors.transparent,
              checkColor: theme.colorScheme.onPrimary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: 'I agree to the ',
                style: AppTextstyle.interRegular(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: AppTextstyle.interMedium(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (_isMounted) {
                          Navigator.pushNamed(context, '/terms-of-service');
                        }
                      },
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: AppTextstyle.interMedium(
                      fontSize: 14,
                      color: theme.colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        if (_isMounted) {
                          Navigator.pushNamed(context, '/privacy-policy');
                        }
                      },
                  ),
                  const TextSpan(text: '. I understand that payments will be charged to my selected payment method.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}