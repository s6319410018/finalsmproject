import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwater/authentication/login.dart';
import 'package:smartwater/views/home.dart';

class SplashUI extends StatefulWidget {
  const SplashUI({Key? key}) : super(key: key);

  @override
  State<SplashUI> createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _loadUserEmailPassword();

    Future.delayed(
      Duration(seconds: 3),
      () {
        if (_email.isEmpty || _password.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LOGIN_UI(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HOME_UI(email: _email, password: _password),
            ),
          );
        }
      },
    );
  }

  void _loadUserEmailPassword() async {
    print("Load Email");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _email = prefs.getString("email") ?? "";
        _password = prefs.getString("password") ?? "";
      });
      print(_email);
      print(_password);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_register_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.15,
              left: MediaQuery.of(context).size.width * 0.15,
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Image.asset(
              'assets/images/icon.png',
              width: MediaQuery.of(context).size.width * 0.9,
              color: Color(0xFF85E8F7),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.7),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'มาตรวัดน้ำอัจฉริยะ',
                      style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                      ),
                    ),
                    Text(
                      'จัดทำขึ้นเพื่อทดสอบโปรเจค',
                      style: GoogleFonts.kanit(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            child: Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                child: CircularProgressIndicator(
                  semanticsLabel: AutofillHints.addressCity,
                  backgroundColor: Colors.transparent,
                  color: Colors.black38,
                  strokeWidth: MediaQuery.of(context).size.width * 0.02,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
