import 'package:flutter_test/flutter_test.dart';
import 'package:global_trust_hub/app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GlobalTrustHubApp());

    // Verify that the app title or key widgets are present.
    // For now, just checking it pumps without error.
  });
}
