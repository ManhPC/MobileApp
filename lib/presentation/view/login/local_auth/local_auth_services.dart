import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:nvs_trading/domain/biometrics_type.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();

  static Future<bool> canAuthenticate() async {
    bool canAuthen =
        await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    return canAuthen;
  }

  static Future<bool> authentication() async {
    try {
      if (!await canAuthenticate()) return false;
      return await _auth.authenticate(
        localizedReason: "Vui lòng chạm vân tay vào",
        authMessages: <AuthMessages>[
          const AndroidAuthMessages(
            signInTitle: 'Bảo mật sinh trắc học',
            cancelButton: 'Thoát',
            biometricHint: "",
          ),
          const IOSAuthMessages(
            cancelButton: 'Thoát',
          )
        ],
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print("error $e");
      return false;
    }
  }

  static Future<String> getBiometricType() async {
    final List<BiometricType> availableBiometrics =
        await _auth.getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.face)) {
      return "Face ID";
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return "Touch ID";
    } else {
      return "Unknown";
    }
  }

  static Future<List<BiometricType>> listAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  static Future<BiometricsType> getAvailableBiometrics() async {
    bool check = await _auth.canCheckBiometrics;
    BiometricsType checkBiometric = BiometricsType.touchId;
    if (check) {
      final availableBiometrics = await listAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.face)) {
        checkBiometric = BiometricsType.faceId;
      }
      if (availableBiometrics.contains(BiometricType.strong)) {
        checkBiometric = BiometricsType.touchId;
      } else {
        Platform.isIOS
            ? checkBiometric = BiometricsType.faceId
            : checkBiometric = BiometricsType.touchId;
      }
      return checkBiometric;
    } else {
      Platform.isIOS
          ? checkBiometric = BiometricsType.faceId
          : checkBiometric = BiometricsType.touchId;
      return checkBiometric;
    }
  }
}
