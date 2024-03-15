import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Coustom_widget/common_methods.dart';
import '../../Coustom_widget/single_mobile_field_widget.dart';
import '../../Coustom_widget/single_password_field_widget.dart';
import '../../LoginApiController/loginController.dart';
import '../../LoginApiController/loginModel.dart';
import '../home_page/Component/dash_board.dart';


class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final loginController = Get.put(LoginController());
   TextEditingController userNameController = TextEditingController();

   TextEditingController passwordController = TextEditingController();

  //TextEditingController userNameController = TextEditingController();
   SharedPreferences? sharedPreferences;

   String? save;
   Map<String, dynamic>? jsonResponse;
   CommonMethods cMethods = CommonMethods();

   bool rememberMe = false;
   bool passwordVisible = false;
   bool _isLoading = false;
   List<Map<String, String>> userCredentialsList = [];

  void signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.parse('${BaseUrl.baseUrl}/api/v1/login');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': '${BaseUrl.authorization}'
      };
      var body = json.encode({
        "userName": userNameController.text,
        "password": passwordController.text,
      });

      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (rememberMe) {
        saveCredentials(userNameController.text, passwordController.text);
      }

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        // Use the Login model to parse the JSON response
        var loginModel = LoginModel.fromJson(jsonResponse);

        // Save login data to SharedPreferences
        saveLoginData(loginModel);

        // Navigate to IndexingPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashBoard(loginModel: loginModel)),
        );

        // Remove this line
        // Get.off(IndexingPage(userData: loginModel));

        // Save username and password if 'Remember Me' is checked
        if (rememberMe) {
          saveCredentials(userNameController.text, passwordController.text);
        }
        cMethods.displaySnackBarGreen("Login successful", context);
      } else {
        print('Login failed: ${response.reasonPhrase}');
        cMethods.displaySnackBarRed("Login Failed", context);
      }
    } catch (error) {
      print('Error during login: $error');
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Save all login data using Hive
  void saveLoginData(LoginModel loginData) async {
    var box = await Hive.openBox('loginData');

    // Convert the Login object to a JSON string
    String jsonData = json.encode(loginData.toJson());

    box.put('userData', jsonData);
  }

  void saveCredentials(String userName, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);

    // Request permission to save password
    var status = await Permission.storage.request();
    prefs.setString('userName', userName);
    prefs.setString('password', password);
    if (rememberMe) {
      prefs.setString('password', password);
    }
    if (status.isGranted) {
      prefs.setString('password', password);

      // Save credentials to the list
      Map<String, String> credentials = {'userName': userName, 'password': password};
      userCredentialsList.add(credentials);

      // Save the updated list to SharedPreferences
      prefs.setString('userCredentialsList', json.encode(userCredentialsList));
    } else {
      print('Permission not granted to save password.');
    }
  }


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
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'lib/images/DSHRMSlogo.png',
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                ),

                Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 45,
                    letterSpacing: 7,
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                SingleMobileField(
                  controller: userNameController,
                  hint: "User Name",
                  label: "User Name",
                  //validator: Utils.validateMobile, // Pass the function without ()
                  textInputType: TextInputType.text,
                ),

                SizedBox(height: 10),
                SinglePasswordField(
                  controller: passwordController, // Pass the controller
                  hint: "Enter Password",
                  label: "Password",
                  //validator: Utils.passwordValidate,
                ),

                SizedBox(height: 17),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rememberMe = !rememberMe;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(
                            'Remember me',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetSandOtpPage()));
                        },
                        child: Text(
                          "Forget password",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 17),
                ElevatedButton(
                  onPressed: signIn,
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
                // Obx(() => Text(
                //   loginController.loginMessage.value,
                //   style: TextStyle(
                //     color: loginController.loginMessage.value == 'Login successful'
                //         ? Colors.green
                //         : Colors.red,
                //     fontSize: 16,
                //   ),
                // )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }
}

