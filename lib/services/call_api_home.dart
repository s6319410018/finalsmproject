import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartwater/models/aicontrol_model.dart';
import 'package:smartwater/models/datatable_model.dart';
import 'package:smartwater/models/realtime_model.dart';
import 'package:smartwater/models/solenoidcontrol_model.dart';
import 'package:smartwater/models/timecontrol_model.dart';
import 'package:smartwater/models/user_model.dart';
import 'package:smartwater/utils/env.dart';

class CALLAPIDATAHOME {
  static Future<List<REALTIME>> callApiRealtime(
      BuildContext context, USER userInput) async {
    try {
      final response = await http.post(
        Uri.parse('${ENV.urlApi}realtime_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userInput.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is List) {
          List<REALTIME> realtimeDataList =
              responseData.map((json) => REALTIME.fromJson(json)).toList();
          return realtimeDataList;
        } else {
          showWarningDialog(context, 'ผิดพลาดไม่สามารถตอบสนองกับเซิร์ฟเวอร์');
        }
      } else {
        showWarningDialog(context, 'ผิดพลาด: ${response.statusCode}');
      }
    } catch (e) {
      showWarningDialog(context, 'ผิดพลาดโปรดทำรายการอีกครั้ง');
    }
    // Return an empty list if there's an error
    return [];
  }

  static Future<List<DATATABLE>> callApiDatatable(
      BuildContext context, USER userInput) async {
    try {
      final response = await http.post(
        Uri.parse('${ENV.urlApi}datatable_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userInput.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is List) {
          List<DATATABLE> realtimeDataList =
              responseData.map((json) => DATATABLE.fromJson(json)).toList();

          return realtimeDataList;
        } else {
          showWarningDialog(context, 'ผิดพลาดรูปแบบการตอบกลับไม่ถูกต้อง');
        }
      } else {
        showWarningDialog(context, 'ผิดพลาดไม่สามารถตอบสนองกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      showWarningDialog(context, 'ผิดพลาดโปรดทำรายการอีกครั้ง');
    }
    // Return an empty list if there's an error
    return [];
  }

  static Future<void> callApiUpdatetime(
      BuildContext context, TIMECONTROL timeInput) async {
    try {
      final responsetime = await http.post(
        Uri.parse('${ENV.urlApi}update_time_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(timeInput.toJson()),
      );

      if (responsetime.statusCode == 200) {
        final responseData = jsonDecode(responsetime.body);
        if (responseData == "1") {
          showWarningDialogSuccess(
              context, "\t\t\t\t\t\t\t\t\t\tทำรายการสำเร็จ");
        } else if (responseData == "2") {
          showWarningDialog(context, "โปรดทำการปิดโหมดปกติก่อนทำรายการ");
        } else if (responseData == "3") {
          showWarningDialog(context, "โปรดทำการปิดโหมดอัตโนมัติก่อนทำรายการ");
        } else {
          showWarningDialog(context, 'ผิดพลาด: $responseData');
        }
      } else {
        showWarningDialog(context, 'ผิดพลาดไม่สามารถตอบสนองกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      showWarningDialog(context, 'ผิดพลาดโปรดทำรายการอีกครั้ง');
    }
  }

  static Future<void> callApiUpdateSolenoid(
      BuildContext context, SOLENOIDCONTROL solenoidInput) async {
    try {
      final response = await http.post(
        Uri.parse('${ENV.urlApi}update_solenoid_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(solenoidInput.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData == "1") {
          showWarningDialogSuccess(context, "\t\t\tSuccess");
        } else if (responseData == "2") {
          showWarningDialogSuccess(
              context, "โปรดทำการปิดโหมดอัตโนมัติก่อนทำรายการ");
        } else if (responseData == "3") {
          showWarningDialogSuccess(
              context, "โปรดทำการยกเลิกการตั้งเวลาก่อนทำรายการ");
        } else {
          showWarningDialog(context, 'ผิดพลาด: $responseData');
        }
      } else {
        showWarningDialog(context, 'ผิดพลาดไม่สามารถตอบสนองกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      showWarningDialog(context, 'ผิดพลาดโปรดทำรายการอีกครั้ง ');
    }
  }

  static Future<void> callApiUpdateAi(
    BuildContext context,
    AICONTROL aiInput,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ENV.urlApi}update_ai_api.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(aiInput.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData == "1") {
          showWarningDialogSuccess(context, "\t\t\tSuccess");
        } else if (responseData == "2") {
          showWarningDialogSuccess(context, "โปรดทำการปิดโหมดปกติก่อนทำรายการ");
        } else if (responseData == "3") {
          showWarningDialogSuccess(
              context, "โปรดทำการยกเลิกการตั้งเวลาก่อนทำรายการ");
        } else {
          showWarningDialog(context, 'ผิดพลาด: $responseData');
        }
      } else {
        showWarningDialog(context, 'ผิดพลาดไม่สามารถตอบสนองกับเซิร์ฟเวอร์');
      }
    } catch (e) {
      showWarningDialog(context, 'ผิดพลาดโปรดทำรายการอีกครั้ง');
    }
  }

  static void showWarningDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: BorderSide(
              width: MediaQuery.of(context).size.width * 0.009,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 233, 127, 127),
          title: Center(
            child: Text(
              'คำเตือน',
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.1,
              ),
            ),
          ),
          content: Container(
            child: Text(
              msg,
              style: GoogleFonts.kanit(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
          ),
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: MediaQuery.of(context).size.width * 0.1,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static void showWarningDialogSuccess(BuildContext context, msg) {
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
              backgroundColor: Color.fromARGB(255, 141, 244, 158),
              title: Center(
                child: Text(
                  'คำเตือน',
                  style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.1),
                ),
              ),
              content: Card(
                color: const Color.fromARGB(0, 255, 255, 255),
                child: Text(
                  msg,
                  style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
              icon: Icon(FontAwesomeIcons.clock,
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
}
