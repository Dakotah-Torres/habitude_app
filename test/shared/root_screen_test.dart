import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/shared/root_screen.dart';
import 'package:habitude/features/goals/screens/goals_list_screen.dart';
import 'package:habitude/features/triage/screens/brain_dump_screen.dart';
import 'package:habitude/shared/theme.dart';
import 'package:habitude/shared/auth_repository.dart';

void main() {
  testWidgets('RootScreen show Goals tab by default', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserIdProvider.overrideWithValue('test'),
          // Need to override streams used in screens
          // (mocking them as empty for now)
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const RootScreen(),
        ),
      ),
    );

    expect(find.byType(GoalsListScreen), findsOneWidget);
    expect(find.byType(BrainDumpScreen), findsNothing);
  });

  testWidgets('RootScreen switches to Dump tab', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserIdProvider.overrideWithValue('test'),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const RootScreen(),
        ),
      ),
    );

    await tester.tap(find.text('Dump'));
    await tester.pumpAndSettle();

    expect(find.byType(BrainDumpScreen), findsOneWidget);
  });
}
