import 'package:psp_admin/src/models/test_report_model.dart';
import 'package:psp_admin/src/repositories/test_reports_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class TestReportsBloc {
  final _testReportsProvider = TestReportsRepository();

  final _testReportsController =
      BehaviorSubject<Tuple2<int, List<TestReportModel>>>();

  Stream<Tuple2<int, List<TestReportModel>>> get testReportsStream =>
      _testReportsController.stream;

  Tuple2<int, List<TestReportModel>> get lastValueTestReportsController =>
      _testReportsController.value;

  void getTestReports(bool isRefresing, int programId) async {
    final testReportsWithStatusCode =
        await _testReportsProvider.getAllTestReports(isRefresing, programId);
    _testReportsController.sink.add(testReportsWithStatusCode);
  }

  void dispose() {
    _testReportsController.sink.add(null);
  }
}
