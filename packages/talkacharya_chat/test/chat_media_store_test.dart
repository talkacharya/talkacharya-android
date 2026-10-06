import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:talkacharya_chat/talkacharya_chat.dart';

void main() {
  late Directory root;
  late List<String> fetched;
  late DeviceChatMediaStore store;
  Object? failWith;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('chat_media_test');
    fetched = [];
    failWith = null;
    store = DeviceChatMediaStore(
      root: () async => root,
      download: (url, savePath) async {
        fetched.add(url);
        if (failWith != null) {
          // What a real client leaves behind when a transfer dies midway.
          await File(savePath).writeAsString('half');
          throw failWith!;
        }
        await File(savePath).writeAsString('bytes of $url');
      },
    );
  });

  tearDown(() async {
    if (await root.exists()) await root.delete(recursive: true);
  });

  const photo = ChatAttachment(
    id: 'a1',
    kind: 'image',
    contentType: 'image/jpeg',
    url: 'https://storage/a1?sig=x',
  );

  test('a photo is downloaded once and read off the disk after that', () async {
    final first = await store.fetch(photo);
    final second = await store.fetch(photo);

    expect(first, second);
    expect(first, endsWith('a1.jpg'));
    expect(await File(first).readAsString(), 'bytes of ${photo.url}');
    expect(fetched, hasLength(1));
  });

  test('it survives the app restarting — a new store finds the file', () async {
    await store.fetch(photo);
    final reopened = DeviceChatMediaStore(
      root: () async => root,
      download: (_, _) async => fail('must not download again'),
    );
    expect(await reopened.localFor(photo), isNotNull);
  });

  test('a signed URL that changes does not mean a second download', () async {
    // The server signs a fresh, time-limited URL on every read, so the id is
    // the key, never the URL.
    await store.fetch(photo);
    await store.fetch(photo.copyWith(url: 'https://storage/a1?sig=y'));
    expect(fetched, hasLength(1));
  });

  test('two bubbles asking at once share one download', () async {
    await Future.wait([store.fetch(photo), store.fetch(photo)]);
    expect(fetched, hasLength(1));
  });

  test('the sender keeps the file they picked and never downloads it', () async {
    final picked = File('${root.path}/picked.jpg')..writeAsStringSync('mine');
    await store.keep(photo, picked.path);

    final path = await store.fetch(photo);
    expect(await File(path).readAsString(), 'mine');
    expect(fetched, isEmpty);
    // A copy: the gallery's file is not ours to move.
    expect(picked.existsSync(), isTrue);
  });

  test('gone from the server and never downloaded says so', () async {
    const expired = ChatAttachment(id: 'a2', kind: 'image', available: false);
    expect(() => store.fetch(expired), throwsA(isA<MediaGone>()));
    expect(fetched, isEmpty);
  });

  test('gone from the server but already here still shows', () async {
    await store.fetch(photo);
    final path = await store.fetch(photo.copyWith(available: false, url: ''));
    expect(File(path).existsSync(), isTrue);
  });

  test('a download cut off halfway is never taken for the file', () async {
    failWith = const SocketException('dropped');
    await expectLater(store.fetch(photo), throwsA(isA<SocketException>()));
    expect(await store.localFor(photo), isNull);

    failWith = null;
    final path = await store.fetch(photo);
    expect(await File(path).readAsString(), 'bytes of ${photo.url}');
  });

  test('voice notes get an extension a player can sniff', () {
    expect(
      extensionFor(const ChatAttachment(id: 'v', kind: 'audio', contentType: 'audio/mp4')),
      '.m4a',
    );
    expect(extensionFor(const ChatAttachment(id: 'v', kind: 'audio')), '.m4a');
    expect(
      extensionFor(const ChatAttachment(id: 'p', name: 'IMG_1.PNG')),
      '.png',
    );
  });

  test('clear removes everything, for a sign-out on a shared phone', () async {
    await store.fetch(photo);
    await store.clear();
    expect(await store.localFor(photo), isNull);
  });
}
