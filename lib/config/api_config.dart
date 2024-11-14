class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String loginUrl = '/login';
  static const String registerUrl = '/register';
  static const String studiosUrl = '/studios';
  static const String bookingsUrl = '/bookings';
  static const String assetsUrl = '/assets';
  static const String feedbackUrl = '/feedback';
  static const String paymentsUrl = '/payments';
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}