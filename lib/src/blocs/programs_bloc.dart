import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/repositories/programs_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ProgramsBloc {
  final _programsProvider = ProgramsRepository();

  final _programsController =
      BehaviorSubject<Tuple2<int, List<ProgramModel>>>();

  Stream<Tuple2<int, List<ProgramModel>>> get programsStream =>
      _programsController.stream;

  Tuple2<int, List<ProgramModel>> get lastValueProgramsController =>
      _programsController.value;

  void getPrograms(bool isRefresing, int moduleId) async {
    final programsWithStatusCode =
        await _programsProvider.getAllPrograms(isRefresing, moduleId);
    _programsController.sink.add(programsWithStatusCode);
  }

  Future<int> insertProgram(ProgramModel program) async {
    final result = await _programsProvider.insertProgram(program);
    final statusCode = result.item1;

    if (statusCode == 201) {
      final tempPrograms = lastValueProgramsController.item2;
      tempPrograms.add(result.item2);
      _programsController.sink.add(Tuple2(200, tempPrograms));
    }
    return statusCode;
  }

  void dispose() {
    _programsController.sink.add(null);
  }
}
