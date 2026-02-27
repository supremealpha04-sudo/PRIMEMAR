class Routes {
  // Root
  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';

  // Main
  static const String home = '/home';
  static const String feed = '/feed';
  static const String videoFeed = '/video-feed';

  // Search
  static const String search = '/search';
  static const String searchUsers = '/search/users';
  static const String searchPosts = '/search/posts';
  static const String searchVideos = '/search/videos';

  // Create
  static const String createPost = '/create-post';
  static const String createStory = '/create-story';
  static const String camera = '/camera';

  // Post
  static const String postDetail = '/post/:id';
  static const String postEdit = '/post/:id/edit';
  static String postDetailPath(String id) => '/post/$id';
  static String postEditPath(String id) => '/post/$id/edit';

  // Comments
  static const String comments = '/post/:id/comments';
  static const String replies = '/comment/:id/replies';
  static String commentsPath(String postId) => '/post/$postId/comments';
  static String repliesPath(String commentId) => '/comment/$commentId/replies';

  // Profile
  static const String profile = '/profile/:username';
  static const String myProfile = '/profile/me';
  static const String editProfile = '/profile/edit';
  static const String followers = '/profile/:username/followers';
  static const String following = '/profile/:username/following';
  static String profilePath(String username) => '/profile/$username';
  static String followersPath(String username) => '/profile/$username/followers';
  static String followingPath(String username) => '/profile/$username/following';

  // Messages
  static const String messages = '/messages';
  static const String chat = '/messages/:userId';
  static const String chatList = '/messages/list';
  static const String lockedChats = '/messages/locked';
  static String chatPath(String userId) => '/messages/$userId';

  // Notifications
  static const String notifications = '/notifications';

  // Wallet
  static const String wallet = '/wallet';
  static const String deposit = '/wallet/deposit';
  static const String withdraw = '/wallet/withdraw';
  static const String transactions = '/wallet/transactions';
  static const String transactionDetail = '/wallet/transactions/:id';
  static const String bankAccounts = '/wallet/bank-accounts';
  static const String addBankAccount = '/wallet/bank-accounts/add';

  // SA Economy
  static const String saDashboard = '/sa';
  static const String saHistory = '/sa/history';
  static const String saRules = '/sa/rules';
  static const String boostPost = '/sa/boost/:postId';
  static String boostPostPath(String postId) => '/sa/boost/$postId';

  // Verification
  static const String verification = '/verification';
  static const String verificationPayment = '/verification/payment';
  static const String verificationPending = '/verification/pending';

  // Subscription
  static const String subscribe = '/subscribe/:creatorId';
  static String subscribePath(String creatorId) => '/subscribe/$creatorId';

  // Settings
  static const String settings = '/settings';
  static const String accountSettings = '/settings/account';
  static const String privacySettings = '/settings/privacy';
  static const String notificationSettings = '/settings/notifications';
  static const String chatSettings = '/settings/chat';
  static const String securitySettings = '/settings/security';
  static const String appearanceSettings = '/settings/appearance';
  static const String walletSettings = '/settings/wallet';
  static const String dataStorage = '/settings/data-storage';
  static const String support = '/settings/support';
  static const String about = '/settings/about';
  static const String help = '/settings/help';
  static const String faq = '/settings/faq';
  static const String communityGuidelines = '/settings/guidelines';
  static const String termsOfService = '/settings/terms';
  static const String privacyPolicy = '/settings/privacy-policy';

  // Admin
  static const String admin = '/admin';
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminUserDetail = '/admin/users/:id';
  static const String adminPosts = '/admin/posts';
  static const String adminComments = '/admin/comments';
  static const String adminWithdrawals = '/admin/withdrawals';
  static const String adminReserve = '/admin/reserve';
  static const String adminReports = '/admin/reports';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminLogs = '/admin/logs';
  static const String adminAdmins = '/admin/admins';
  static String adminUserDetailPath(String id) => '/admin/users/$id';

  // Error
  static const String notFound = '/404';
  static const String error = '/error';
}
