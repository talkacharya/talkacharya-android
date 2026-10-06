// The astrologer's own photos on their profile, as the customer sees them.
import 'package:customr/src/core/l10n/l10n.dart';
import 'package:customr/src/features/astrologers/data/models/astrologer.dart';
import 'package:customr/src/features/astrologers/presentation/view/widgets/astrologer_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

Widget _app(Widget child) => MaterialApp(
  theme: ThemeData(extensions: const [BrandColors.light]),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

const _photos = [
  AstrologerPhoto(image: 'https://example.com/a.jpg', caption: 'At Kashi'),
  AstrologerPhoto(image: 'https://example.com/b.jpg'),
  AstrologerPhoto(image: 'https://example.com/c.jpg', caption: 'Havan'),
];

void main() {
  test('the profile payload carries the gallery', () {
    final a = Astrologer.fromJson({
      'id': 'a1',
      'gallery': [
        {'image': 'https://example.com/a.jpg', 'caption': 'At Kashi'},
        {'image': 'https://example.com/b.jpg'},
      ],
    });
    expect(a.gallery, hasLength(2));
    expect(a.gallery.first.caption, 'At Kashi');
    expect(a.gallery.last.caption, '');
    // An older server, or a list row, simply has none.
    expect(Astrologer.fromJson({'id': 'a2'}).gallery, isEmpty);
  });

  testWidgets('no photos, no section', (tester) async {
    await tester.pumpWidget(_app(const AstrologerGallery(photos: [])));
    expect(find.text('Photos'), findsNothing);
  });

  testWidgets('thumbnails open a full-screen viewer that pages and captions', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const AstrologerGallery(photos: _photos)));
    await tester.pump();

    expect(find.text('Photos'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('At Kashi'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(GalleryViewer), findsOneWidget);
    expect(find.text('Photo 1 of 3'), findsOneWidget);
    expect(find.text('At Kashi'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Photo 2 of 3'), findsOneWidget);
    // The second photo has no caption, so none is drawn.
    expect(find.text('At Kashi'), findsNothing);
  });
}
