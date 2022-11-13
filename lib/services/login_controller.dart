import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jd_shop/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginController extends GetxController {
  var _googleSignIn = GoogleSignIn();
  var googleAccount = Rx<GoogleSignInAccount?>(null);

  login({required BuildContext context}) async {
    showDialog(
        context: context,
        builder: ((context) => Center(
              child: CircularProgressIndicator(strokeWidth: 4),
            )));
    googleAccount.value = await _googleSignIn.signIn();
    // Navigator.of(context).pushNamedAndRemoveUntil('/profile-screen', (route) => false);
  }

  logout() async {
    googleAccount.value = await _googleSignIn.signOut();
  }
}
