import 'dart:convert';
import 'dart:ffi';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwater/authentication/register.dart';
import 'package:smartwater/models/user_model.dart';
import 'package:smartwater/services/call_api_authentication.dart';
import 'package:smartwater/utils/env.dart';
import 'package:http/http.dart' as http;
import 'package:smartwater/utils/hash.dart';

class LOGIN_UI extends StatefulWidget {
  const LOGIN_UI({super.key});

  @override
  State<LOGIN_UI> createState() => _LOGIN_UIState();
}

class _LOGIN_UIState extends State<LOGIN_UI> {
  bool isShowpassword = false;
  bool _isChecked = false;

  Future<dynamic> _handleRemeberme(value) async {
    if (input_email.text != '' && input_password.text != '') {
      USER userInput = USER(
        userEmail: input_email.text,
        userPassword: HASH.hash_md5(input_password.text),
      );
      try {
        final response = await http.post(
          Uri.parse('${ENV.urlApi}login_api.php'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userInput.toJson()),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData == '1') {
            setState(() {
              _isChecked = value;
              if (_isChecked == false) {
                print('not remember');
                SharedPreferences.getInstance().then(
                  (prefs) {
                    prefs.setBool("remember_me", false);
                    prefs.setString('email', 'null');
                    prefs.setString('password', 'null');
                  },
                );
              } else {
                print('remember');
                SharedPreferences.getInstance().then(
                  (prefs) {
                    prefs.setBool("remember_me", value);
                    prefs.setString('email', input_email.text);
                    prefs.setString(
                        'password', HASH.hash_md5(input_password.text));
                  },
                );
              }
            });
          }
        } else {
          AUTHENTICATION.showWarningDialog(context, "ไม่สามารถจดจำข้อมูล");
        }
      } catch (e) {
        return AUTHENTICATION.showWarningDialog(context, 'ลองอีกครั้ง');
      }
    } else {
      AUTHENTICATION.showWarningDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
    }
  }

  final fromKey = GlobalKey<FormState>();
  TextEditingController input_email = TextEditingController();
  TextEditingController input_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_register_bg.jpg"), /////
              fit: BoxFit.cover,

              filterQuality: FilterQuality.high,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),
                  Image.asset('assets/images/icon.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                      color: Color(0xFF7BD5E5)),
                  Text('มาตรวัดน้ำอัจฉริยะ',
                      style: GoogleFonts.kanit(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.09,
                          color: const Color.fromARGB(255, 0, 0, 0))),
                  Center(
                    child: Form(
                      key: fromKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    left: MediaQuery.of(context).size.width *
                                        0.09,
                                    right: MediaQuery.of(context).size.width *
                                        0.09),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: Color.fromARGB(255, 0, 0, 0),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 0, 0, 0)), //<--
                                    obscureText: false,
                                    decoration: InputDecoration(
                                        hintText:
                                            'กรุณาป้อนอีเมล เช่น 123@gmail.com',
                                        hintStyle: GoogleFonts.kanit(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white70)),
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 220, 220, 220)),
                                        label: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.email_rounded),
                                                  Text(
                                                    '   กรุณาป้อนอีเมล',
                                                    style: GoogleFonts.kanit(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),

                                    controller: input_email,

                                    validator: (value) {
                                      const pattern =
                                          r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                                          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                                          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                                          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                                          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                                          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                                          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                                      final regex = RegExp(pattern);
                                      if (value!.isEmpty) {
                                        return 'กรุณาป้อนอีเมลอีกครั้ง';
                                      } else if (!regex.hasMatch(value)) {
                                        return 'รูปแบบผิดพลาด';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                    left: MediaQuery.of(context).size.width *
                                        0.09,
                                    right: MediaQuery.of(context).size.width *
                                        0.09),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,

                                    cursorColor: Color.fromARGB(255, 0, 0, 0),
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 0, 0, 0)), //<--
                                    obscureText: !isShowpassword,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (isShowpassword == true) {
                                                isShowpassword = false;
                                              } else {
                                                isShowpassword = true;
                                              }
                                            });
                                          },
                                          icon: isShowpassword == true
                                              ? Icon(
                                                  Icons.visibility,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                )
                                              : Icon(
                                                  Icons.visibility_off,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                        ),
                                        hintText:
                                            'ป้อนรหัสผ่านตั้งแต่ 6 ตัวอักษร',
                                        hintStyle: GoogleFonts.kanit(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white70)),
                                        labelStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 220, 220, 220)),
                                        label: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Row(
                                            children: [
                                              Icon(Icons.lock),
                                              Text(
                                                '   กรุณาป้อนรหัสผ่าน',
                                                style: GoogleFonts.kanit(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        )),
                                    controller: input_password,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'ป้อนรหัสผ่านอีกครั้ง';
                                      } else if (value.length < 6) {
                                        return 'รหัสต้ังแต่ 6 ตัวอักษรขึ้นไป';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.06),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        fillColor: MaterialStateProperty.all(
                                            Color.fromARGB(0, 255, 255, 255)),
                                        focusColor: Colors.yellow,
                                        shape: CircleBorder(),
                                        checkColor: Colors.black,
                                        hoverColor: Colors.white,
                                        value: _isChecked,
                                        onChanged: _handleRemeberme,
                                      ),
                                      Text(
                                        "จำการเข้าใช้งาน",
                                        style: GoogleFonts.kanit(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              ElevatedButton(
                                onPressed: () {
                                  bool pass = fromKey.currentState!.validate();
                                  if (pass) {
                                    USER userInput = USER(
                                      userEmail: input_email.text,
                                      userPassword:
                                          HASH.hash_md5(input_password.text),
                                    );
                                    print(
                                        'eeeeeeeeeeeeeee${userInput.userPassword}');
                                    AUTHENTICATION.callApiLogin(
                                        context, userInput);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(184, 19, 135, 197),
                                  textStyle: TextStyle(
                                    fontSize: 32.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.01,
                                    left: MediaQuery.of(context).size.width *
                                        0.15,
                                    right: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                  child: Text('เข้าสู่ระบบ',
                                      style: GoogleFonts.kanit(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ยังไม่มีรหัสผ่าน',
                                    style: GoogleFonts.kanit(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => REGISTER_UI(),
                                          ));
                                    },
                                    child: Text(
                                      'สมัครสมาชิกตอนนี้',
                                      style: GoogleFonts.kanit(
                                          color: Colors.blue[400],
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.06),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),
        ),
      ],
    );
  }
}
