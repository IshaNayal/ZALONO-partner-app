import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Production-ready OTP input widget supporting auto-focus forward navigation,
/// backspace backward navigation, digit replacement, arrow-key navigation,
/// and paste support across mobile and desktop.
class ZalonoOtpInput extends StatefulWidget {
  final int length;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final VoidCallback? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool isExpanded;
  final double? boxWidth;
  final double boxHeight;

  const ZalonoOtpInput({
    super.key,
    this.length = 6,
    required this.controllers,
    required this.focusNodes,
    this.onChanged,
    this.onCompleted,
    this.isExpanded = false,
    this.boxWidth = 46,
    this.boxHeight = 52,
  });

  @override
  State<ZalonoOtpInput> createState() => _ZalonoOtpInputState();
}

class _ZalonoOtpInputState extends State<ZalonoOtpInput> {
  late List<String> _lastDigits;
  int _lastBackspaceMs = 0;

  @override
  void initState() {
    super.initState();
    _lastDigits = List.generate(
      widget.length,
      (i) => widget.controllers[i].text.replaceAll(RegExp(r'[^0-9]'), ''),
    );

    for (int i = 0; i < widget.focusNodes.length; i++) {
      final node = widget.focusNodes[i];
      node.addListener(_handleFocusChange);
      node.onKeyEvent = (node, event) => _handleKeyEvent(i, node, event);
    }
  }

  @override
  void didUpdateWidget(covariant ZalonoOtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (int i = 0; i < widget.length && i < widget.controllers.length; i++) {
      _lastDigits[i] =
          widget.controllers[i].text.replaceAll(RegExp(r'[^0-9]'), '');
    }
  }

  @override
  void dispose() {
    for (final node in widget.focusNodes) {
      node.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  KeyEventResult _handleKeyEvent(int index, FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (index > 0) {
          widget.focusNodes[index - 1].requestFocus();
        }
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (index < widget.length - 1) {
          widget.focusNodes[index + 1].requestFocus();
        }
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        _handleBackspace(index);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _handleBackspace(int index) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastBackspaceMs < 100) {
      return;
    }
    _lastBackspaceMs = now;

    if (widget.controllers[index].text.isNotEmpty ||
        _lastDigits[index].isNotEmpty) {
      // Case 1: Current input contains a digit
      // Delete the digit in current input. Keep focus on current input.
      _clearBox(index);
      widget.focusNodes[index].requestFocus();
      _notifyChange();
    } else {
      // Case 2: Current input is empty
      if (index > 0) {
        // Automatically move focus to previous input box.
        // Delete the digit in the previous box so user can correct it immediately.
        // Keep focus on that previous box.
        _clearBox(index - 1);
        widget.focusNodes[index - 1].requestFocus();
        _notifyChange();
      } else {
        // Case 3: The first input is empty
        // Focus must not move outside the OTP component, do nothing.
      }
    }
  }

  void _clearBox(int index) {
    _lastDigits[index] = '';
    widget.controllers[index].clear();
  }

  void _setBoxDigit(int index, String digit) {
    _lastDigits[index] = digit;
    widget.controllers[index].text = digit;
    widget.controllers[index].selection =
        const TextSelection.collapsed(offset: 1);
  }

  void _onInputChanged(int index, String val) {
    final digits = val.replaceAll(RegExp(r'[^0-9]'), '');

    // If text was cleared (e.g. via mobile soft keyboard backspace)
    if (digits.isEmpty) {
      _handleBackspace(index);
      return;
    }

    // Multiple digits entered (Paste or Digit Replacement)
    if (digits.length > 1) {
      final prev = _lastDigits[index];
      // If the box already held 1 digit and 1 new digit was typed (val length == 2):
      // This is a DIGIT REPLACEMENT!
      if (digits.length == 2 && prev.isNotEmpty) {
        final newDigit = (digits[0] == prev) ? digits[1] : digits[0];
        _setBoxDigit(index, newDigit);
        if (index < widget.length - 1) {
          widget.focusNodes[index + 1].requestFocus();
        }
        _notifyChange();
        return;
      }

      // Otherwise, user pasted a multi-digit OTP string
      _handlePaste(index, digits);
      return;
    }

    // Single digit entered
    _setBoxDigit(index, digits[0]);
    if (index < widget.length - 1) {
      widget.focusNodes[index + 1].requestFocus();
    }
    _notifyChange();
  }

  void _handlePaste(int startIndex, String digits) {
    final start = digits.length >= widget.length ? 0 : startIndex;
    for (int i = 0; i < digits.length && (start + i) < widget.length; i++) {
      _setBoxDigit(start + i, digits[i]);
    }
    final nextIndex = (start + digits.length).clamp(0, widget.length - 1);
    widget.focusNodes[nextIndex].requestFocus();
    _notifyChange();
  }

  void _notifyChange() {
    if (mounted) {
      setState(() {});
    }
    widget.onChanged?.call();
    final otp = widget.controllers.map((c) => c.text).join();
    if (otp.length == widget.length) {
      widget.onCompleted?.call(otp);
    }
  }

  Widget _buildBox(int index) {
    final isFocused = widget.focusNodes[index].hasFocus;
    final hasVal = widget.controllers[index].text.isNotEmpty ||
        _lastDigits[index].isNotEmpty;

    return Container(
      width: widget.boxWidth,
      height: widget.boxHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFocused
              ? ZalonoTheme.primary
              : (hasVal ? ZalonoTheme.textPrimary : ZalonoTheme.border),
          width: isFocused ? 1.8 : 1,
        ),
      ),
      child: TextField(
        controller: widget.controllers[index],
        focusNode: widget.focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        cursorColor: ZalonoTheme.primary,
        showCursor: true,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: ZalonoTheme.textPrimary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onTap: () {
          if (widget.controllers[index].text.isNotEmpty) {
            widget.controllers[index].selection = TextSelection(
              baseOffset: 0,
              extentOffset: widget.controllers[index].text.length,
            );
          }
        },
        onChanged: (val) => _onInputChanged(index, val),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isExpanded) {
      return SizedBox(
        width: double.infinity,
        height: widget.boxHeight,
        child: Row(
          children: List.generate(widget.length, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == widget.length - 1 ? 0 : 8,
                ),
                child: _buildBox(index),
              ),
            );
          }),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) => _buildBox(index)),
    );
  }
}
