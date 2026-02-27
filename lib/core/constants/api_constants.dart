class ApiConstants {
  // Supabase
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );
  static const String supabaseServiceRoleKey = String.fromEnvironment(
    'SUPABASE_SERVICE_ROLE_KEY',
    defaultValue: '',
  );

  // Storage Buckets
  static const String mediaBucket = 'media';
  static const String avatarsPath = 'avatars';
  static const String postsPath = 'posts';
  static const String chatPath = 'chat';
  static const String documentsPath = 'documents';
  static const String thumbnailsPath = 'thumbnails';
  static const String iconsPath = 'icons';

  // Payment - Flutterwave
  static const String flutterwavePublicKey = String.fromEnvironment(
    'FLUTTERWAVE_PUBLIC_KEY',
    defaultValue: 'FLWPUBK_TEST-...',
  );
  static const String flutterwaveSecretKey = String.fromEnvironment(
    'FLUTTERWAVE_SECRET_KEY',
    defaultValue: 'FLWSECK_TEST-...',
  );
  static const String flutterwaveEncryptionKey = String.fromEnvironment(
    'FLUTTERWAVE_ENCRYPTION_KEY',
    defaultValue: '',
  );

  // Payment - Paystack
  static const String paystackPublicKey = String.fromEnvironment(
    'PAYSTACK_PUBLIC_KEY',
    defaultValue: 'pk_test_...',
  );
  static const String paystackSecretKey = String.fromEnvironment(
    'PAYSTACK_SECRET_KEY',
    defaultValue: 'sk_test_...',
  );

  // API Endpoints
  static const String baseApiUrl = '/api/v1';
  static const String verifyPayment = '$baseApiUrl/payments/verify';
  static const String processWithdrawal = '$baseApiUrl/withdrawals/process';
  static const String webhookFlutterwave = '$baseApiUrl/webhooks/flutterwave';
  static const String webhookPaystack = '$baseApiUrl/webhooks/paystack';

  // App Limits
  static const int maxMessagesPerMinute = 30;
  static const int maxPostLength = 280;
  static const int maxBioLength = 160;
  static const int maxCommentLength = 500;
  static const int maxUsernameLength = 30;
  static const int maxDisplayNameLength = 50;
  static const int maxFileSizeMB = 50;
  static const int maxVideoDurationSeconds = 300; // 5 minutes

  // Economic Constants
  static const double minWithdrawalUsd = 5.0;
  static const double verificationFeeUsd = 25.0;
  static const double subscriptionCostUsd = 7.0;
  static const double boostCostSa = 100.0;
  static const double saPerFollowerMilestone = 0.5;
  static const int followersMilestoneThreshold = 1000;
  static const double maxDailySaEarning = 80.0;
  static const double creatorSharePercent = 0.5;
  static const double platformSharePercent = 0.3;
  static const double reserveSharePercent = 0.2;

  // Time Constants
  static const int boostDurationHours = 48;
  static const int withdrawalCooldownHours = 24;
  static const int storyDurationHours = 24;
  static const int verificationProcessingDays = 3;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 5);
  static const Duration tokenRefreshBuffer = Duration(minutes: 5);
}
