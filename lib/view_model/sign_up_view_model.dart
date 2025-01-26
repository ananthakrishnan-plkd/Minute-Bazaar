
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_groceries/common/globs.dart';
import 'package:online_groceries/common/service_call.dart';
import 'package:online_groceries/view_model/splash_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../view/login/verification_view.dart';


class SignUpViewModel extends GetxController {


  final txtPhoneNumber = TextEditingController().obs;
  final selectedCountryCode = "+971".obs;
  final isLoading = false.obs;
  final List<String> countryCodes = ["+971", "+91", "+1", "+44", "+61"];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendOtp() async {
    String phoneNumber = txtPhoneNumber.value.text.trim();
    String fullPhoneNumber = "${selectedCountryCode.value}$phoneNumber";

    if (phoneNumber.isEmpty) {
      Get.snackbar("Error", "Please enter your phone number.");
      return;
    }

    try {
      isLoading.value = true;

      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification on certain devices
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          Get.snackbar("Verification Failed", e.message ?? "Unknown error");
        },
        codeSent: (String verificationId, int? resendToken) {
          isLoading.value = false;
          // Navigate to the OTP verification screen
          Get.to(() => VerificationView(verificationId: verificationId));

        },
        codeAutoRetrievalTimeout: (String verificationId) {
          isLoading.value = false;
          print("Code auto-retrieval timed out for verificationId: $verificationId");
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}




