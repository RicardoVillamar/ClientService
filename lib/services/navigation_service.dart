import 'package:flutter/material.dart';
import '../view/widgets/flash_messages.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get currentContext => navigatorKey.currentContext;

  static Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  static void popUntil(String routeName) {
    return navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  static Future<T?> pushAndClearStack<T extends Object?>(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
    );
  }

  static void showFlashMessage(
    String message, {
    FlashMessageType type = FlashMessageType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = currentContext;
    if (context != null) {
      FlashMessages.show(
        context: context,
        message: message,
        type: type,
        duration: duration,
      );
    }
  }

  static void showErrorFlash(String message) {
    showFlashMessage(
      message,
      type: FlashMessageType.error,
      duration: const Duration(seconds: 4),
    );
  }

  static void showSuccessFlash(String message) {
    showFlashMessage(
      message,
      type: FlashMessageType.success,
    );
  }

  static void showWarningFlash(String message) {
    showFlashMessage(
      message,
      type: FlashMessageType.warning,
    );
  }

  static Future<bool?> showConfirmDialog(
    String title,
    String message, {
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) async {
    final context = currentContext;
    if (context == null) return false;

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}
