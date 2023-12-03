import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../../LoginApiController/loginController.dart';


class LoginPage extends StatelessWidget {
  static const String id = 'LoginPage';
  final loginController = Get.put(LoginController());
   TextEditingController userNameController = TextEditingController();
   TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 21),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Container(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white
                  ),
                  child: Image.asset('lib/images/TigerHRMS.png', width: 170, fit: BoxFit.cover),
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  autofocus: true,
                  controller: userNameController,

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF959797),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xff061a2a),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.grey,
                      size: 22,
                    ),
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 10),
                Obx(() {
                  final isPasswordVisible = loginController.isPasswordVisible.value;
                  return TextFormField(
                    obscureText: !isPasswordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF959797),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff061a2a),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                        size: 22,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: loginController.togglePasswordVisibility,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  );
                }),
                SizedBox(height: 17),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17),
                ElevatedButton(
                  onPressed: () async {
                    await loginController.loginUser(
                      userName: userNameController.text,
                      password: passwordController.text,
                      context: context,

                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                    backgroundColor: Color(0xff061a2a),
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),



                SizedBox(height: 10),
                Container(
                     width: 200,
                    child: Align(
                        alignment: Alignment.center,
                        child: Lottie.asset('lib/images/LottieLogin.json')
                    )
                ),
                Obx(() => Text(
                  loginController.loginMessage.value,
                  style: TextStyle(
                    color: loginController.loginMessage.value == 'Login successful'
                        ? Colors.green
                        : Colors.red,
                    fontSize: 16,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

