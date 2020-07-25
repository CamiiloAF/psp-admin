import 'package:psp_admin/src/models/summary/program_summary_model.dart';
import 'package:tuple/tuple.dart';

class ProgramSummaryRepository {
  Future<Tuple2<int, List<ProgramSummaryModel>>> getProgramSummary(int programId
      ) async {

final programSummaryModel = ProgramSummaryModel.fromJson( {
  'language': 'Java',
  'program_lines': {
    'base_planned': 910.1,
    'base_current': 1050,
    'deleted_planned': 166,
    'deleted_current': 102,
    'modified_planned': 150,
    'modified_current': 74,
    'added_planned': 90,
    'added_current': 68,
    'reused_planned': 100,
    'reused_current': 112,
    'new_planned_lines': 12,
    'new_current_lines': 12
  },
  'time_phase': [
    {
      'phase_id': 1,
      'planning_time': 1277,
      'current_time': 1440,
      'to_date_time': 1450,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 2,
      'planning_time': 1277,
      'current_time': 1440,
      'to_date_time': 1450,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 3,
      'planning_time': 1277,
      'current_time': 1440,
      'to_date_time': 1450,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 4,
      'planning_time': 1277,
      'current_time': 1440,
      'to_date_time': 1450,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 5,
      'planning_time': 1277,
      'current_time': 1440,
      'to_date_time': 1450,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 6,
      'planning_time': 1277,
      'current_time': 1440,
      'to_date_time': 1450,
      'percent': 1666.6666666666665
    }
  ],
  'defects_injected': [
    {
      'phase_id': 1,
      'planning_defects': 17,
      'current_defects': 0,
      'to_date_defects': 7,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 2,
      'planning_defects': 17,
      'current_defects': 0,
      'to_date_defects': 7,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 3,
      'planning_defects': 17,
      'current_defects': 0,
      'to_date_defects': 7,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 4,
      'planning_defects': 17,
      'current_defects': 0,
      'to_date_defects': 7,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 5,
      'planning_defects': 17,
      'current_defects': 0,
      'to_date_defects': 7,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 6,
      'planning_defects': 17,
      'current_defects': 0,
      'to_date_defects': 7,
      'percent': 1666.6666666666665
    }
  ],
  'defects_removed': [
    {
      'phase_id': 1,
      'current_defects': 0,
      'to_date_defects': 4,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 2,
      'current_defects': 0,
      'to_date_defects': 4,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 3,
      'current_defects': 0,
      'to_date_defects': 4,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 4,
      'current_defects': 0,
      'to_date_defects': 4,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 5,
      'current_defects': 0,
      'to_date_defects': 4,
      'percent': 1666.6666666666665
    },
    {
      'phase_id': 6,
      'current_defects': 0,
      'to_date_defects': 4,
      'percent': 1666.6666666666665
    }
  ]
});
    return await Tuple2(200, [programSummaryModel]) ;
  }

}


