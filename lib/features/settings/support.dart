import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/settings_provider.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String _selectedType = 'bug';

  final supportTypes = [
    {'value': 'bug', 'label': 'Report Bug', 'icon': Icons.bug_report},
    {'value': 'feature', 'label': 'Feature Request', 'icon': Icons.lightbulb},
    {'value': 'support', 'label': 'Contact Support', 'icon': Icons.support_agent},
    {'value': 'feedback', 'label': 'Send Feedback', 'icon': Icons.feedback},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        title: Text(
          'Support & Help',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildQuickActions(context),
          SizedBox(height: 24.h),
          _buildContactForm(context),
          SizedBox(height: 24.h),
          _buildFAQSection(context),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.textDark 
                : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.help_outline,
                label: 'FAQ',
                onTap: () {/* Navigate to FAQ */},
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionCard(
                context,
                icon: Icons.book_outlined,
                label: 'Guidelines',
                onTap: () {/* Navigate to guidelines */},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32.sp, color: AppColors.primary),
            SizedBox(height: 12.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactForm(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              items: supportTypes.map((type) => DropdownMenuItem(
                value: type['value'] as String,
                child: Row(
                  children: [
                    Icon(type['icon'] as IconData, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(type['label'] as String),
                  ],
                ),
              )).toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Describe your issue or feedback...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Please enter a message' : null,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Send Request',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {'q': 'How do I earn SA?', 'a': 'Earn SA by gaining new followers. 0.5 SA per 1,000 new followers.'},
      {'q': 'How do I withdraw?', 'a': 'Go to Wallet > Withdraw. Minimum \$5 USD equivalent.'},
      {'q': 'What is Boost?', 'a': 'Boost increases your post visibility for 48 hours using 100 SA.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.textDark 
                : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        ...faqs.map((faq) => ExpansionTile(
          title: Text(
            faq['q']!,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                faq['a']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        )),
      ],
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    
    try {
      await ref.read(settingsProvider.notifier).submitSupportRequest(
        _messageController.text,
        _selectedType,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Support request submitted')),
        );
        _messageController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
