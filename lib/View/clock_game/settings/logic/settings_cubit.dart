import 'package:autism_empowering/View/clock_game/storage/storage_shared_preferences.dart';
import 'package:bloc/bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState()) {
    _readData();
  }

  final StorageSharedPreferences _storage = StorageSharedPreferences();

  Future<void> _readData() async {
    emit(
      SettingsState(
        isClockImageNumber: await _storage.getSettingsClockImage(),
        settingsPageChooseImage: await _storage.getSettingsClockImage(),
        selectedLanguage: await _storage.getSelectedLanguage(),
      ),
    );
  }

  void chooseImage(choose) {
    emit(state.copyWith(settingsPageChooseImage: choose));
  }

  Future<void> changeClockImage({required bool isClockImageNumber}) async {
    emit(
      state.copyWith(
        isClockImageNumber: isClockImageNumber,
      ),
    );
    await _storage.setSettingsClockImage(
      isClockImageNumber: isClockImageNumber,
    );
  }

  String clockImage() {
    if (state.isClockImageNumber!) {
      return 'assets/images/clock_numbers_turtle.png';
    } else {
      return 'assets/images/clock_turtle.png';
    }
  }

  Future<void> changeLanguage(String language) async {
    emit(state.copyWith(selectedLanguage: language));
    await _storage.setSelectedLanguage(language: language);
  }
}
