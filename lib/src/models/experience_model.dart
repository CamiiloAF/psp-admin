import 'dart:convert';

ExperienceModel experienceModelFromJson(String str) =>
    ExperienceModel.fromJson(json.decode(str));

String experienceModelToJson(ExperienceModel data) =>
    json.encode(data.toJson());

class ExperienceModel {
  ExperienceModel({
    this.usersId,
    this.id,
    this.positions,
    this.yearsGenerals,
    this.yearsConfiguration,
    this.yearsIntegration,
    this.yearsRequirements,
    this.yearsDesign,
    this.yearsTests,
    this.yearsSupport,
  });

  int id;
  int usersId;
  String positions;
  int yearsGenerals;
  int yearsConfiguration;
  int yearsIntegration;
  int yearsRequirements;
  int yearsDesign;
  int yearsTests;
  int yearsSupport;

  factory ExperienceModel.fromJson(Map<String, dynamic> json) =>
      ExperienceModel(
        id: json['id'],
        usersId: json['users_id'],
        positions: json['positions'],
        yearsGenerals: json['years_generals'],
        yearsConfiguration: json['years_configuration'],
        yearsIntegration: json['years_integration'],
        yearsRequirements: json['years_requirements'],
        yearsDesign: json['years_design'],
        yearsTests: json['years_tests'],
        yearsSupport: json['years_support'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'users_id': usersId,
        'positions': positions,
        'years_generals': yearsGenerals,
        'years_configuration': yearsConfiguration,
        'years_integration': yearsIntegration,
        'years_requirements': yearsRequirements,
        'years_design': yearsDesign,
        'years_tests': yearsTests,
        'years_support': yearsSupport,
      };
}
