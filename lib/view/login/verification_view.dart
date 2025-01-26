import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_groceries/view/login/select_location_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_groceries/view/main_tabview/main_tabview.dart';
import '../../common/color_extension.dart';
import '../../common_widget/line_textfield.dart';

import 'package:shared_preferences/shared_preferences.dart';

class VerificationView extends StatefulWidget {
  final String verificationId; // Pass the verification ID from the previous screen
  const VerificationView({super.key, required this.verificationId});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _codeController = TextEditingController();
  bool _isVerifying = false;
  late String _currentVerificationId;
  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId; // Initialize the state variable
  }  void _verifyCode() async {
    String code = _codeController.text.trim();

    if (code.length != 6) {
      Get.snackbar("Error", "Please enter a valid 6-digit code.");
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _currentVerificationId,
        smsCode: code,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Save user authentication state in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);

      // Navigate to MainTabView
      Get.offAll(() => const MainTabView());
    } catch (e) {
      setState(() {
        _isVerifying = false;
      });
      Get.snackbar("Verification Failed", e.toString());
    }
  }

  void _resendCode() async {
    // Implement resend functionality
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _auth.currentUser?.phoneNumber ?? "",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("Resend Failed", e.message ?? "Unknown error");
        },
        codeSent: (String verificationId, int? resendToken) {
          Get.snackbar("Code Sent", "A new code has been sent to your phone.");
          // Update the verificationId with the new one
          setState(() {
            _currentVerificationId = verificationId; // Update the verificationId
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code auto-retrieval timed out for verificationId: $verificationId");
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Stack(children: [
      Container(
        color: Colors.white,
        child: Image.asset("assets/img/bottom_bg.png",
            width: media.width, height: media.height, fit: BoxFit.cover),
      ),
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/img/back.png",
                width: 20,
                height: 20,
              )),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: media.width * 0.1,
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/img/sign_up_image.png",
                    width: media.width*0.5,
                  ),
                ],
              ),
                  SizedBox(
                    height: media.width * 0.15,
                  ),
                  Text(
                    "Enter your 6-digit code",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 26,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText: " - - - - - -",
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: _resendCode,
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                                color: TColor.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          )),
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: _isVerifying ? null : _verifyCode,
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: TColor.primary,
                              borderRadius: BorderRadius.circular(30)),
                          child: _isVerifying
                          ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                            : Image.asset(
                        "assets/img/next.png",
                        width: 20,
                        height: 20,
                      ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]);
  }
}
