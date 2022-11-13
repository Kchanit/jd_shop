import 'dart:developer';

import 'package:jd_shop/services/auth_service.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:jd_shop/utils/showSnackBar.dart';
import 'package:jd_shop/widgets/input_decoration.dart';
import 'package:jd_shop/widgets/main_btn_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GoogleRegisterScreen extends StatefulWidget {
  GoogleRegisterScreen({Key? key}) : super(key: key);

  @override
  State<GoogleRegisterScreen> createState() => _GoogleRegisterScreenState();
}

class _GoogleRegisterScreenState extends State<GoogleRegisterScreen> {

  final formKey = GlobalKey<FormState>();
  String? username, email, phone, password, confirmPassword, address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorsPurple,
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage("assets/bg.jpg"),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back.svg', color: kColorsWhite),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: kColorsWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 40, bottom: 20),
                child: Text('Register', style: Theme.of(context).textTheme.headline1),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CreatePhone(),
                    CreateAddress(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: InkWell(
                  onTap: (){
                    registerHandle(context: context);
                  },
                  child: MainBtnWidget(colorBtn: kColorsPurple, textBtn: 'Sign Up', isTransparent: false, haveIcon: false)
                )
              ),
            ]
          ),
        ),
      ),
    );
  }

 
  Widget CreatePhone() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.number,
        autofocus: false,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: kColorsPurple),
        decoration: InputDecorationWidget(context, 'Phone'),
        validator: (value) {
          if(value!.isEmpty) {
            return "Please enter phone";
          }return null;
        },
        onChanged: (value) {
          phone = value;
        },
      )
    );
  }
  
  
  Widget CreateAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: kColorsPurple),
        decoration: InputDecorationWidget(context, 'Address'),
        validator: (value) {
          if(value!.isEmpty) {
            return "Please enter Address";
          }return null;
        },
        onChanged: (value) {
          address = value;
        },
      )
    );
  }

  Future<void> registerHandle({required BuildContext context}) async{
    final authService = Provider.of<AuthService>(context, listen: false);

    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showDialog(
        context: context, 
        builder: ((context) => Center(
          child: CircularProgressIndicator(strokeWidth: 4),
          )));
      
      try {
          authService.createUser(
            email: email, 
            username: username, 
            password: password, 
            phone: phone, 
            address: address);
          
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } on auth.FirebaseAuthException catch (e) {
        log(e.message!);
        showSnackBar(e.message);
        Navigator.of(context).pop();
      }
    }
  }
}