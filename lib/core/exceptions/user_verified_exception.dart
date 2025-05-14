import 'package:autism_empowering/core/services/router_manager.dart';
import 'package:autism_empowering/generated/app_localizations.dart';

class UserVerifiedException implements Exception {
  String message =
      AppLocalizations.of(RouterManager.navigatorKey.currentContext!)!
          .verify_email;
}
