class Constants {
  static const baseUrl = 'https://psp-sena.herokuapp.com/api';
  static const httpCsrfToken = '998c9b2e73529d4015f2c2204eb56201';

  //Table names
  static const PROJECTS_TABLE_NAME = 'projects';
  static const MODULES_TABLE_NAME = 'modules';
  static const USERS_TABLE_NAME = 'users';
  static const PROJECTS_USERS_TABLE_NAME = 'projects_users';
  static const PROGRAMS_TABLE_NAME = 'programs';

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

  static const SQL_CREATE_TABLE_PROGRAMS = 'CREATE TABLE programs('
      'id INT (11) PRIMARY KEY NOT NULL,'
      'id_user INT (11) NOT NULL,'
      'id_language INT (11) NOT NULL,'
      'id_module INT(11) NOT NULL,'
      'name VARCHAR (50) NOT NULL,'
      'description TEXT NOT NULL,'
      'total_lines bigint DEFAULT NULL,'
      'planning_date DATETIME NOT NULL,'
      'start_date DATETIME NOT NULL,'
      'update_date DATETIME NULL,'
      'delivery_date DATETIME NULL,'
      'CONSTRAINT FK_PROGRAMAS_users FOREIGN KEY (id_user) REFERENCES users(id),'
      'CONSTRAINT FK_PROGRAMAS_LENGUAJES FOREIGN KEY (id_language) REFERENCES languages(id),'
      'CONSTRAINT FK_PROGRAMAS_MODULOS FOREIGN KEY (id_module) REFERENCES modules(id);';
}
