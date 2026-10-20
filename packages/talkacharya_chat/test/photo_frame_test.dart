import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/src/widgets/message_bubble.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

void main() {
  ChatAttachment photo(int w, int h) =>
      ChatAttachment(id: 'a', width: w, height: h);

  test('a photo is boxed at its own shape before it loads', () {
    expect(PhotoFrame.sizeOf(photo(400, 300)), const Size(240, 180));
    // tall: capped by height, width follows the shape
    final tall = PhotoFrame.sizeOf(photo(300, 400));
    expect(tall.height, PhotoFrame.maxHeight);
    expect(tall.width, closeTo(210, 0.01));
  });

  test('odd shapes are kept sane, and an unknown one gets 4:5', () {
    final strip = PhotoFrame.sizeOf(photo(4000, 100));
    expect(strip.width / strip.height, closeTo(1.8, 0.001));
    final unknown = PhotoFrame.sizeOf(photo(0, 0));
    expect(unknown.width / unknown.height, closeTo(0.8, 0.001));
  });

  testWidgets('the box is the same size with or without the picture', (
    tester,
  ) async {
    final a = photo(400, 300);
    await tester.pumpWidget(
      Center(
        child: PhotoFrame(attachment: a, child: const SizedBox.shrink()),
      ),
    );
    expect(tester.getSize(find.byType(PhotoFrame)), const Size(240, 180));
  });
}
