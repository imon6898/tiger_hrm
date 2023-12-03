import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomDropdownTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final List<DropDownValueModel> items;
  final Function(String?)? onChanged;

  CustomDropdownTextField({
    Key? key,
    required this.hintText,
    required this.labelText,
    required this.items,
    this.onChanged, required TextEditingController controller,
  }) : super(key: key);

  @override
  _CustomDropdownTextFieldState createState() => _CustomDropdownTextFieldState();
}

class _CustomDropdownTextFieldState extends State<CustomDropdownTextField> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 10),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.blueAccent),
          ),
          filled: true,
          hintText: widget.hintText,
          labelText: widget.labelText,
          fillColor: Color(0xffececec),
        ),
        items: widget.items.map((DropDownValueModel item) {
          return DropdownMenuItem<String>(
            value: item.value,
            child: Text(item.name),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            widget.onChanged?.call(value);
          });
        },
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>?> fetchLeaveTypes() async {
  try {
    var headers = {
      'Authorization': 'Basic SFJEb3ROZXRBcHA6aHJAMTIzNA==',
    };
    var request = http.Request(
      'GET',
      Uri.parse('http://175.29.186.86:7021/api/v1/leave/get-leave-type/1/1'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return List<Map<String, dynamic>>.from(json.decode(responseBody));
    } else {
      // Handle API error
      print('API Error: ${response.reasonPhrase}');
      return null;
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    return null;
  }
}

class DropDownValueModel {
  final String name;
  final String value;

  DropDownValueModel({required this.name, required this.value});
}
