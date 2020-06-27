import 'package:psp_admin/src/models/programs_model.dart';
import 'package:psp_admin/src/repositories/programs_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ProgramsBloc {
  final _programsProvider = ProgramsRepository();

  final _programsController =
      BehaviorSubject<Tuple2<int, List<ProgramModel>>>();

  final _programsByOrganizationController =
      BehaviorSubject<Tuple2<int, List<Tuple2<int, String>>>>();

  Stream<Tuple2<int, List<ProgramModel>>> get programsStream =>
      _programsController.stream;

  Tuple2<int, List<ProgramModel>> get lastValueProgramsController =>
      _programsController.value;

  Tuple2<int, List<Tuple2<int, String>>>
      get lastValueProgramsByOrganizationController =>
          _programsByOrganizationController.value;

  void getAllPrograms(bool isRefreshing, int moduleId) async {
    final programsByModuleIdWithStatusCode =
        await _programsProvider.getProgramsByModuleId(isRefreshing, moduleId);

    if (isRefreshing || lastValueProgramsByOrganizationController == null) {
      final programsByOrganizationWithStatusCode =
          await _programsProvider.getAllProgramsByOrganization();
      _programsByOrganizationController.sink
          .add(programsByOrganizationWithStatusCode);
    }
    _programsController.sink.add(programsByModuleIdWithStatusCode);
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

  String getProgramsBaseName(
      int programsBaseId, String programBaseNameDefault) {
    var programBaseName;

    final allPrograms = lastValueProgramsByOrganizationController?.item2 ?? [];

    if (allPrograms.isNotEmpty) {
      for (var program in allPrograms) {
        if (program.item1 == programsBaseId) {
          programBaseName = program.item2;
          break;
        }
      }
    }

    return (programBaseName != null) ? programBaseName : programBaseNameDefault;
  }

  void dispose() {
    _programsController.sink.add(null);
  }
}
