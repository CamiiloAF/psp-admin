class Constants {
  static const baseUrl = 'https://psp-sena.herokuapp.com/api';
  static const httpCsrfToken = '998c9b2e73529d4015f2c2204eb56201';

  //Table names
  static const PROJECTS_TABLE_NAME = 'projects';
  static const MODULES_TABLE_NAME = 'modules';
  static const USERS_TABLE_NAME = 'users';
  static const PROJECTS_USERS_TABLE_NAME = 'projects_users';

  static String token;

  static Map<String, String> getHeaders() => {
        'Content-Type': 'application/json; charset=UTF-8',
        'http_csrf_token': httpCsrfToken,
        'http_auth_token': token,
      };
}
