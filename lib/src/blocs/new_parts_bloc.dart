import 'package:psp_admin/src/models/new_parts_model.dart';
import 'package:psp_admin/src/repositories/new_parts_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class NewPartsBloc {
  final _newPartsProvider = NewPartsRepository();

  final _newPartsController =
      BehaviorSubject<Tuple2<int, List<NewPartModel>>>();

  Stream<Tuple2<int, List<NewPartModel>>> get newPartsStream =>
      _newPartsController.stream;

  Tuple2<int, List<NewPartModel>> get lastValueNewPartsController =>
      _newPartsController.value;

  void getNewParts(bool isRefreshing, int programId) async {
    final newPartsWithStatusCode =
        await _newPartsProvider.getAllNewParts(isRefreshing, programId);
    _newPartsController.sink.add(newPartsWithStatusCode);
  }

  void dispose() => _newPartsController.sink.add(null);
}
