import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:smartwater/models/user_model.dart';
import 'package:smartwater/utils/hash.dart';
import 'package:smartwater/views/home.dart';
import '../utils/env.dart';

class AUTHENTICATION {
  static Future<void> callApiRegister(
      BuildContext context, USER userInput) async {
    try {
      final response = await http.post(
        Uri.parse('${ENV.urlApi}register_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userInput.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData == "1") {
          String? emailHome = userInput.userEmail;
          String? passwordHome = userInput.userPassword;
          showWarningDialogSuccess(context, emailHome, passwordHome);
        } else {
          showWarningDialog(context, 'Error: $responseData');
        }
      } else {
        showWarningDialog(
            context, 'Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      showWarningDialog(context, 'ผิดพลาด: โปรดทำการเชื่อมต่ออินเตอร์เน็ต');
      ;
    }
  }

  static Future<void> callApiLogin(BuildContext context, USER userInput) async {
    try {
      final response = await http.post(
        Uri.parse('${ENV.urlApi}login_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userInput.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData == "1") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HOME_UI(
                email: userInput.userEmail,
                password: userInput.userPassword,
              ),
            ),
          );
        } else {
          showWarningDialog(context, 'Error: $responseData');
        }
      } else {
        showWarningDialog(
            context, 'Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      showWarningDialog(context, 'ผิดพลาด: โปรดทำการเชื่อมต่ออินเตอร์เน็ต');
    }
  }

  static void showWarningDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children: [
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  side: BorderSide(
                      strokeAlign: MediaQuery.of(context).size.width * 0.009,
                      color: Color.fromARGB(255, 0, 0, 0))),
              backgroundColor: Color.fromARGB(255, 233, 127, 127),
              title: Center(
                child: Text(
                  'คำเตือน',
                  style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.1),
                ),
              ),
              content: Container(
                child: Text(
                  msg,
                  style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              icon: Icon(Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * 0.1),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'ตกลง',
                      style: GoogleFonts.kanit(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: MediaQuery.of(context).size.width * 0.05),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }

  static void showWarningDialogSuccess(
    BuildContext context,
    String? emailHome,
    String? passwordHome,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
              side: BorderSide(
                  strokeAlign: MediaQuery.of(context).size.width * 0.009,
                  color: Color.fromARGB(255, 0, 0, 0))),
          backgroundColor: Colors.blue[100],
          title: Center(
            child: Text(
              'สมัครสมาชิกสำเร็จ',
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.09,
              ),
            ),
          ),
          content: Container(
            child: Text(
              'กดปุ่ม ตกลง เพื่อเข้าสูระบบ\nหรือกดปุ่ม ยกเลิก เพื่อทำรายการอีกครั้ง',
              style: GoogleFonts.kanit(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.05),
            ),
          ),
          icon: Icon(Icons.water_drop_rounded,
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.1),
          actions: [
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HOME_UI(
                                email: emailHome,
                                password: passwordHome,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'ตกลง',
                          style: GoogleFonts.kanit(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 254, 105, 105),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: GoogleFonts.kanit(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
