import 'package:get/get.dart';
import '../api_service_info/api_service_profile.dart';
import '../profile_models/profile_model.dart';

class ProfileController extends GetxController {
  var profiles = <ProfileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void fetchProfile(String empCode) async {
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
