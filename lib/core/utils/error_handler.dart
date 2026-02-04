import 'dart:io';
import 'dart:async';

class AppErrorHandler {
  static String mapErrorToString(dynamic e) {
    if (e is SocketException) {
      return "Check your internet connection.";
    } else if (e is HttpException) {
      return "Network error. Please try again.";
    } else if (e is TimeoutException) {
      return "Request timed out. Please try again.";
    } else if (e.toString().contains('PGRST')) {
      // Handle specific Supabase/Postgrest errors
      return "Database error. Please contact support.";
    }

    // Default fallback
    return "Something went wrong. Please try again.";
  }
}
