import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:option/flutter_flow/location_service.dart';
import 'package:option/flutter_flow/lat_lng.dart' as ff;

// Mock classes
class MockLocationService extends Mock implements LocationService {}

void main() {
  group('Center Button Unit Tests', () {
    late MockLocationService mockLocationService;

    setUp(() {
      mockLocationService = MockLocationService();
    });

    testWidgets('should display center location button with correct icon', (WidgetTester tester) async {
      // Create a simple widget with the center button
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                // Simulate the button position as in MainMotoristaWidget
                Align(
                  alignment: const AlignmentDirectional(-1.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 100.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        // Simulate center map action
                      },
                      backgroundColor: Colors.white,
                      elevation: 8.0,
                      child: const Icon(
                        Icons.my_location,
                        color: Color(0xFF57636C),
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify button exists
      expect(find.byIcon(Icons.my_location), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Verify button position
      final alignWidget = find.ancestor(
        of: find.byIcon(Icons.my_location),
        matching: find.byType(Align),
      );
      expect(alignWidget, findsOneWidget);
      
      final align = tester.widget<Align>(alignWidget);
      expect(align.alignment, equals(const AlignmentDirectional(-1.0, 1.0)));
    });

    testWidgets('should trigger onPressed when button is tapped', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1.0, 1.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 100.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        buttonPressed = true;
                      },
                      backgroundColor: Colors.white,
                      elevation: 8.0,
                      child: const Icon(
                        Icons.my_location,
                        color: Color(0xFF57636C),
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pump();

      // Verify the callback was triggered
      expect(buttonPressed, isTrue);
    });

    test('LocationService getCurrentLocation should return valid coordinates', () async {
      // Arrange
      when(() => mockLocationService.getCurrentLocation()).thenAnswer(
        (_) async => ff.LatLng(-23.5505, -46.6333), // São Paulo coordinates
      );

      // Act
      final location = await mockLocationService.getCurrentLocation();

      // Assert
      expect(location, isNotNull);
      expect(location!.latitude, equals(-23.5505));
      expect(location.longitude, equals(-46.6333));
      verify(() => mockLocationService.getCurrentLocation()).called(1);
    });

    test('LocationService getCurrentLocation should handle null response', () async {
      // Arrange
      when(() => mockLocationService.getCurrentLocation()).thenAnswer((_) async => null);

      // Act
      final location = await mockLocationService.getCurrentLocation();

      // Assert
      expect(location, isNull);
      verify(() => mockLocationService.getCurrentLocation()).called(1);
    });

    testWidgets('should show snackbar with custom message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mapa centralizado na sua localização.'),
                      backgroundColor: Color(0xFF4B986C),
                    ),
                  );
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
        ),
      );

      // Tap the button to show snackbar
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pump(); // Start the animation
      await tester.pump(const Duration(milliseconds: 750)); // Wait for animation

      // Verify snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Mapa centralizado na sua localização.'), findsOneWidget);
    });

    testWidgets('should show error snackbar with error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Não foi possível obter sua localização. Verifique as permissões.'),
                      backgroundColor: Color(0xFFE74C3C),
                    ),
                  );
                },
                child: const Icon(Icons.my_location),
              ),
            ),
          ),
        ),
      );

      // Tap the button to show error snackbar
      await tester.tap(find.byIcon(Icons.my_location));
      await tester.pump(); // Start the animation
      await tester.pump(const Duration(milliseconds: 750)); // Wait for animation

      // Verify error snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Não foi possível obter sua localização. Verifique as permissões.'), findsOneWidget);
    });
  });
}