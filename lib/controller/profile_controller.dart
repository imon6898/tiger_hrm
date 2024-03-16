import 'package:get/get.dart';
import '../../../../controller/dashboard_controller.dart';
import '../pages/subPages/myinfo/components/api_service_info/api_service_profile.dart';
import '../pages/subPages/myinfo/components/profile_models/profile_model.dart';

class ProfileController extends GetxController {

  var profiles = <ProfileModel>[].obs;
  var dashboardControl = Get.put(DashboardController());

  @override
  void onInit() {
    super.onInit();
  }

  void fetchProfile() async {
    String empCode = dashboardControl.loginModel?.empCode ?? ''; // Assuming empCode is available in loginModel
    print('Fetching profile for empCode: $empCode'); // Print empCode here
    try {
      var fetchedProfiles = await ApiServiceProfile.fetchGetProfile(empCode);
      if (fetchedProfiles.isNotEmpty) {
        profiles.value = fetchedProfiles;
      } else {
        profiles.value = [ProfileModel()];
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      profiles.value = [ProfileModel()];
    }
  }
}
