import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityService {
  final LocalAuthentication _localAuth = LocalAuthentication();
  
  // Biometric authentication
  Future<bool> isDeviceSupported() async {
    return await _localAuth.isDeviceSupported();
  }
  
  Future<bool> canCheckBiometrics() async {
    return await _localAuth.canCheckBiometrics;
  }
  
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _localAuth.getAvailableBiometrics();
  }
  
  Future<bool> authenticateWithBiometrics({String? reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason ?? 'Please authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
  
  // PIN management
  Future<void> setPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPin = _hashPin(pin);
    await prefs.setString('user_pin', hashedPin);
  }
  
  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString('user_pin');
    if (storedHash == null) return false;
    return storedHash == _hashPin(pin);
  }
  
  Future<bool> hasPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_pin');
  }
  
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  // Chat lock specific
  Future<void> setChatLockEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('chat_lock_enabled', enabled);
  }
  
  Future<bool> isChatLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('chat_lock_enabled') ?? false;
  }
}
