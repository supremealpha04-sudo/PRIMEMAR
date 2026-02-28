import 'package:intl/intl.dart';

class Formatter {
  static String number(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  static String currency(double amount, {String symbol = '\$', int decimals = 2}) {
    return '$symbol${amount.toStringAsFixed(decimals)}';
  }

  static String sa(double amount) {
    return '${amount.toStringAsFixed(2)} SA';
  }

  static String date(DateTime date, {bool short = false}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m';
      }
      return '${difference.inHours}h';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else if (difference.inDays < 365) {
      return DateFormat(short ? 'MMM d' : 'MMMM d').format(date);
    }
    return DateFormat(short ? 'MMM d, y' : 'MMMM d, y').format(date);
  }

  static String time(DateTime date) {
    return DateFormat.jm().format(date);
  }

  static String dateTime(DateTime date) {
    return DateFormat('MMM d, y • h:mm a').format(date);
  }

  static String duration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  static String fileSize(int bytes) {
    if (bytes >= 1073741824) {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    } else if (bytes >= 1048576) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    return '$bytes B';
  }
}
