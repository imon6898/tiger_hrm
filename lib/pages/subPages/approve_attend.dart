// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ApproveAttendPage extends StatefulWidget {
  const ApproveAttendPage({super.key});

  @override
  State<ApproveAttendPage> createState() => _ApproveAttendPageState();
}

class _ApproveAttendPageState extends State<ApproveAttendPage> {
  @override
  TextEditingController _dateController = TextEditingController();
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: const Text(
          style:
          TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          'Approve Attendance',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(padding: EdgeInsets.all(20),),
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 20, 5),
                    child: Text(
                      'Apply Date',
                      style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 20, 0),
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                        filled: true,
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.redAccent, width: 2)),

                        prefixIcon: Icon(Icons.calendar_today),hintText: '${now.day}-${now.month}-${now.year}'),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                ),

              ],
            ),
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,

                    ),
                    child: Row(children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        child: Icon(Icons.restart_alt),
                      ),
                      Text(
                        'Save Attend.',
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,

                    ),
                    child: Row(children: [

                      Text(
                        'Show Data ',
                        style: TextStyle(fontSize: 20),
                      )
                    ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Color(0xFFBCC2C2))),
                          disabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Color(0xFFBCC2C2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 2, color: Colors.blueAccent)),
                          hintText: 'Search employee by EmpCode/EmpName/Branch/Department/Designation',
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {  },
                    child: Icon(Icons.search),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Table(
                defaultColumnWidth: FixedColumnWidth(120.0),
                border: TableBorder.all(
                    color: Color(0xffd9d9d9),
                    style: BorderStyle.solid,
                    width: 2),
                children: const [
                  TableRow(
                      decoration: BoxDecoration(color: Colors.blueAccent),
                      children: [
                        Column(children:[Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 5),
                          child: Text('#SN', style: TextStyle(fontSize: 20.0,color: Colors.white)),
                        )]),
                        Column(children:[Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 5),
                          child: Text('Month', style: TextStyle(fontSize: 20.0,color: Colors.white)),
                        )]),
                        Column(children:[Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 5),
                          child: Text('Assets', style: TextStyle(fontSize: 20.0,color: Colors.white)),
                        )]),


                      ]),
                  TableRow( children: [
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('1',style: TextStyle(fontSize: 18),),
                    )]),
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('0',style: TextStyle(fontSize: 18),),
                    )]),
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('0',style: TextStyle(fontSize: 18),),
                    )]),


                  ]),
                  TableRow( children: [
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('2',style: TextStyle(fontSize: 18),),
                    )]),
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('0',style: TextStyle(fontSize: 18),),
                    )]),
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('0',style: TextStyle(fontSize: 18),),
                    )]),


                  ]),
                  TableRow( children: [
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('3',style: TextStyle(fontSize: 18),),
                    )]),
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('0',style: TextStyle(fontSize: 18),),
                    )]),
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('0',style: TextStyle(fontSize: 18),),
                    )]),


                  ]),
                  TableRow( children: [
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('4',style: TextStyle(fontSize: 18),),
                    )]),
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('0',style: TextStyle(fontSize: 18),),
                    )]),
                    Column(children:[Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                      child: Text('0',style: TextStyle(fontSize: 18),),
                    )]),


                  ]),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }
}
