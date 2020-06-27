import 'dart:convert';

class TestReportsModel {
  List<TestReportModel> testReports = [];

  TestReportsModel();

  TestReportsModel.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final testReport = TestReportModel.fromJson(item);
      testReports.add(testReport);
    }
  }
}

TestReportModel testReportModelFromJson(String str) =>
    TestReportModel.fromJson(json.decode(str));

String testReportModelToJson(TestReportModel data) =>
    json.encode(data.toJson());

class TestReportModel {
  TestReportModel({
    this.id,
    this.programsId,
    this.testNumber,
    this.testName,
    this.conditions,
    this.expectedResult,
    this.currentResult,
    this.description,
    this.objective,
  });

  int id;
  int programsId;
  int testNumber;
  String testName;
  String conditions;
  String expectedResult;
  String currentResult;
  String description;
  String objective;

  factory TestReportModel.fromJson(Map<String, dynamic> json) =>
      TestReportModel(
        id: json['id'],
        programsId: json['programs_id'],
        testNumber: json['test_number'],
        testName: json['test_name'],
        conditions: json['conditions'],
        expectedResult: json['expected_result'],
        currentResult: json['current_result'],
        description: json['description'],
        objective: json['objective'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'programs_id': programsId,
        'test_number': testNumber,
        'test_name': testName,
        'conditions': conditions,
        'expected_result': expectedResult,
        'current_result': currentResult,
        'description': description,
        'objective': objective,
      };
}
