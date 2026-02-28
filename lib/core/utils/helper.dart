import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/api_constants.dart';

class Helpers {
  static String generateId() {
    return const Uuid().v4();
  }

  static String randomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(rand.nextInt(chars.length)),
      ),
    );
  }

  static String getAvatarUrl(String? path) {
    if (path == null || path.isEmpty) {
      return ''; // Return default avatar asset
    }
    if (path.startsWith('http')) return path;
    
    final supabase = Supabase.instance.client;
    return supabase.storage
        .from(ApiConstants.mediaBucket)
        .getPublicUrl('${ApiConstants.avatarsPath}/$path');
  }

  static String getPostMediaUrl(String path) {
    final supabase = Supabase.instance.client;
    return supabase.storage
        .from(ApiConstants.mediaBucket)
        .getPublicUrl('${ApiConstants.postsPath}/$path');
  }

  static String getChatMediaUrl(String path) {
    final supabase = Supabase.instance.client;
    return supabase.storage
        .from(ApiConstants.mediaBucket)
        .getPublicUrl('${ApiConstants.chatPath}/$path');
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static Future<void> showLoadingDialog(BuildContext context, {String? message}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message ?? 'Loading...'),
          ],
        ),
      ),
    );
  }

  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
