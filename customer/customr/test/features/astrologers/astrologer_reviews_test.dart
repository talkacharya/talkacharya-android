import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:customr/src/features/astrologers/presentation/view/widgets/astrologer_reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

void main() {
  test('the profile reads its top reviews', () {
    final a = Astrologer.fromJson({
      'id': 'a1',
      'top_reviews': [
        {
          'id': 'r1',
          'rating': 5,
          'text': 'Very accurate',
          'customer_name': 'Rahul S.',
          'astrologer_reply': 'Thank you',
          'created_at': '2026-10-01T10:00:00Z',
        },
      ],
    });
    expect(a.topReviews.single.customerName, 'Rahul S.');
    expect(a.topReviews.single.rating, 5);
    expect(a.topReviews.single.createdAt, DateTime.utc(2026, 10, 1, 10));
  });

  testWidgets('a review shows its stars, words, reviewer and reply', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(extensions: const [BrandColors.light]),
        home: const Scaffold(
          body: ReviewTile(
            review: AstrologerReview(
              rating: 4,
              text: 'Helpful guidance',
              customerName: 'Priya',
              astrologerReply: 'Glad it helped',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Helpful guidance'), findsOneWidget);
    expect(find.text('Priya'), findsOneWidget);
    expect(find.text('Glad it helped'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));
    expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);
  });
}
