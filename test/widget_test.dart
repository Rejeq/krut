import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:track_dev/main.dart';
import 'package:track_dev/providers/auth_providers.dart';
import 'package:track_dev/data/source/fake_local_datasource.dart';

void main() {
  testWidgets('App starts on LoginScreen when no token is cached', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localDataSourceProvider.overrideWithValue(FakeLocalDataSource()),
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


