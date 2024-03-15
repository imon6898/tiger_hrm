import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../LoginApiController/loginController.dart';
import '../profile_models/profile_model.dart';

class ApiServiceProfile {
  static Future<List<ProfileModel>> fetchGetProfile(String empcode) async {
    var headers = {
      'Authorization': BaseUrl.authorization, // Replace with your authorization header
    };
    var uri = Uri.parse('http://103.118.19.110:7021/api/v1/GetEmployeeInfo/$empcode');

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // Parse the response body as a list
      final List<dynamic> responseProfileData = json.decode(response.body);
      // Map each element of the list to a ProfileModel object
      List<ProfileModel> profiles = responseProfileData.map((data) => ProfileModel.fromJson(data)).toList();
      return profiles;
    } else {
      // If there's an error, throw an exception
      throw Exception('Failed to load profile data: ${response.reasonPhrase}');
    }
  }
}

