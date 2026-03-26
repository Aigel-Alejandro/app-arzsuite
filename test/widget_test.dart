import 'package:app_arzsuite/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_arzsuite/features/auth/views/login_view.dart';
import 'package:app_arzsuite/core/providers/global_providers.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockDio extends Mock implements Dio {}
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();
  });

  testWidgets('Login screen two-step flow test', (WidgetTester tester) async {
    // Arrange
    when(() => mockApiClient.dio).thenReturn(mockDio);
    when(() => mockDio.post(any(), data: any(named: 'data'))).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: {
          'data': {'mock_code': '123456'}
        },
        statusCode: 200,
      ),
    );
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(mockApiClient),
        ],
        child: const MaterialApp(
          home: LoginView(),
        ),
      ),
    );

    // Step 1: Find the username field and the continue button
    expect(find.text('Número de Membresía'), findsOneWidget);
    expect(find.text('Continuar y Recibir Código'), findsOneWidget);
    expect(find.text('Código WhatsApp'), findsNothing);

    // Enter a username
    await tester.enterText(find.widgetWithText(TextFormField, 'Número de Membresía'), '123456');

    // Tap the continue button
    await tester.tap(find.text('Continuar y Recibir Código'));
    await tester.pump(); // Start loading
    await tester.pumpAndSettle(); // Wait for timers

    // Step 2: Find the code field and the login button
    expect(find.text('Número de Membresía'), findsNothing);
    expect(find.text('Código WhatsApp'), findsOneWidget);
    expect(find.text('Verificar e Iniciar Sesión'), findsOneWidget);

    // Check that the user number is displayed
    expect(find.text('123456'), findsOneWidget);
  });
}
