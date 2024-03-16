import 'package:flutter/material.dart';
import 'Components/custom_edit_table_hr.dart';

class LeaveApproveByHr extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  final String reportTo;
  final int userTypeId;
  const LeaveApproveByHr({
    super.key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    required this.reportTo,
    required this.userTypeId,
  });
  @override
  State<LeaveApproveByHr> createState() => _LeaveApproveByHrState();
}

class _LeaveApproveByHrState extends State<LeaveApproveByHr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9f0fd),
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
        ),
        title: const Text(
          style:
          TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          'Leave Approve By HR',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CustomEditTableHr(
                      //token: widget.token,
                      userName: widget.userName,
                      empCode: widget.empCode,
                      companyID: widget.companyID,
                      companyName: widget.companyName,
                      reportTo: widget.reportTo,
                      userTypeId: widget.userTypeId ?? 0,
                    ),
                  ),
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }
}
