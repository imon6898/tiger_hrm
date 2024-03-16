
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_erp_hrm/pages/subPages/change_pass/changepass.dart';
import 'package:tiger_erp_hrm/pages/subPages/my_tasks.dart';
import '../../../Coustom_widget/neumorphic_button.dart';
import '../../../controller/dashboard_controller.dart';
import '../../../controller/profile_controller.dart';
import '../../all_attendance_pages/attendance_pages_dashboard.dart';
import '../../all_leave_pages/leave_pages_dashboard.dart';
import '../../authPages/login_page.dart';
import '../../privacypolicy/privacy_policy.dart';
import '../../subPages/myinfo/my_info.dart';
import '../../subPages/salaryandpayslip/salary_and_paySlip.dart';
import 'package:badges/badges.dart' as custom_badges;


class DashBoard extends StatefulWidget {

  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProfileController profileController = Get.put(ProfileController());
  final DashboardController _controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    profileController.fetchProfile();
    // Call your function to fetch data here
    _controller.fetchLeaveApprovalBadgeCount();
    _controller.fetchLeaveApprovalByHrBadgeCount();
    _controller.fetchLeaveApprovalSupBadgeCount();
  }



  final List<Data> _photos = [
    Data(image: 'lib/images/profilicon.png', text: 'Profile'),
    Data(image: 'lib/images/A1.png', text: 'Attendance'),
    Data(image: 'lib/images/A3.png', text: 'Leave'),
    Data(image: 'lib/images/SalarySlipp.png', text: 'Salary & PaySlip'),
    Data(image: 'lib/images/mytaskicon.png', text: 'My Tasks'),
    Data(image: 'lib/images/Privacy&policy.png', text: 'Policy'),
  ];

  @override
  Widget build(BuildContext context) {
    String userName = _controller.loginModel?.userName ?? 'N/A';
    String empCode = _controller.loginModel?.empCode ?? 'N/A';
    int? companyId = _controller.loginModel?.companyId;
    String companyName = _controller.loginModel?.companyName ?? 'N/A';
    String empName = _controller.loginModel?.empName ?? 'N/A';
    String empMail = _controller.loginModel?.empMail ?? 'N/A';
    String reportTo = _controller.loginModel?.reportTo ?? 'N/A';
    String recommendToEmail = _controller.loginModel?.recommendToEmail ?? 'N/A';
    int? gradeValue = _controller.loginModel?.gradeValue;
    int? gender = _controller.loginModel?.gender;
    int? userTypeId = _controller.loginModel?.userTypeId;
    Position? location = _controller.currentLocation;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: Container(
          margin: const EdgeInsetsDirectional.fromSTEB(10, 5, 5, 5),
          child: const CircleAvatar(
            backgroundImage: AssetImage('lib/images/theDailyStariconBlack.png'),
            radius: 30,
          ),
        ),
        title: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        _controller.loginModel?.userName ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Kanit',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xffe9f0fd),
        child: GridView.builder(
          itemCount: _photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: _photos[index].text == 'Profile'
                  ? Obx(() {
                if (profileController.profiles.isNotEmpty && profileController.profiles[0].photo != null) {
                  return NeumorphicButton(
                    imagePathMemory: profileController.profiles.isNotEmpty && profileController.profiles[0].photo != null ? profileController.profiles[0].photo! // Base64 string
                        : _photos[index].image, // Asset path
                    buttonText: _photos[index].text,
                    onTap: () => _handleButtonTap(_photos[index].text),
                  );


                } else {
                  return NeumorphicButton(
                    imagePathAsset: _photos[index].image,
                    buttonText: _photos[index].text,
                    onTap: () => _handleButtonTap(_photos[index].text),
                  );
                }
              })
                  : _photos[index].text == 'Leave'
                  ? _buildButtonWithBadge(_photos[index], userName, empCode, companyId, companyName, reportTo, gradeValue, gender, userTypeId)
                  : NeumorphicButton(
                imagePathAsset: _photos[index].image,
                buttonText: _photos[index].text,
                onTap: () => _handleButtonTap(_photos[index].text),
              ),
            );
          },
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Image.asset(
              'lib/images/DSHRMSlogo.png',
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric( horizontal: 10,vertical: 24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _logout,
                    child: const Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: 30,
                                color: Color(0xff04a2e3),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff04a2e3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToChangePassword,
                    child: const Card(
                      color: Colors.transparent,
                      elevation: 0,
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.change_circle_outlined,
                                size: 30,
                                color: Color(0xff04a2e3),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff04a2e3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonWithBadge(Data data, String userName, String empCode, int? companyId, String companyName, String reportTo, int? gradeValue, int? gender, int? userTypeId) {
    print("totalLeaveBadgeCount: ${_controller.totalLeaveBadgeCount.value}");
    print("badgeCountLeaveApprovalByHR: ${_controller.badgeCountLeaveApprovalByHR.value}");
    print("badgeCountLeaveApproval: ${_controller.badgeCountLeaveApproval.value}");
    return Obx(() {
      int badgeCount = 0;

        switch (data.text) {
          case 'Leave':
            badgeCount = _controller.totalLeaveBadgeCount.value;
            break;
          default:
            break;
        }

        if (badgeCount > 0) {
          return custom_badges.Badge(
            badgeContent: Text('${_controller.totalLeaveBadgeCount.value}', style: const TextStyle(color: Colors.white, fontSize: 18)),
            badgeStyle: const BadgeStyle(badgeColor: Colors.red),
            position: BadgePosition.topEnd(top: -8, end: -2),
            child: NeumorphicButton(
              imagePathAsset: data.image,
              buttonText: data.text,
              onTap: () => _handleButtonTap(data.text),
            ),
          );
        } else {
          return NeumorphicButton(
            imagePathAsset: data.image,
            buttonText: data.text,
            onTap: () => _handleButtonTap(data.text),
          );
        }
      },
    );
  }

  void _handleButtonTap(String buttonText) {
    switch (buttonText) {
      case 'Profile':
        _navigateToProfile();
        break;
      case 'Attendance':
        _navigateToAttendance();
        break;
      case 'Leave':
        _navigateToLeave();
        break;
      case 'Salary & PaySlip':
        _navigateToSalaryAndPaySlip();
        break;
      case 'My Tasks':
        _navigateToMyTasks();
        break;
      case 'Policy':
        _navigateToPrivacyPolicy();
        break;
    }
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyInfo(),
      ),
    );
  }

  void _navigateToAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AttendancePagesDashBoard(),
      ),
    );
  }

  void _navigateToLeave() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LeavePagesDashBoard(),
      ),
    );
  }

  void _navigateToMyTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyTasksPage(),
      ),
    );
  }

  void _navigateToSalaryAndPaySlip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SalaryAndPaySlip(),
      ),
    );
  }


  void _navigateToPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicy(),
      ),
    );
  }

  Future<void> _logout() async {
    await Hive.close();
    await Hive.deleteBoxFromDisk('loginData');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Get.offAll(() => LoginPage());
  }

  void _navigateToChangePassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePass(),
      ),
    );
  }
}

class Data {
  String image;
  String text;

  Data({required this.image, required this.text});
}
