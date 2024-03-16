import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:tiger_erp_hrm/utils/geolocator.dart';
import 'LoginApiController/loginModel.dart';
import 'controller/dashboard_controller.dart';
import 'pages/authPages/login_page.dart';
import 'pages/home_page/Component/dash_board.dart';

class SplashScreen extends StatefulWidget {
  final storage = const FlutterSecureStorage();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation; // Add this animation
  final DashboardController _controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your background animation or image
          Lottie.asset(
            'lib/images/screen.lottie.json',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Your positioned widget
          Positioned(
            top: MediaQuery.of(context).size.height / 3,
            left: 0,
            right: 0,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                children: [
                  RotationTransition(
                    turns: _rotationAnimation, // Apply rotation animation here
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Your Image
                        Image.asset(
                          'lib/images/logoDailystar.png',
                          width: 400,
                          height: 400,
                        ),

                        const SizedBox(height: 100,),
                      ],
                    ),
                  ),

                  const Text("Powered by Tiger ERP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkConnectivityThenNavigate(); // Check connectivity before navigating
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Initialize Scale Animation
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize Rotation Animation
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void checkConnectivityThenNavigate() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If there is no internet connection, show a message box
      showNoInternetDialog();
    } else {
      // If there is internet connection, proceed with navigation
      navigateToNextScreen();
    }
  }

  void showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please connect to the internet to continue.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Exit the app if the user dismisses the dialog
                exit(0);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  void navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check if the user is logged in using Hive
    bool isLoggedIn = await checkIfUserIsLoggedIn();

    if (isLoggedIn) {
      // Retrieve user data from Hive
      var box = Hive.box('loginData');
      var userDataJson = box.get('userData');

      print('userDataJson: $userDataJson'); // Add this line for debugging

      if (userDataJson != null) {
        try {
          // Explicitly convert userDataJson to a string and trim whitespaces
          String jsonString = userDataJson.toString().trim();

          // Check if jsonString is not empty
          if (jsonString.isNotEmpty) {
            // Decode the JSON string more gracefully
            var decodedUserData = json.decode(jsonString);
            if (decodedUserData is Map<String, dynamic>) {
              _controller.loginModel = LoginModel.fromJson(decodedUserData);
              // Get the current location when navigating to DashBoard
              _controller.currentLocation = await LocationService.get();

              print('Decoded userData: ${_controller.loginModel}'); // Add this line for debugging

              // Pass the actual data to DashBoard
              Get.off(const DashBoard());
              return; // Exit the method after navigation
            } else {
              print('Decoded userData is not a Map');
            }
          } else {
            print('JSON string is empty');
          }
        } catch (e) {
          // Log the error and take appropriate action
          print('Error decoding userData: $e');
        }
      } else {
        // Handle the case where userDataJson is null
        print('userDataJson is null');
      }
    }

    // If no saved credentials are found or encountered any error, navigate to the login screen
    Get.off(LoginPage());
  }

  Future<bool> checkIfUserIsLoggedIn() async {
    // Check if the authentication token is present in Hive
    var box = Hive.box('loginData');
    return box.get('userData') != null;
  }

  void handleDecodingError() {
    // Handle the error, e.g., show an error message
    Get.snackbar(
      'Error',
      'An error occurred while decoding user data. Please log in again.',
      snackPosition: SnackPosition.BOTTOM,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred while decoding user data. Please log in again.'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to the login screen
    Get.off(LoginPage());
  }
}
