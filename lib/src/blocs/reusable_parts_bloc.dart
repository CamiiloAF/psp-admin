import 'package:psp_admin/src/models/reusable_parts_model.dart';
import 'package:psp_admin/src/repositories/reusable_parts_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class ReusablePartsBloc {
  final _reusablePartsProvider = ReusablePartsRepository();

  final _reusablePartsController =
      BehaviorSubject<Tuple2<int, List<ReusablePartModel>>>();

  Stream<Tuple2<int, List<ReusablePartModel>>> get reusablePartsStream =>
      _reusablePartsController.stream;

  Tuple2<int, List<ReusablePartModel>> get lastValueReusablePartsController =>
      _reusablePartsController.value;

  void getReusableParts(bool isRefresing, int programId) async {
    final reusablePartsWithStatusCode = await _reusablePartsProvider
        .getAllReusableParts(isRefresing, programId);
    _reusablePartsController.sink.add(reusablePartsWithStatusCode);
  }

  void dispose() {
    _reusablePartsController.sink.add(null);
  }
}
