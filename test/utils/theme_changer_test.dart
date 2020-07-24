import 'package:mockito/mockito.dart';
import 'package:psp_admin/src/shared_preferences/shared_preferences.dart';
import 'package:psp_admin/src/utils/theme/theme_changer.dart';
import 'package:test/test.dart';

class _MockPreferences extends Mock implements Preferences {}

void main() {

  group('Verify functionality of ThemeChanger class', (){
    final preferences = _MockPreferences();

    test('Call isDarkTheme when Preference.theme let 1', () {
      when(preferences.theme).thenReturn(1);
      final themeChanger = ThemeChanger(preferences);
      expect(themeChanger.isDarkTheme, isFalse);
    });

    test('Call isDarkTheme when Preference.theme let 2', () {
      when(preferences.theme).thenReturn(2);
      final themeChanger = ThemeChanger(preferences);
      expect(themeChanger.isDarkTheme, isTrue);
    });



  });

}
