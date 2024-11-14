import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.226.79:8000'; // Ensure this is accessible
  static const String apiUrl = '$baseUrl/api';
  static const String sanctumUrl = '$baseUrl/sanctum/csrf-cookie';

  // This will hold the csrfToken and sessionCookie once fetched
  static String? csrfToken;
  static String? sessionCookie;

  // Fetch the CSRF token and session cookie, store them in SharedPreferences
  static Future<void> getCsrfToken() async {
    try {
      final response = await http.get(Uri.parse(sanctumUrl));
      print("Response Headers: ${response.headers}");

      if (response.statusCode == 204) {
        final cookies = response.headers['set-cookie'];

        if (cookies != null) {
          // Extract the XSRF-TOKEN and laravel_session cookies
          final xsrfToken =
              RegExp(r'XSRF-TOKEN=([^;]+);').firstMatch(cookies)?.group(1);
          final session =
              RegExp(r'laravel_session=([^;]+);').firstMatch(cookies)?.group(1);

          if (xsrfToken != null) {
            csrfToken = xsrfToken;
            print("Fetched CSRF Token: $csrfToken");

            // Store CSRF token in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('csrf_token', csrfToken!);
          }

          if (session != null) {
            sessionCookie = session;
            print("Fetched Laravel Session Cookie: $sessionCookie");

            // Store session cookie in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('session_cookie', sessionCookie!);
          }
        } else {
          print("No cookies received in the response.");
        }
      } else {
        print(
            "Failed to fetch CSRF cookie, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching CSRF token: $e");
    }
  }

  static Future<Map<String, String>> getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final csrfToken = prefs.getString('csrf_token'); // Retrieve CSRF token

    final sessionCookie =
        prefs.getString('session_cookie'); // Retrieve session cookie

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Only add the CSRF token if it's not null
    if (csrfToken != null) {
      headers['X-XSRF-TOKEN'] = csrfToken;
    }

    // Only add the session cookie if it's not null
    if (sessionCookie != null) {
      headers['Cookie'] = 'laravel_session=$sessionCookie';
    }

    return headers;
  }

  // POST request to send data
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      {bool useApi = true}) async {
    final headers = await getHeaders();
    final url = useApi ? '$apiUrl$endpoint' : '$baseUrl$endpoint';

    try {
      print(headers);

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to post data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during POST request: $e');
      rethrow;
    }
  }

  // GET request to fetch data
  static Future<dynamic> get(String endpoint) async {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$apiUrl$endpoint'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to get data, status code: ${response.statusCode}');
    }
  }
}
