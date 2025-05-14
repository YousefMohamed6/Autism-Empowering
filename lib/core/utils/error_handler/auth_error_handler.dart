import 'package:autism_empowering/core/services/router_manager.dart';
import 'package:autism_empowering/generated/app_localizations.dart';
import 'package:flutter/material.dart';

sealed class AuthErrorHandler {
  static String getErrorMessage({
    required String errorMessage,
  }) {
    final BuildContext context = RouterManager.navigatorKey.currentContext!;
    switch (errorMessage) {
      case "user-not-found":
        return AppLocalizations.of(context)!.userNotFound;
      case "weak-password":
        return AppLocalizations.of(context)!.weakPassword;
      case "email-already-in-use":
        return AppLocalizations.of(context)!.emailAlreadyInUse;
      case "invalid-credential":
        return AppLocalizations.of(context)!.invalidEmailorPassword;
      case "invalid-email":
        return AppLocalizations.of(context)!.invalidEmail;
      case "network-request-failed":
        return AppLocalizations.of(context)!.networkRequestFailed;
      default:
        return AppLocalizations.of(context)!.somethingWentWrong;
    }
  }
}
