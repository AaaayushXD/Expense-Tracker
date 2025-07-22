class ApiConfig {
  // Base URL
  static const String baseUrl = 'https://expense-be-diqr.onrender.com/api/v1';

  // Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth';
  static const String expensesEndpoint = '/expenses';
  static const String categoriesEndpoint = '/categories';
  static const String usersEndpoint = '/users';
  static const String documentsEndpoint = '/documents';
  static const String monthlyTransactionsEndpoint = '/monthly-transactions';
  static const String ocrEndpoint = '/ocr';

  // Timeout settings (milliseconds)
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Retry settings
  static const int maxRetries = 3;
  static const int retryDelay = 1000;

  // Helper to build full URL
  static String getUrl(String endpoint) => '$baseUrl$endpoint';

  // Auth URLs
  static String get loginUrl => getUrl(loginEndpoint);
  static String get registerUrl => getUrl(registerEndpoint);
  static String userUrl(String userId) => getUrl('/auth/$userId');
  static String tokenUrl(String userId) => getUrl('/auth/token/$userId');

  // Expense URLs
  static String get expensesUrl => getUrl(expensesEndpoint);
  static String expenseByIdUrl(String id) => getUrl('$expensesEndpoint/$id');

  // Category URLs
  static String get categoriesUrl => getUrl(categoriesEndpoint);
  static String categoryByIdUrl(String id) => getUrl('$categoriesEndpoint/$id');

  // User URLs
  static String get usersUrl => getUrl(usersEndpoint);
  static String userByIdUrl(String id) => getUrl('$usersEndpoint/$id');
  static String userByEmailUrl(String email) =>
      getUrl('$usersEndpoint/email/$email');

  // Document URLs
  static String get addDocumentUrl => getUrl(documentsEndpoint);
  static String documentByIdUrl(String id) => getUrl('$documentsEndpoint/$id');
  static String documentsByUserIdUrl(String userId) =>
      getUrl('$documentsEndpoint/user/$userId');

  // Monthly Transaction URLs
  static String get addMonthlyTransactionUrl =>
      getUrl(monthlyTransactionsEndpoint);
  static String monthlyTransactionsByUserIdUrl(String userId) =>
      getUrl('$monthlyTransactionsEndpoint/user/$userId');
  static String monthlyTransactionByIdUrl(String id) =>
      getUrl('$monthlyTransactionsEndpoint/$id');

  // OCR URLs
  static String get ocrEngineUrl => getUrl(ocrEndpoint);
  static String ocrByJobIdUrl(String jobId) =>
      getUrl('$ocrEndpoint/job/$jobId');
}
