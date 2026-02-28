import 'dart:io';
import 'package:uuid/uuid.dart';
import '../constants/api_constants.dart';
import 'supabase_service.dart';

class StorageService {
  final _uuid = const Uuid();
  
  // Upload profile image
  Future<String> uploadProfileImage(String filePath) async {
    final file = File(filePath);
    final ext = filePath.split('.').last;
    final fileName = '${_uuid.v4()}.$ext';
    final fullPath = '${ApiConstants.avatarsPath}/$fileName';
    
    await SupabaseService.mediaBucket.upload(fullPath, file);
    return fileName;
  }
  
  // Upload post media
  Future<String> uploadPostMedia(String filePath, {bool isVideo = false}) async {
    final file = File(filePath);
    final ext = filePath.split('.').last;
    final fileName = '${_uuid.v4()}.$ext';
    final folder = isVideo ? 'videos' : 'images';
    final fullPath = '${ApiConstants.postsPath}/$folder/$fileName';
    
    await SupabaseService.mediaBucket.upload(fullPath, file);
    return '$folder/$fileName';
  }
  
  // Upload chat file
  Future<String> uploadChatFile(String filePath) async {
    final file = File(filePath);
    final ext = filePath.split('.').last;
    final fileName = '${_uuid.v4()}.$ext';
    final fullPath = '${ApiConstants.chatPath}/$fileName';
    
    await SupabaseService.mediaBucket.upload(fullPath, file);
    return fileName;
  }
  
  // Delete file
  Future<void> deleteFile(String path) async {
    await SupabaseService.mediaBucket.remove([path]);
  }
  
  // Get public URL
  String getPublicUrl(String path) {
    return SupabaseService.mediaBucket.getPublicUrl(path);
  }
}
