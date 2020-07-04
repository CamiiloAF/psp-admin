import 'package:psp_admin/src/models/defect_logs_model.dart';
import 'package:psp_admin/src/repositories/defect_logs_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class DefectLogsBloc {
  final _defectLogProvider = DefectLogsRepository();

  final _defectLogController =
      BehaviorSubject<Tuple2<int, List<DefectLogModel>>>();

  Stream<Tuple2<int, List<DefectLogModel>>> get defectLogStream =>
      _defectLogController.stream;

  Tuple2<int, List<DefectLogModel>> get lastValueDefectLogsController =>
      _defectLogController.value;

  void getDefectLogs(bool isRefreshing, int programId) async {
    final defectLogWithStatusCode =
        await _defectLogProvider.getAllDefectLogs(isRefreshing, programId);
    _defectLogController.sink.add(defectLogWithStatusCode);
  }

  void dispose() => _defectLogController.sink.add(null);
}
