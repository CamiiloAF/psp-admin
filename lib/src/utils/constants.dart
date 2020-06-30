import 'package:intl/intl.dart';

class Constants {
  static const baseUrl = 'https://psp-sena.herokuapp.com/api';
  static const httpCsrfToken = '998c9b2e73529d4015f2c2204eb56201';

  static final format = DateFormat('d MMM yyyy / h:mm a');

  //Table names
  static const PROJECTS_TABLE_NAME = 'projects';
  static const MODULES_TABLE_NAME = 'modules';
  static const USERS_TABLE_NAME = 'users';
  static const PROJECTS_USERS_TABLE_NAME = 'projects_users';
  static const PROGRAMS_TABLE_NAME = 'programs';
  static const LANGUAGES_TABLE_NAME = 'languages';
  static const BASE_PARTS_TABLE_NAME = 'base_parts';
  static const NEW_PARTS_TABLE_NAME = 'new_parts';
  static const REUSABLE_PARTS_TABLE_NAME = 'reusable_parts';

  static const DEFECT_LOGS_TABLE_NAME = 'defect_log';
  static const TIME_LOGS_TABLE_NAME = 'time_log';

  static const TEST_REPORTS_TABLE_NAME = 'test_reports';
  
  static String token;

  static Map<String, String> getHeaders() => {
        'Content-Type': 'application/json; charset=UTF-8',
        'http_csrf_token': httpCsrfToken,
        'http_auth_token': token,
      };

  static const SQL_CREATE_TABLE_PROJECTS =
      'CREATE TABLE ${PROJECTS_TABLE_NAME}('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'name VARCHAR (50) NOT NULL,'
      'description TEXT NOT NULL,'
      'planning_date VARCHAR NOT NULL,'
      'start_date VARCHAR NULL,'
      'finish_date VARCHAR NULL'
      ');';

  static const SQL_CREATE_TABLE_MODULES = 'CREATE TABLE ${MODULES_TABLE_NAME}('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'projects_id INT (11) NOT NULL,'
      'name VARCHAR (50) NOT NULL,'
      'description TEXT NOT NULL,'
      'planning_date VARCHAR NOT NULL,'
      'start_date VARCHAR NULL,'
      'finish_date VARCHAR NULL);';

  static const SQL_CREATE_TABLE_USERS = 'CREATE TABLE ${USERS_TABLE_NAME}('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'organizations_id INT (11) NOT NULL,'
      'first_name VARCHAR (50) NOT NULL,'
      'last_name VARCHAR (50) NOT NULL,'
      'email VARCHAR (80) NOT NULL,'
      'phone VARCHAR(20) NOT NULL,'
      'rol VARCHAR (50) NOT NULL);';

  static const SQL_CREATE_TABLE_PROJECTS_USERS =
      'CREATE TABLE ${PROJECTS_USERS_TABLE_NAME}('
      'id_project INT (11) NOT NULL,'
      'id_user INT (11) NOT NULL,'
      'CONSTRAINT PK_PROYECTOS_USUARIOS PRIMARY KEY (id_user, id_project),'
      'CONSTRAINT FK_PROYECTOS_USUARIOS_PROYECTOS FOREIGN KEY (id_project) REFERENCES ${PROJECTS_TABLE_NAME}(id),'
      'CONSTRAINT FK_PROYECTOS_USUARIOS_USUARIOS FOREIGN KEY (id_user) REFERENCES ${USERS_TABLE_NAME}(id));';

  static const SQL_CREATE_TABLE_PROGRAMS = 'CREATE TABLE $PROGRAMS_TABLE_NAME('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'users_id INT (11) NOT NULL,'
      'languages_id INT (11) NOT NULL,'
      'modules_id INT(11) NOT NULL,'
      'name VARCHAR (50) NOT NULL,'
      'description TEXT NOT NULL,'
      'total_lines INT DEFAULT NULL,'
      'planning_date VARCHAR NOT NULL,'
      'start_date VARCHAR NOT NULL,'
      'update_date VARCHAR NULL,'
      'delivery_date VARCHAR NULL);';

  static const SQL_CREATE_TABLE_LANGUAGES =
      'CREATE TABLE $LANGUAGES_TABLE_NAME('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'name VARCHAR (50) NOT NULL);';

  static const SQL_CREATE_TABLE_BASE_PARTS =
      'CREATE TABLE $BASE_PARTS_TABLE_NAME('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'programs_id INT (11) NOT NULL,'
      'programs_base_id INT (11) NOT NULL,'
      'planned_lines_base INT (11) NOT NULL,'
      'planned_lines_deleted INT (11) NOT NULL,'
      'planned_lines_edits INT (11) NOT NULL,'
      'planned_lines_added INT (11) NOT NULL,'
      'current_lines_base INT (11) NULL,'
      'current_lines_deleted INT (11) NULL,'
      'current_lines_edits INT (11) NULL,'
      'current_lines_added INT (11) NULL);';

  static const SQL_CREATE_TABLE_NEW_PARTS =
      'CREATE TABLE $NEW_PARTS_TABLE_NAME('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'programs_id INT (11) NOT NULL,'
      'types_sizes_id INT (11) NOT NULL,'
      'name VARCHAR (50) NOT NULL,'
      'planned_lines INT (11) NOT NULL,'
      'number_methods_planned INT (11) NOT NULL,'
      'current_lines INT (11) NULL,'
      'number_methods_current INT (11) NULL);';

  static const SQL_CREATE_TABLE_REUSABLE_PARTS =
      'CREATE TABLE $REUSABLE_PARTS_TABLE_NAME('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'programs_id INT (11) NOT NULL,'
      'programs_reusables_id INT (11) NOT NULL,'
      'planned_lines INT (11) NOT NULL,'
      'current_lines INT (11) NULL);';

  static const SQL_CREATE_TABLE_DEFECT_LOGS =
      'CREATE TABLE $DEFECT_LOGS_TABLE_NAME('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'defect_log_chained_id INT (11) NULL,'
      'programs_id INT (11) NOT NULL,'
      'standard_defects_id INT (11) NULL,'
      'phase_added_id INT (11) NOT NULL,'
      'phase_removed_id INT (11) NULL,'
      'description TEXT NOT NULL,'
      'solution TEXT NULL,'
      'start_date VARCHAR NOT NULL,'
      'finish_date VARCHAR NULL,'
      'time_for_repair INT NULL);';

  static const SQL_CREATE_TABLE_TIME_LOGS =
      'CREATE TABLE $TIME_LOGS_TABLE_NAME('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'programs_id INT (11) NOT NULL,'
      'phases_id INT (11) NOT NULL,'
      'start_date VARCHAR NOT NULL,'
      'delta_time DOUBLE NULL,'
      'finish_date VARCHAR NULL,'
      'interruption INT NOT NULL,'
      'comments TEXT NULL);';

  static const SQL_CREATE_TABLE_TEST_REPORTS =
      'CREATE TABLE $TEST_REPORTS_TABLE_NAME('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'programs_id INT (11) NOT NULL,'
      'test_number INT (11) NOT NULL,'
      'test_name VARCHAR (50) NOT NULL,'
      'conditions TEXT NOT NULL,'
      'expected_result TEXT NOT NULL,'
      'current_result TEXT NULL,'
      'description TEXT NULL,'
      'objective TEXT NOT NULL);';

  static final PHASES = {
    1: 'PLAN',
    2: 'DLD',
    3: 'CODE',
    4: 'COMPILE',
    5: 'UT',
    6: 'PM'
  };

  static final STANDARD_DEFECTS = {
    1: 'DOCUMENTATION',
    2: 'SYNTAX',
    3: 'BUILD',
    4: 'PACKAGE',
    5: 'ASSIGNMENT',
    6: 'INTERFACE',
    7: 'CHECKING',
    8: 'DATA',
    9: 'FUNCTION',
    10: 'SYSTEM',
    11: 'ENVIRONMENT'
  };

  static const NEW_PART_TYPES_SIZE = {
    1: 'calculation-vs',
    2: 'calculation-s',
    3: 'calculation-m',
    4: 'calculation-l',
    5: 'calculation-vl',
    6: 'data-vs',
    7: 'data-s',
    8: 'data-m',
    9: 'data-l',
    10: 'data-vl',
    11: 'i/o-vs',
    12: 'i/o-s',
    13: 'i/o-m',
    14: 'i/o-l',
    15: 'i/o-vl',
    16: 'logic-vs',
    17: 'logic-s',
    18: 'logic-m',
    19: 'logic-l',
    20: 'logic-vl',
    21: 'setup-vs',
    22: 'setup-s',
    23: 'setup-m',
    24: 'setup-l',
    25: 'setup-vl',
    26: 'text-vs',
    27: 'text-s',
    28: 'text-m',
    29: 'text-l',
    30: 'text-vl',
  };
}
