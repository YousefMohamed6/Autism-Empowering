import 'package:autism_empowering/core/services/one_Signal_service.dart';
import 'package:autism_empowering/core/services/sf_service.dart';

final class AppInitilizer {
  static Future<void> init() async {
    await SharedPreferencesService.init();
    await OneSignalService.initialize();
  }
}
