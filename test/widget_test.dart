import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/main.dart';
import 'package:track_dev/providers/sources_provider.dart';
import 'package:track_dev/data/source/local/local_storage_source.dart';

class FakeLocalStorageSource implements LocalStorageSource {
  final Map<String, String> _store = {};

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> clear(String key) async {
    _store.remove(key);
  }
}

void main() {
  testWidgets('App starts on LoginScreen when no token is cached', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageSourceProvider.overrideWithValue(FakeLocalStorageSource()),
        ],
        child: const MyApp(),
      ),
    );

    // Pump to let the future complete and rebuild from loading state
    await tester.pumpAndSettle();

    // Verify LoginScreen components are shown
    expect(find.text('Войти'), findsOneWidget);
    expect(find.text('Имя пользователя'), findsOneWidget);
    expect(find.text('Пароль'), findsOneWidget);
  });
}
