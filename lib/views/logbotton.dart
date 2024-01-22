import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isButtonLocked = true;

  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  Future<void> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isFirstTime = prefs.getBool('first_time') ?? true;

    if (isFirstTime) {
      // ถ้าครั้งแรกระหว่างที่ใช้งาน
      // บันทึกเวลาปัจจุบัน
      prefs.setBool('first_time', false);
      prefs.setInt('start_time', DateTime.now().millisecondsSinceEpoch);
    } else {
      // ไม่ใช่ครั้งแรก, ตรวจสอบว่าผ่านไปหนึ่งเดือนหรือไม่
      int startTime = prefs.getInt('start_time') ?? 0;
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      if (currentTime - startTime >= 30 * 24 * 60 * 60 * 1000) {
        // ผ่านไปหนึ่งเดือน
        setState(() {
          isButtonLocked = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Lock Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: isButtonLocked ? null : () => print('Button pressed!'),
          child: Text('My Button'),
        ),
      ),
    );
  }
}
