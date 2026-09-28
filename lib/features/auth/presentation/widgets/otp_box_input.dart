import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Four individual, auto-advancing digit boxes with a shake animation for
/// a wrong code and a soft success pulse on verify. [value] is the
/// authoritative code (typically bloc state) — when it changes from
/// somewhere other than the user typing into these boxes (SMS autofill),
/// the boxes are filled to match. Manual typing keeps working as a
/// fallback regardless of whether autofill succeeds.
class OtpBoxInput extends StatefulWidget {
  final int length;
  final String value;
  final ValueChanged<String> onChanged;
  final bool shake;
  final bool success;
  final bool enabled;

  const OtpBoxInput({
    super.key,
    this.length = 4,
    required this.value,
    required this.onChanged,
    this.shake = false,
    this.success = false,
    this.enabled = true,
  });

  @override
  State<OtpBoxInput> createState() => _OtpBoxInputState();
}

class _OtpBoxInputState extends State<OtpBoxInput> with SingleTickerProviderStateMixin {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _applyExternalValue(widget.value);
  }

  String get _controllersText => _controllers.map((c) => c.text).join();

  void _applyExternalValue(String value) {
    for (var i = 0; i < widget.length; i++) {
      _controllers[i].text = i < value.length ? value[i] : '';
    }
    if (value.length >= widget.length) {
      FocusScope.of(context).unfocus();
    } else if (value.isNotEmpty) {
      _focusNodes[value.length].requestFocus();
    }
  }

  @override
  void didUpdateWidget(covariant OtpBoxInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      _shakeController.forward(from: 0);
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
    }
    if (!widget.enabled && oldWidget.enabled) {
      for (final c in _controllers) {
        c.clear();
      }
    }
    // A code arriving from somewhere other than these boxes (SMS
    // autofill) — reflect it visually. If it matches what's already
    // typed, this is a no-op and won't disturb the cursor.
    if (widget.value != oldWidget.value && widget.value != _controllersText) {
      _applyExternalValue(widget.value);
    }
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // A paste or platform autofill dropped more than one character into
      // a single box — treat it as the full code rather than losing it.
      final digits = value.replaceAll(RegExp(r'\D'), '');
      widget.onChanged(digits.length > widget.length ? digits.substring(0, widget.length) : digits);
      return;
    }

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    widget.onChanged(_controllersText);
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final t = _shakeController.value;
        final offset = (t == 0 || t == 1) ? 0.0 : (8 * (0.5 - (t * 4 % 1)).abs() * (t < 1 ? 1 : -1));
        return Transform.translate(offset: Offset(offset, 0), child: child);
      },
      child: AutofillGroup(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.success
                        ? AppColors.success
                        : widget.shake
                            ? AppColors.error
                            : (_focusNodes[index].hasFocus ? AppColors.primary : Colors.transparent),
                    width: 1.8,
                  ),
                ),
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  enabled: widget.enabled,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: widget.length,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  style: Theme.of(context).textTheme.headlineSmall,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => _onChanged(index, value),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
