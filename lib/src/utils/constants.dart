class Constants {
  static const baseUrl = 'https://psp-sena.herokuapp.com/api';
  static const httpCsrfToken = '998c9b2e73529d4015f2c2204eb56201';

  static String token;

  static getHeaders() => {
        'http_csrf_token': httpCsrfToken,
        'http_auth_token': token,
      };
}
