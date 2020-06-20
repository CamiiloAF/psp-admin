import 'package:psp_admin/src/models/time_logs_model.dart';
import 'package:psp_admin/src/repositories/time_logs_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class TimeLogsBloc {
  final _timeLogProvider = TimeLogsRepository();

  final _timeLogController = BehaviorSubject<Tuple2<int, List<TimeLogModel>>>();

  Stream<Tuple2<int, List<TimeLogModel>>> get timeLogStream =>
      _timeLogController.stream;

  Tuple2<int, List<TimeLogModel>> get lastValueTimeLogsController =>
      _timeLogController.value;

  void getTimeLogs(bool isRefresing, int programId) async {
    final timeLogWithStatusCode =
        await _timeLogProvider.getAllTimeLogs(isRefresing, programId);
    _timeLogController.sink.add(timeLogWithStatusCode);
  }

  void dispose() {
    _timeLogController.sink.add(null);
  }
}
