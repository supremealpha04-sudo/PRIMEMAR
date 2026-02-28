import 'package:flutterwave_standard/flutterwave.dart';
import 'package:paystack_flutter_sdk/paystack_flutter_sdk.dart';
import '../constants/api_constants.dart';
import 'supabase_service.dart';

class PaymentService {
  // Flutterwave Integration
  Future<void> initiateFlutterwaveDeposit({
    required double amount,
    required String currency,
    required String email,
    String? phoneNumber,
    String? name,
  }) async {
    final flutterwave = Flutterwave(
      context: context,
      publicKey: ApiConstants.flutterwavePublicKey,
      currency: currency,
      redirectUrl: 'https://primemar.com/payment/callback',
      txRef: 'PM_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount.toString(),
      customer: Customer(
        name: name ?? '',
        phoneNumber: phoneNumber ?? '',
        email: email,
      ),
      paymentOptions: 'card, banktransfer, ussd, mobilemoney',
      customization: Customization(title: 'PrimeMar Deposit'),
      isTestMode: true, // Set to false in production
    );
    
    final response = await flutterwave.charge();
    if (response != null) {
      await _verifyAndProcessPayment(response.transactionId!, amount, 'flutterwave');
    }
  }
  
  // Paystack Integration
  Future<void> initiatePaystackDeposit({
    required int amount, // Amount in kobo
    required String email,
  }) async {
    final paystack = PaystackFlutterSdk();
    
    final response = await paystack.checkout(
      context: context,
      secretKey: ApiConstants.paystackPublicKey,
      amount: amount,
      email: email,
      reference: 'PM_${DateTime.now().millisecondsSinceEpoch}',
      callbackUrl: 'https://primemar.com/payment/callback',
      showProgressBar: true,
    );
    
    if (response.status == 'success') {
      await _verifyAndProcessPayment(response.reference, amount / 100, 'paystack');
    }
  }
  
  Future<void> _verifyAndProcessPayment(String reference, double amount, String provider) async {
    // Call backend to verify payment
    final response = await SupabaseService.client.functions.invoke(
      'verify-payment',
      body: {
        'reference': reference,
        'provider': provider,
        'amount': amount,
      },
    );
    
    if (response.status == 200) {
      // Payment verified, funds added via database trigger or edge function
    } else {
      throw Exception('Payment verification failed');
    }
  }
  
  // Withdrawal Request
  Future<void> requestWithdrawal({
    required String userId,
    required double saAmount,
    required String bankAccount,
    required String bankCode,
  }) async {
    // Check minimum withdrawal
    if (saAmount < ApiConstants.minWithdrawal) {
      throw Exception('Minimum withdrawal is \$${ApiConstants.minWithdrawal}');
    }
    
    // Check cooldown (24 hours)
    final lastWithdrawal = await SupabaseService.withdrawalsTable
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    
    if (lastWithdrawal != null) {
      final lastDate = DateTime.parse(lastWithdrawal['created_at']);
      if (DateTime.now().difference(lastDate).inHours < 24) {
        throw Exception('Please wait 24 hours between withdrawals');
      }
    }
    
    // Create withdrawal request
    await SupabaseService.withdrawalsTable.insert({
      'user_id': userId,
      'sa_amount': saAmount,
      'status': 'pending',
      'bank_account': bankAccount,
      'bank_code': bankCode,
    });
  }
  
  late BuildContext context;
  void setContext(BuildContext ctx) => context = ctx;
}
