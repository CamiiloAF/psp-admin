import 'package:psp_admin/src/utils/utils.dart' as utils;

mixin DateValidator {
  bool isValidDifferenceBetweenTwoDates(
      int planningDateInMilliSeconds, int startDateInMilliSeconds) {
    final planningDate =
        DateTime.fromMillisecondsSinceEpoch(planningDateInMilliSeconds);

    final startDate =
        DateTime.fromMillisecondsSinceEpoch(startDateInMilliSeconds);

    return utils.isValidDates(planningDate, startDate);
  }

  bool isValidDifferenceBetweenThreeDates(int planningDateInMilliseconds,
      int startDateInMilliseconds, int finishDateInMilliseconds) {
    final planningDate =
        DateTime.fromMillisecondsSinceEpoch(planningDateInMilliseconds);
    final startDate = (startDateInMilliseconds != null)
        ? DateTime.fromMillisecondsSinceEpoch(startDateInMilliseconds)
        : null;
    final finishDate = (finishDateInMilliseconds != null)
        ? DateTime.fromMillisecondsSinceEpoch(finishDateInMilliseconds)
        : null;

    if (startDate != null && !utils.isValidDates(planningDate, startDate)) {
      return false;
    }

    if (startDate != null &&
        finishDate != null &&
        !utils.isValidDates(startDate, finishDate)) return false;

    if (finishDate != null && !utils.isValidDates(planningDate, finishDate)) {
      return false;
    }

    return true;
  }
}
