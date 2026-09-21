import 'dart:async';
import 'dart:io';

import 'package:customr/src/core/l10n/api_error_l10n.dart';
import 'package:customr/src/core/l10n/gen/app_localizations.dart';
import 'package:customr/src/core/network/api_exception.dart';
import 'package:customr/src/core/network/friendly_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

ApiException _api(int status, {String message = '', String? code}) =>
    ApiException(
      message: message.isEmpty ? 'Request failed ($status).' : message,
      statusCode: status,
      code: code,
      fromServer: message.isNotEmpty,
    );

void main() {
  setUp(() => showErrorDetails = false);
  tearDown(() => showErrorDetails = false);

  group('production never shows technical text', () {
    test('a server placeholder is replaced by a sentence', () {
      expect(
        friendlyError(_api(400)),
        'Something went wrong. Please try again.',
      );
      expect(
        friendlyError(_api(500)),
        startsWith('Our server ran into a problem'),
      );
      expect(friendlyError(_api(404)), startsWith("We couldn't find this"));
      expect(friendlyError(_api(429)), startsWith("You're going a bit fast"));
      expect(friendlyError(_api(401)), startsWith('Please sign in again'));
    });

    test('a 500 body is never surfaced, however chatty the server was', () {
      final e = _api(
        500,
        message: 'IntegrityError at /api/v1/wallet: null value',
      );
      expect(friendlyError(e), isNot(contains('IntegrityError')));
    });

    test('type and parser failures collapse to the generic line', () {
      for (final error in <Object>[
        TypeError(),
        const FormatException('Unexpected character'),
        ArgumentError('bad'),
        StateError('no element'),
      ]) {
        final text = friendlyError(error);
        expect(text, 'Something went wrong. Please try again.');
        expect(text, isNot(contains(error.runtimeType.toString())));
      }
    });

    test('interpolating the exception itself stays human', () {
      final e = _api(500, message: 'Traceback (most recent call last)');
      expect('$e', isNot(contains('ApiException')));
      expect('$e', startsWith('Our server ran into a problem'));
    });

    test('connectivity and timeouts are explained, not dumped', () {
      expect(
        friendlyError(const SocketException('failed host lookup')),
        'Could not reach the server. Check your connection.',
      );
      expect(
        friendlyError(TimeoutException('after 30s')),
        startsWith('The server took too long'),
      );
      final dio = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionError,
      );
      expect(friendlyError(dio), isNot(contains('DioException')));
    });
  });

  group('the backend still speaks for itself', () {
    test('a 4xx detail written for users is surfaced verbatim', () {
      final e = _api(400, message: 'Your wallet balance is too low for this.');
      expect(friendlyError(e), 'Your wallet balance is too low for this.');
    });

    test('a detail parsed from the body is marked as the server\'s', () {
      final e = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 400,
            data: {
              'code': 'promo.not_redeemable',
              'detail': "This coupon can't be used.",
            },
          ),
        ),
      );
      expect(e.fromServer, isTrue);
      expect(friendlyError(e), "This coupon can't be used.");
    });

    test('a body with no usable detail is not trusted', () {
      final e = ApiException.fromDio(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 400,
            data: '<html><body>Bad Request</body></html>',
          ),
        ),
      );
      expect(e.fromServer, isFalse);
      expect(friendlyError(e), 'Something went wrong. Please try again.');
    });
  });

  group('development keeps the detail', () {
    setUp(() => showErrorDetails = true);

    test('the sentence comes first, the detail after it', () {
      final text = friendlyError(_api(500, message: 'IntegrityError: boom'));
      expect(text, startsWith('Our server ran into a problem'));
      expect(text, contains('[dev]'));
      expect(text, contains('IntegrityError: boom'));
    });

    test('an unknown error names its type', () {
      expect(
        friendlyError(const FormatException('bad json')),
        contains('FormatException'),
      );
    });
  });

  group('localized', () {
    test('known codes are translated', () async {
      final hi = await AppLocalizations.delegate.load(const Locale('hi'));
      final en = await AppLocalizations.delegate.load(const Locale('en'));
      final e = _api(400, code: 'wallet.insufficient_balance');

      expect(localizedErrorFor(en, e), en.errWalletInsufficient);
      expect(localizedErrorFor(hi, e), hi.errWalletInsufficient);
      expect(localizedErrorFor(hi, e), isNot(en.errWalletInsufficient));
    });

    test(
      'status codes fall back to localized lines, not to the body',
      () async {
        final hi = await AppLocalizations.delegate.load(const Locale('hi'));
        expect(
          localizedErrorFor(hi, _api(500, message: 'KeyError')),
          hi.errServer,
        );
        expect(
          localizedErrorFor(hi, _api(403, message: 'Forbidden.')),
          hi.errForbidden,
        );
        expect(localizedErrorFor(hi, _api(404)), hi.errNotFound);
        expect(localizedErrorFor(hi, TypeError()), hi.errGeneric);
      },
    );
  });
}
