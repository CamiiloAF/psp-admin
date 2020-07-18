import 'package:psp_admin/src/models/graphics/graphics_item_model.dart';
import 'package:psp_admin/src/models/graphics/graphics_model.dart';
import 'package:psp_admin/src/utils/constants.dart';
import 'package:psp_admin/src/utils/utils.dart';

class AnalysisToolsBloc {
  final graphicsData = [
    GraphicsModel(
      programName: 'Programa 1',
      defects: 90,
      size: 128,
      time: 42,
      defectsInjected: [
        DefectsModel(amount: 10, phasesId: 1),
        DefectsModel(amount: 19, phasesId: 2),
        DefectsModel(amount: 120, phasesId: 3),
      ],
      defectsRemoved: [
        DefectsModel(amount: 100, phasesId: 1),
        DefectsModel(amount: 16, phasesId: 2),
        DefectsModel(amount: 112, phasesId: 4),
        DefectsModel(amount: 43, phasesId: 3),
      ],
    ),
    GraphicsModel(
      programName: 'Programa 2',
      defects: 189,
      size: 18,
      time: 91,
      defectsInjected: [
        DefectsModel(amount: 120, phasesId: 1),
        DefectsModel(amount: 21, phasesId: 4),
        DefectsModel(amount: 21, phasesId: 5),
      ],
      defectsRemoved: [
        DefectsModel(amount: 90, phasesId: 1),
        DefectsModel(amount: 15, phasesId: 4),
        DefectsModel(amount: 84, phasesId: 5),
      ],
    )
  ];

  List<GraphicsItemModel> getTotalSizesByProgram() {
    final items = <GraphicsItemModel>[];

    if (!isNullOrEmpty(graphicsData)) {
      graphicsData.forEach((element) {
        items.add(GraphicsItemModel(
            domain: element.programName, measure: element.size));
      });
    }

    return items;
  }

  List<GraphicsItemModel> getTotalTimesByProgram() {
    final items = <GraphicsItemModel>[];

    if (!isNullOrEmpty(graphicsData)) {
      graphicsData.forEach((element) {
        items.add(GraphicsItemModel(
            domain: element.programName, measure: element.time));
      });
    }

    return items;
  }

  List<GraphicsItemModel> getTotalDefectsByProgram() {
    final items = <GraphicsItemModel>[];

    if (!isNullOrEmpty(graphicsData)) {
      graphicsData.forEach((element) {
        items.add(GraphicsItemModel(
            domain: element.programName, measure: element.defects));
      });
    }

    return items;
  }

  List<GraphicsItemModel> getDefectsInjectedByPhase() {
    var defectsInjected = <DefectsModel>[];

    if (!isNullOrEmpty(graphicsData)) {
      graphicsData.forEach((element) {
        if (!isNullOrEmpty(element.defectsInjected)) {
          defectsInjected += element.defectsInjected;
        }
      });
    }

    return _getTotalDefectsInPhase(defectsInjected);
  }

  List<GraphicsItemModel> getDefectsRemovedByPhase() {
    var defectsRemoved = <DefectsModel>[];

    if (!isNullOrEmpty(graphicsData)) {
      graphicsData.forEach((element) {
        if (!isNullOrEmpty(element.defectsRemoved)) {
          defectsRemoved += element.defectsRemoved;
        }
      });
    }

    return _getTotalDefectsInPhase(defectsRemoved);
  }

  List<GraphicsItemModel> _getTotalDefectsInPhase(List<DefectsModel> defects) {
    var defectsInPlan = 0;
    var defectsInDld = 0;
    var defectsInCode = 0;
    var defectsInCompile = 0;
    var defectsInUt = 0;
    var defectsInPm = 0;

    defects.forEach((defect) {
      switch (defect.phasesId) {
        case 1:
          defectsInPlan += defect.amount;
          break;
        case 2:
          defectsInDld += defect.amount;
          break;
        case 3:
          defectsInCode += defect.amount;
          break;
        case 4:
          defectsInCompile += defect.amount;
          break;
        case 5:
          defectsInUt += defect.amount;
          break;
        default:
          defectsInPm += defect.amount;
      }
    });

    return [
      GraphicsItemModel(domain: _getPhaseName(1), measure: defectsInPlan),
      GraphicsItemModel(domain: _getPhaseName(2), measure: defectsInDld),
      GraphicsItemModel(domain: _getPhaseName(3), measure: defectsInCode),
      GraphicsItemModel(domain: _getPhaseName(4), measure: defectsInCompile),
      GraphicsItemModel(domain: _getPhaseName(5), measure: defectsInUt),
      GraphicsItemModel(domain: _getPhaseName(6), measure: defectsInPm),
    ];
  }

  String _getPhaseName(int phaseId) => Constants.PHASES[phaseId];
}
