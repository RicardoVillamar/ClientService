import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';

enum FlashMessageType { success, warning, info, error }

class FlashMessages {
  static void show({
    required BuildContext context,
    required String message,
    required FlashMessageType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case FlashMessageType.success:
        backgroundColor = AppColors.flashSuccess;
        textColor = AppColors.colorSuccess;
        icon = Icons.check_circle;
        break;
      case FlashMessageType.error:
        backgroundColor = AppColors.flashError;
        textColor = AppColors.whiteColor;
        icon = Icons.error;
        break;
      case FlashMessageType.warning:
        backgroundColor = AppColors.flashWarning;
        textColor = AppColors.blackColor;
        icon = Icons.warning;
        break;
      case FlashMessageType.info:
        backgroundColor = AppColors.flashInfo;
        textColor = AppColors.whiteColor;
        icon = Icons.info;
        break;
    }

    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          position: FlashPosition.top,
          child: FlashBar(
            controller: controller,
            backgroundColor: backgroundColor,
            content: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Convenience methods for each type
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: FlashMessageType.success,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      type: FlashMessageType.error,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: FlashMessageType.warning,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: FlashMessageType.info,
      duration: duration,
    );
  }
}
