import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/api_constants.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;
  
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      anonKey: ApiConstants.supabaseAnonKey,
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
  }

  static GoTrueClient get auth => client.auth;
  
  static SupabaseQueryBuilder get usersTable => client.from('users');
  static SupabaseQueryBuilder get postsTable => client.from('posts');
  static SupabaseQueryBuilder get profilesTable => client.from('profiles');
  static SupabaseQueryBuilder get walletsTable => client.from('wallets');
  static SupabaseQueryBuilder get transactionsTable => client.from('transactions');
  static SupabaseQueryBuilder get messagesTable => client.from('messages');
  static SupabaseQueryBuilder get conversationsTable => client.from('conversations');
  static SupabaseQueryBuilder get followersTable => client.from('followers');
  static SupabaseQueryBuilder get likesTable => client.from('likes');
  static SupabaseQueryBuilder get commentsTable => client.from('comments');
  static SupabaseQueryBuilder get notificationsTable => client.from('notifications');
  static SupabaseQueryBuilder get subscriptionsTable => client.from('subscriptions');
  static SupabaseQueryBuilder get withdrawalsTable => client.from('withdrawals');
  static SupabaseQueryBuilder get boostsTable => client.from('boosts');
  static SupabaseQueryBuilder get reserveTable => client.from('reserve');
  static SupabaseQueryBuilder get metricsTable => client.from('metrics');
  static SupabaseQueryBuilder get adminsTable => client.from('admins');
  static SupabaseQueryBuilder get adminLogsTable => client.from('admin_logs');
  static SupabaseQueryBuilder get supportRequestsTable => client.from('support_requests');
  
  static SupabaseStorageClient get storage => client.storage;
  static SupabaseStorageFileApi get mediaBucket => storage.from(ApiConstants.mediaBucket);
  
  static RealtimeChannel channel(String name) => client.channel(name);
}
