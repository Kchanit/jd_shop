import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jd_shop/screens/profile_screen.dart';
import 'package:jd_shop/services/auth_service.dart';
import 'package:jd_shop/services/google_sign_in.dart';
import 'package:jd_shop/services/login_controller.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:jd_shop/widgets/input_decoration.dart';
import 'package:jd_shop/widgets/main_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  String? email, password;
  final controller = Get.put(LoginController());
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: kColorsWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, top: 20, bottom: 20),
                    child: Text('JD Shop',
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CreateEmail(),
                        CreatePassword(),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: InkWell(
                          onTap: () {
                            loginHandle(context: context);
                          },
                          child: MainBtnWidget(
                              colorBtn: kColorsPurple,
                              textBtn: 'Login',
                              isTransparent: false,
                              haveIcon: false))),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 40),
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: kColorsPurple)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 40),
                    child: Container(
                        child: Row(children: [
                      Expanded(child: Divider(color: kColorsGrey)),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("or",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: kColorsGrey)),
                      ),
                      Expanded(child: Divider(color: kColorsGrey)),
                    ])),
                  ),
                  InkWell(
                      onTap: () {
                        // googleSignInHandle(context: context);

                        // controller.logout();
                        // controller.login(context: context);

                        // handleAuthState();
                        authService.signOutGG();
                        authService.signInWithGoogle();
                        Navigator.pushNamed(context, '/profile-screen');
                        // Navigator.of(context).pushNamedAndRemoveUntil('/profile-screen', (route) => false);
                      },
                      child: MainBtnWidget(
                          colorBtn: kColorsPurple,
                          textBtn: 'Login with Google',
                          isTransparent: true,
                          haveIcon: true)),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('Don\'t have an account? ',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                      color: kColorsGrey)),
                              InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: Text('Sign Up',
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: kColorsPurple))),
                            ])),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CreateEmail() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kColorsPurple),
          decoration: InputDecorationWidget(context, 'Email'),
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter Email";
            }
            return null;
          },
          onChanged: (value) {
            email = value;
          },
        ));
  }

  Widget CreatePassword() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: TextFormField(
          obscureText: !_passwordVisible,
          keyboardType: TextInputType.text,
          autofocus: false,

          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kColorsPurple),
          // decoration: InputDecorationWidget(context, 'Password'),
          decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  // color: Theme.of(context).primaryColorDark,
                  color: kColorsPurple,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
              //decoration from InputDecorationWidget
              labelStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: kColorsGrey),
              contentPadding:
                  new EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              enabledBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10),
                borderSide: BorderSide(color: kColorsGrey, width: 1),
              ),
              focusedBorder: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10),
                borderSide: BorderSide(color: kColorsPurple, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10),
                borderSide: BorderSide(color: kColorsRed, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(10),
                borderSide: BorderSide(color: kColorsRed, width: 2),
              ),
              errorStyle: Theme.of(context).textTheme.bodyText1),

          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter password";
            }
            return null;
          },
          onChanged: (value) {
            password = value;
          },
        ));
  }

  Future<void> loginHandle({required BuildContext context}) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showDialog(
          context: context,
          builder: ((context) => Center(
                child: CircularProgressIndicator(strokeWidth: 4),
              )));

      try {
        await authService.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } on FirebaseAuthException catch (e) {
        log(e.message!);
        Navigator.pop(context);
      }
    }
  }

  Future<void> googleSignInHandle({required context}) async {
    // final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    // provider.googleLogin();
    // Navigator.pushNamed(context, '/google-register');

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    _googleSignIn.signOut();
    _googleSignIn.signIn();
    Navigator.pushNamed(context, '/google_register');
  }

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ProfileScreen();
          } else {
            return LoginScreen();
          }
        });
  }
}
