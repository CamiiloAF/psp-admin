import 'package:psp_admin/src/models/summary/program_summary_model.dart';
import 'package:psp_admin/src/repositories/program_summary_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ProgramSummaryBloc {
  final _programsSummaryRepository = ProgramSummaryRepository();

  final _programSummaryController =
      BehaviorSubject<Tuple2<int, List<ProgramSummaryModel>>>();

  Stream<Tuple2<int, List<ProgramSummaryModel>>> get programSummaryStream =>
      _programSummaryController.stream;

  Tuple2<int, List<ProgramSummaryModel>>
      get lastValueProgramSummaryController => _programSummaryController.value;

  void getProgramSummary(int programId) async {
    final programSummaryWithStatusCode =
        await _programsSummaryRepository.getProgramSummary(programId);
    _programSummaryController.sink.add(programSummaryWithStatusCode);
  }

  void dispose() => _programSummaryController.sink.add(null);
}
