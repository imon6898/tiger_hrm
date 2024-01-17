// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArriveOfficeTime extends StatefulWidget {
  const ArriveOfficeTime({super.key});

  @override
  State<ArriveOfficeTime> createState() => _ArriveOfficeTimeState();
}

class _ArriveOfficeTimeState extends State<ArriveOfficeTime> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime currentTime = DateTime.now();
    String formattedTime = DateFormat('h:mm a').format(currentTime);
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date: ',style: TextStyle(fontSize: 20,fontFamily: 'Readex Pro',fontWeight: FontWeight.w500)),
                              Text(
                                '${DateFormat('dd-MMM-yyyy').format(now)}',
                                style: TextStyle(fontSize: 25,fontFamily: 'Readex Pro',fontWeight: FontWeight.w500),textAlign: TextAlign.left,

                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time: ',style: TextStyle(fontSize: 20,fontFamily: 'Readex Pro',fontWeight: FontWeight.w500)),
                            Text(
                              '$formattedTime',
                              style: TextStyle(fontSize: 25,fontFamily: 'Readex Pro',fontWeight: FontWeight.w500),textAlign: TextAlign.left,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(30, 0, 20, 5),
                            child: Text(
                              'Remarks',
                              style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 0, 20, 0),
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
                                // filled: true,
                                // fillColor: Color(0xffececec),
                                hintText: 'Remarks'
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: Size(34, 40),

                        shape: StadiumBorder()// Background color
                    ),
                    child: Row(children: [
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: Icon(Icons.access_time, color: Colors.white),
                      ),
                      Text(
                        'Check IN',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    ]),
                  ),
                ],
              ),

            ],
          ),
      ),
    );
  }
}
