import 'package:psp_admin/src/models/base_parts_model.dart';
import 'package:psp_admin/src/repositories/base_parts_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class BasePartsBloc {
  final _basePartsProvider = BasePartsRepository();

  final _basePartsController =
      BehaviorSubject<Tuple2<int, List<BasePartModel>>>();

  Stream<Tuple2<int, List<BasePartModel>>> get basePartsStream =>
      _basePartsController.stream;

  Tuple2<int, List<BasePartModel>> get lastValueBasePartsController =>
      _basePartsController.value;

  void getBaseParts(bool isRefreshing, int programId) async {
    final basePartsWithStatusCode =
        await _basePartsProvider.getAllBaseParts(isRefreshing, programId);
    _basePartsController.sink.add(basePartsWithStatusCode);
  }

  void dispose() {
    _basePartsController.sink.add(null);
  }
}
