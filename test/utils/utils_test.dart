import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:psp_admin/generated/l10n.dart';
import 'package:psp_admin/src/utils/utils.dart' as utils;

class _MockS extends Mock implements S {}

void main() {
  group('Verify functionality of method getRequestResponseMessage', () {
    final messageNotConnection = 'Please check your internet connection';
    final message204 = 'Updated successfully';
    final message400 = 'Request created incorrectly';
    final message401 = 'Not authorized to request resources';
    final message403 = 'There are not enough permissions';
    final message500 = 'Internal server error';
    final messageUnexpectedError =
        'Has been occurred an unexpected error, try again';
    final messageTimeOutException =
        'The request took a long time, please try again';
    final messageEmailIsAlreadyInUse = 'Email is already in use';
    final messagePhoneIsAlreadyInUse = 'Phone is already in use';

    final mockS = _MockS();

    when(mockS.messageNotConnection).thenReturn(messageNotConnection);
    when(mockS.message204Update).thenReturn(message204);
    when(mockS.message400).thenReturn(message400);
    when(mockS.message401).thenReturn(message401);
    when(mockS.message403).thenReturn(message403);
    when(mockS.message500).thenReturn(message500);
    when(mockS.messageUnexpectedError).thenReturn(messageUnexpectedError);
    when(mockS.messageTimeOutException).thenReturn(messageTimeOutException);
    when(mockS.messagePhoneIsAlreadyInUse)
        .thenReturn(messagePhoneIsAlreadyInUse);
    when(mockS.messageEmailIsAlreadyInUse)
        .thenReturn(messageEmailIsAlreadyInUse);

    String getStatusCodeMessage(int statusCodeToTest) =>
        utils.getRequestResponseMessage(mockS, statusCodeToTest);

    test('getRequestResponseMessage with code 7', () {
      expect(getStatusCodeMessage(7), messageNotConnection);
    });

    test('getRequestResponseMessage with code 204', () {
      expect(getStatusCodeMessage(204), message204);
    });

    test('getRequestResponseMessage with code 400', () {
      expect(getStatusCodeMessage(400), message400);
    });

    test('getRequestResponseMessage with code 401', () {
      expect(getStatusCodeMessage(401), message401);
    });

    test('getRequestResponseMessage with code 403', () {
      expect(getStatusCodeMessage(403), message403);
    });

    test('getRequestResponseMessage with code 500', () {
      expect(getStatusCodeMessage(500), message500);
    });

    test('getRequestResponseMessage with code 503', () {
      expect(getStatusCodeMessage(503), messageUnexpectedError);
    });

    test('getRequestResponseMessage with code 1001', () {
      expect(getStatusCodeMessage(1001), messageTimeOutException);
    });

    test('getRequestResponseMessage with code 53', () {
      expect(getStatusCodeMessage(53), messagePhoneIsAlreadyInUse);
    });

    test('getRequestResponseMessage with code 54', () {
      expect(getStatusCodeMessage(54), messageEmailIsAlreadyInUse);
    });
  });

  group('Verify functionality of utils method that work with dates', () {
    var startDate = DateTime.now();
    var finishDate = DateTime.now();

    test(
        'Test method that calculate difference between two dates with '
        'finishDate greater than startDate', () {
      final difference = utils.getMinutesBetweenTwoDates(
          startDate, finishDate.add(Duration(minutes: 60)));

      expect(difference, 60);
    });

    test(
        'Test method that calculate difference between two dates with'
        'startDate greater than finishDate', () {
      final difference = utils.getMinutesBetweenTwoDates(
          startDate.add(Duration(minutes: 30)), finishDate);

      expect(difference, -30);
    });

    test(
        'Test method that calculate difference between two dates'
        'with startDate in null', () {
      final difference = utils.getMinutesBetweenTwoDates(null, finishDate);

      expect(difference, null);
    });

    test(
        'Test method that calculate difference between two dates'
        'with finishDate in null', () {
      final difference = utils.getMinutesBetweenTwoDates(startDate, null);

      expect(difference, null);
    });

    test(
        'Test method that calculate difference between two dates '
        'with both dates in null', () {
      final difference = utils.getMinutesBetweenTwoDates(null, null);

      expect(difference, null);
    });
  });

  group('Verify functionality of method isNullOrEmpty', () {
    test('Call method and in the parameters send null', () {
      expect(utils.isNullOrEmpty(null), true);
    });

    test('Call method and in the parameters send a empty list', () {
      expect(utils.isNullOrEmpty([]), true);
    });

    test('Call method and in the parameters send list with two items', () {
      expect(utils.isNullOrEmpty(['One', 'Two']), false);
    });
  });
}
