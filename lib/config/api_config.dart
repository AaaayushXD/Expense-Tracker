class ApiConfig {
  // API Base URL
  static const String baseUrl = 'https://expense-be-diqr.onrender.com/api/v1';

  // Auth Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth';
  static String userEndpoint(String userId) => '/auth/$userId';

  // Expense Endpoints
  static const String expensesEndpoint = '/expenses';
  static String expenseByIdEndpoint(String id) => '/expenses/$id';

  // Category Endpoints
  static const String categoriesEndpoint = '/categories';
  static String categoryByIdEndpoint(String id) => '/categories/$id';

  // User Endpoints
  static const String usersEndpoint = '/users';
  static String userByIdEndpoint(String id) => '/users/$id';

  // Timeout settings
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Retry settings
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // 1 second

  // Get full URL for endpoint
  static String getUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  // Auth URLs
  static String get loginUrl => getUrl(loginEndpoint);
  static String get registerUrl => getUrl(registerEndpoint);
  static String userUrl(String userId) => getUrl(userEndpoint(userId));

  // Expense URLs
  static String get expensesUrl => getUrl(expensesEndpoint);
  static String expenseByIdUrl(String id) => getUrl(expenseByIdEndpoint(id));

  // Category URLs
  static String get categoriesUrl => getUrl(categoriesEndpoint);
  static String categoryByIdUrl(String id) => getUrl(categoryByIdEndpoint(id));

  // User URLs
  static String get usersUrl => getUrl(usersEndpoint);
  static String userByIdUrl(String id) => getUrl(userByIdEndpoint(id));

  // Token URL for a specific user (e.g., /auth/{userId})
  static String tokenUrl(String userId) => getUrl('/auth/token/$userId');
}
