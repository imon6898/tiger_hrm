import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_flip/page_flip.dart';
import '../../../controller/profile_controller.dart';
import 'components/profile_models/profile_model.dart';


class MyInfo extends StatefulWidget {

  const MyInfo({Key? key}) : super(key: key);

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  late GlobalKey<PageFlipWidgetState> _controller;
  final ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _controller = GlobalKey<PageFlipWidgetState>();
    profileController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8cd2da),
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          textAlign: TextAlign.center,
        ),
      ),
      body: Obx(() {
        if (profileController.profiles.isNotEmpty) {
          // Display the last profile from the list
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: PageFlipWidget(
              backgroundColor: Colors.black,
              cutoffForward: 0.8,
              cutoffPrevious: 0.8,
              children: [
                PageOne(profile: profileController.profiles.single),
                PageTwo(),
                PageThree(),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No profile data available'));
        }
      }),
    );
  }
}

class PageOne extends StatelessWidget {
  final ProfileModel profile;

  PageOne({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          const Text('The Daily Star', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
          const Text('64-65, Kazi Nazrul Islam Avenue, Dhaka-1215', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16)),
          const Text('Personal File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Center(
                  child: profile.photo != null
                      ? Image.memory(base64Decode(profile.photo!)) // Decode base64 photo and display
                      : Image.asset('lib/images/theDailyStariconBlack.png'), // Default image if photo is null
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Text(profile.empCode ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(profile.empName ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text(profile.designation ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(profile.grade ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(profile.department ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(profile.dateOfJoining ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(child: Text('Page Two')),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(child: Text('Page Three')),
    );
  }
}

