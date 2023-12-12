import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwater/authentication/login.dart';
import 'package:smartwater/models/aicontrol_model.dart';
import 'package:smartwater/models/datatable_model.dart';
import 'package:smartwater/models/realtime_model.dart';
import 'package:smartwater/models/solenoidcontrol_model.dart';
import 'package:smartwater/models/timecontrol_model.dart';
import 'package:smartwater/models/user_model.dart';
import 'package:smartwater/services/call_api_home.dart';
import 'package:smartwater/widget/widgetget_table.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class HOME_UI extends StatefulWidget {
  String? email;
  String? password;
  HOME_UI({
    Key? key,
    this.email,
    this.password,
  }) : super(key: key);

  @override
  State<HOME_UI> createState() => _HOME_UIState();
}

class _HOME_UIState extends State<HOME_UI> {
  ///////////////////////////////////
  final double _minScale = 0.5;
  final double _maxScale = 2.0;
  double opacityLevel = 1.0;
  double _currentScale = 1.0;
  @override
  final Color navigationBarColor =
      Color.fromARGB(255, 255, 255, 255); //ตัวแปรเก็บค่าสีของแท็บบาร์
  late PageController pageController;
  String? selectedValue;
  int selectedIndex = 0;

  late final double width;
  late final double height;
  late final int steps;

  ///////////////////////////////////////////////
  int? ControlAi;
  int? ControlSolenoid;
  bool water_icon = false;
  bool ai_icon = false;
  bool time_icon = false;
  bool isLoading = true;
  /////////////////////////////////////////////
  late List<REALTIME> _realtimeDataList;
  late DatadetailsDataSourcePage1
      _datadetailsDataSourcePage1; //ข้อมูลตารางหน้าที่หนึ่ง
  late DatadetailsDataSourcePage2
      _datadetailsDataSourcePage2; //ข้อมูลตารางหน้าที่หนึ่ง
  late DatadetailsDataSourcePage3
      _datadetailsDataSourcePage3; //ข้อมูลตารางหน้าที่หนึ่ง
  ////////////////////////////////////////////////////ส่วนของการตกแต่งคอลัมตารางเก็บข้อมูล
  List<GridColumn> _columns1 = [
    GridColumn(
      columnName: 'id',
      label: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            'ลำดับ',
            style: GoogleFonts.kanit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(
                  255, 255, 255, 255), // Change text color as needed
            ),
          ),
        ),
      ),
    ),
    GridColumn(
        columnName: 'statusai',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('อัตโนมัติ',
                  style: GoogleFonts.kanit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ))),
    GridColumn(
        columnName: 'statussolenoid',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('ปกติ',
                  style: GoogleFonts.kanit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ))),
    GridColumn(
        columnName: 'flowrate',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('การไหล',
                  style: GoogleFonts.kanit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ))),
    GridColumn(
        columnName: 'Pressure',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('ความดัน',
                  style: GoogleFonts.kanit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ))),
    GridColumn(
        columnName: 'date',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('วันที่',
                  style: GoogleFonts.kanit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ))),
    GridColumn(
        columnName: 'time',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('เวลา',
                  style: GoogleFonts.kanit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255))),
            ))),
  ];
  List<GridColumn> _columns2 = [
    GridColumn(
        columnName: 'id',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('ลำดับ',
                style: GoogleFonts.kanit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
    GridColumn(
        columnName: 'timecontrol',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('สถาณะการควบคุมด้วยเวลา',
                style: GoogleFonts.kanit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
    GridColumn(
        columnName: 'date',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('วันที่',
                style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
    GridColumn(
        columnName: 'time',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('เวลา',
                style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
  ];
  List<GridColumn> _columns3 = [
    GridColumn(
        columnName: 'id',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('ลำดับ',
                style: GoogleFonts.kanit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
    GridColumn(
        columnName: 'wateruseD',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('ปริมาณวันนี้',
                style: GoogleFonts.kanit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
    GridColumn(
        columnName: 'wateruseM',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('ปริมาณเดือนนี้',
                style: GoogleFonts.kanit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
    GridColumn(
        columnName: 'date',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('วันที่',
                style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
    GridColumn(
        columnName: 'time',
        label: Container(
            color: Color.fromARGB(255, 0, 0, 0),
            alignment: Alignment.center,
            child: Text('เวลา',
                style: GoogleFonts.kanit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255))))),
  ];
  /////////////////////////////////////////////////////////////////////
  ///
  ///

  @override
  void initState() {
    super.initState();
    _fetchDataPeriodically();
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    pageController = PageController(initialPage: selectedIndex);
    _realtimeDataList = [];
    _datadetailsDataSourcePage1 = DatadetailsDataSourcePage1([]);
    _datadetailsDataSourcePage2 = DatadetailsDataSourcePage2([]);
    _datadetailsDataSourcePage3 = DatadetailsDataSourcePage3([]);
  }

//////////////////////////////////////////////////////////////
  Timer? _fetchDataTimer;

  void _fetchDataPeriodically() {
    _fetchDataTimer ??= Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        USER userInput = USER(
          userEmail: widget.email,
          userPassword: widget.password,
        );

        List<REALTIME> data_update_realtime =
            await CALLAPIDATAHOME.callApiRealtime(context, userInput);
        List<DATATABLE> data_update_table =
            await CALLAPIDATAHOME.callApiDatatable(context, userInput);

        if (mounted) {
          setState(() {
            _realtimeDataList = data_update_realtime;
            _datadetailsDataSourcePage1.updateDataGrid(data_update_table);
            _datadetailsDataSourcePage2.updateDataGrid(data_update_table);
            _datadetailsDataSourcePage3.updateDataGrid(data_update_table);
            isLoading = false;
          });
        }
      } catch (error) {
        print('Error during data fetching: $error');
        // Handle the error as needed
      }
    });
  }

  void _stopFetchingDataPeriodically() {
    _fetchDataTimer?.cancel();
  }

  showWarningDialog(BuildContext context, String msg) {
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

  //////////////////////////////////////////datatestตัวแปรเก็บค่าON-OFF
  List<DateTime>? dateTimeList;
  //////////////////
  String hash_md5(String input) {
    var bytes = utf8.encode(input);
    var digest = md5.convert(bytes);
    return digest.toString();
  }
///////////////////////////////////////////////
//////////////////////////////////////////

  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF97D3DD),
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  color: Colors.black,
                  Icons.logout,
                ),
                tooltip: 'ปุ่มออกจากระบบ',
                focusColor: const Color.fromARGB(255, 0, 0, 0),
                hoverColor: const Color.fromARGB(255, 0, 0, 0),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      animation: CurvedAnimation(
                          parent: kAlwaysCompleteAnimation,
                          curve: Curves.bounceIn),
                      content: Text('ออกจากระบบสำเร็จ'),
                      backgroundColor: Color(0xFF4CA5B5),
                    ),
                  );

                  print("Sign Out");
                  SharedPreferences.getInstance().then(
                    (prefs) {
                      prefs.setBool("remember_me", false);
                      prefs.setString('email', 'null');
                      prefs.setString('password', 'null');
                    },
                  );
                  _stopFetchingDataPeriodically();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LOGIN_UI(),
                      ));
                },
              ),
            ],
            toolbarHeight: MediaQuery.of(context).size.width * 0.2,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            title: Text(
              'มาตรวัดน้ำอัจฉริยะ',
              style: GoogleFonts.kanit(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true),

        // backgroundColor: Colors.grey,
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: isLoading == true
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.35,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 255, 255),
                          semanticsLabel: Intl.defaultLocale,
                          strokeAlign:
                              MediaQuery.of(context).size.height * 0.005,
                          strokeCap: StrokeCap.round,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 255, 255, 255)),
                          strokeWidth:
                              MediaQuery.of(context).size.height * 0.005,
                        ),
                      ),
                    )
                  : Container(
                      //หน้าที่ 1
                      color: Color(0xFF97D3DD),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.0,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.0,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        right:
                                            MediaQuery.of(context).size.height *
                                                0.008,
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.0146,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            child: Card(
                                              borderOnForeground: true,
                                              surfaceTintColor: Colors.black,
                                              shadowColor: Colors.black,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              shape: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    strokeAlign:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.00,
                                                    style: BorderStyle.solid,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.000,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.002,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.001,
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                      ),
                                                      child: Text(
                                                        'โหมดอัตโนมัติ',
                                                        style:
                                                            GoogleFonts.kanit(
                                                          color:
                                                              Color(0xFF000000),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.055,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.001,
                                                      ),
                                                      ElevatedButton.icon(
                                                        onPressed: () {
                                                          if (true) {
                                                            AICONTROL aiInput =
                                                                AICONTROL(
                                                                    controlAi:
                                                                        "1",
                                                                    userEmail:
                                                                        widget
                                                                            .email,
                                                                    userPassword:
                                                                        widget
                                                                            .password);
                                                            CALLAPIDATAHOME
                                                                .callApiUpdateAi(
                                                                    context,
                                                                    aiInput);
                                                          }
                                                        },
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .robot),
                                                        label: Text(
                                                          "\t\t\t\tเปิดโหมด",
                                                          style: GoogleFonts.kanit(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    0),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.002,
                                                          ),
                                                          backgroundColor:
                                                              Color(0x937AE685),
                                                          fixedSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.002,
                                                      ),
                                                      ElevatedButton.icon(
                                                        onPressed: () {
                                                          AICONTROL aiInput =
                                                              AICONTROL(
                                                                  userEmail:
                                                                      widget
                                                                          .email,
                                                                  userPassword:
                                                                      widget
                                                                          .password,
                                                                  controlAi:
                                                                      "0");

                                                          CALLAPIDATAHOME
                                                              .callApiUpdateAi(
                                                                  context,
                                                                  aiInput);
                                                        },
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .usersGear),
                                                        label: Text(
                                                          "\t\t\t\tปิดโหมด",
                                                          style: GoogleFonts.kanit(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 0),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.002,
                                                          ),
                                                          backgroundColor:
                                                              Color(0xC7C87F7F),
                                                          fixedSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                      ),
                                                      Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.42,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.155,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                _realtimeDataList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              REALTIME
                                                                  realtimeData =
                                                                  _realtimeDataList[
                                                                      index];

                                                              if (realtimeData !=
                                                                  null) {
                                                                bool ai_icon =
                                                                    (realtimeData
                                                                            .realtimeAI ==
                                                                        1);

                                                                return Card(
                                                                  color: Colors
                                                                      .black,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          25),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(
                                                                            left:
                                                                                MediaQuery.of(context).size.width * 0.025,
                                                                            right:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                            top:
                                                                                MediaQuery.of(context).size.height * 0.005,
                                                                            bottom:
                                                                                MediaQuery.of(context).size.height * 0.005,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            ai_icon
                                                                                ? FontAwesomeIcons.toggleOn
                                                                                : FontAwesomeIcons.toggleOff,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                            size:
                                                                                MediaQuery.of(context).size.width * 0.1,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "${ai_icon ? "กำลังทำงาน" : "ไม่ทำงาน"}",
                                                                          style:
                                                                              GoogleFonts.kanit(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                // Display circular progress indicator when data is loading
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                );
                                                              }
                                                            },
                                                          )),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.003,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        right:
                                            MediaQuery.of(context).size.height *
                                                0.008,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            child: Card(
                                              borderOnForeground: true,
                                              surfaceTintColor: Colors.black,
                                              shadowColor: Colors.black,
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              shape: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                borderSide: BorderSide(
                                                    strokeAlign:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.00,
                                                    style: BorderStyle.solid,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.000,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.002,
                                                        bottom: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.001,
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                      ),
                                                      child: Text(
                                                        'โหมดธรรมดา',
                                                        style:
                                                            GoogleFonts.kanit(
                                                          color:
                                                              Color(0xFF000000),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.055,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.001,
                                                      ),
                                                      ElevatedButton.icon(
                                                        onPressed: () {
                                                          if (true) {
                                                            SOLENOIDCONTROL
                                                                solenoidInput =
                                                                SOLENOIDCONTROL(
                                                                    userEmail:
                                                                        widget
                                                                            .email,
                                                                    userPassword:
                                                                        widget
                                                                            .password,
                                                                    controlSolenoid:
                                                                        "1");

                                                            CALLAPIDATAHOME
                                                                .callApiUpdateSolenoid(
                                                                    context,
                                                                    solenoidInput);
                                                          }
                                                        },
                                                        icon: Icon(FontAwesomeIcons
                                                            .glassWaterDroplet),
                                                        label: Text(
                                                          "\t\t\t\tเปิดโหมด",
                                                          style: GoogleFonts.kanit(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    0),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.002,
                                                          ),
                                                          backgroundColor:
                                                              Color(0x937AE685),
                                                          fixedSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.002,
                                                      ),
                                                      ElevatedButton.icon(
                                                        onPressed: () {
                                                          if (true) {
                                                            SOLENOIDCONTROL
                                                                solenoidInput =
                                                                SOLENOIDCONTROL(
                                                                    userEmail:
                                                                        widget
                                                                            .email,
                                                                    userPassword:
                                                                        widget
                                                                            .password,
                                                                    controlSolenoid:
                                                                        "0");

                                                            CALLAPIDATAHOME
                                                                .callApiUpdateSolenoid(
                                                                    context,
                                                                    solenoidInput);
                                                          }
                                                        },
                                                        icon: Icon(
                                                            FontAwesomeIcons
                                                                .close),
                                                        label: Text(
                                                          "\t\t\t\tปิดโหมด",
                                                          style: GoogleFonts.kanit(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          side: BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0, 0, 0, 0),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.002,
                                                          ),
                                                          backgroundColor:
                                                              Color(0xC7C87F7F),
                                                          fixedSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.4,
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.42,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.155,
                                                        child: ListView.builder(
                                                          itemCount:
                                                              _realtimeDataList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            REALTIME
                                                                realtimeData =
                                                                _realtimeDataList[
                                                                    index];
                                                            if (realtimeData !=
                                                                null) {
                                                              if (realtimeData
                                                                      .realtimeSolenoid ==
                                                                  1) {
                                                                ai_icon = true;
                                                              } else {
                                                                ai_icon = false;
                                                              }

                                                              return Card(
                                                                color: Colors
                                                                    .black,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            25),
                                                                  ),
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.025,
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          top: MediaQuery.of(context).size.height *
                                                                              0.005,
                                                                          bottom:
                                                                              MediaQuery.of(context).size.height * 0.005,
                                                                        ),
                                                                        child: Icon(
                                                                            ai_icon
                                                                                ? FontAwesomeIcons.toggleOn
                                                                                : FontAwesomeIcons.toggleOff,
                                                                            color: Color.fromARGB(255, 255, 255, 255),
                                                                            size: MediaQuery.of(context).size.width * 0.1),
                                                                      ),
                                                                      Text(
                                                                        "${ai_icon ? "กำลังทำงาน" : "ไม่ทำงาน"}",
                                                                        style: GoogleFonts.kanit(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              Center(
                                                                child: CircularProgressIndicator(
                                                                    color: Colors
                                                                        .red),
                                                              );
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.003,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.height *
                                                0.008,
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.0146,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.003,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.003,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'อัตราการไหล',
                                                    style: GoogleFonts.kanit(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.055,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.432,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.002,
                                                  ),
                                                  child: Card(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color:
                                                            Color(0x3C7BD5E5),
                                                        style:
                                                            BorderStyle.solid,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.002,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            _realtimeDataList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          REALTIME
                                                              realtimeData =
                                                              _realtimeDataList[
                                                                  index];

                                                          if (realtimeData !=
                                                              null) {
                                                            return Center(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                          Center(
                                                                        child:
                                                                            PrettyGauge(
                                                                          gaugeSize:
                                                                              MediaQuery.of(context).size.width * 0.3,
                                                                          segments: [
                                                                            GaugeSegment(
                                                                                'Critically Low',
                                                                                10,
                                                                                Color.fromARGB(255, 249, 133, 129)),
                                                                            GaugeSegment(
                                                                                'Low',
                                                                                20,
                                                                                Color.fromARGB(255, 255, 180, 133)),
                                                                            GaugeSegment(
                                                                                'Medium',
                                                                                20,
                                                                                Color(0xFFFDD871)),
                                                                            GaugeSegment(
                                                                                'High',
                                                                                50,
                                                                                Color.fromARGB(255, 146, 202, 104)),
                                                                          ],
                                                                          valueWidget:
                                                                              Card(
                                                                            color:
                                                                                Colors.red,
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(180)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(4.0),
                                                                              child: Text(
                                                                                'L/M',
                                                                                style: GoogleFonts.kanit(
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.034,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Color.fromARGB(255, 255, 255, 255),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          currentValue: realtimeData.realtimeFlowrate != null
                                                                              ? realtimeData.realtimeFlowrate
                                                                              : 0, //ใสค่าตรงนี้
                                                                          needleColor: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              255,
                                                                              0,
                                                                              0),
                                                                          showMarkers:
                                                                              false,
                                                                        ),
                                                                      ),
                                                                      subtitle:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          '${realtimeData.realtimeFlowrate ?? "0.00"} L/M',
                                                                          style: GoogleFonts.kanit(
                                                                              fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          } else
                                                            return CircularProgressIndicator();
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.height *
                                                0.018,
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.003,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.003,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'ความดัน',
                                                    style: GoogleFonts.kanit(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.055,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.432,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.002,
                                                  ),
                                                  child: Card(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                        color:
                                                            Color(0x3C7BD5E5),
                                                        style:
                                                            BorderStyle.solid,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.002,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            _realtimeDataList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          REALTIME
                                                              realtimeData =
                                                              _realtimeDataList[
                                                                  index];

                                                          if (realtimeData !=
                                                              null) {
                                                            return Center(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                  bottom: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    ListTile(
                                                                      title:
                                                                          Center(
                                                                        child:
                                                                            PrettyGauge(
                                                                          minValue:
                                                                              0,
                                                                          maxValue:
                                                                              520,
                                                                          gaugeSize:
                                                                              MediaQuery.of(context).size.width * 0.3,
                                                                          segments: [
                                                                            GaugeSegment(
                                                                                'Critically Low',
                                                                                60,
                                                                                Color(0xFFFDD871)),
                                                                            GaugeSegment(
                                                                                'Low',
                                                                                200,
                                                                                Color(0xFF92CA68)),
                                                                            GaugeSegment(
                                                                                'Medium',
                                                                                200,
                                                                                Color(0xFF92CA68)),
                                                                            GaugeSegment(
                                                                                'High',
                                                                                60,
                                                                                Color(0xFFF98581)),
                                                                          ],
                                                                          valueWidget:
                                                                              Card(
                                                                            color:
                                                                                Colors.red,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(180),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(4.0),
                                                                              child: Text(
                                                                                'PSI',
                                                                                style: GoogleFonts.kanit(
                                                                                  fontSize: MediaQuery.of(context).size.width * 0.039,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Color.fromARGB(255, 255, 255, 255),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          currentValue: realtimeData.realtimePressure != null
                                                                              ? realtimeData.realtimePressure
                                                                              : 0,
                                                                          needleColor: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              255,
                                                                              0,
                                                                              0),
                                                                          showMarkers:
                                                                              false,
                                                                        ),
                                                                      ),
                                                                      subtitle:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          '${realtimeData.realtimePressure ?? "0.00"} L/M',
                                                                          style:
                                                                              GoogleFonts.kanit(
                                                                            fontSize:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02,
                                    right: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.015,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.012,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: GestureDetector(
                                          onScaleUpdate:
                                              (ScaleUpdateDetails details) {
                                            double newScale =
                                                _currentScale * details.scale;
                                            setState(() {
                                              _currentScale = newScale.clamp(
                                                  _minScale, _maxScale);
                                            });
                                          },
                                          child: Transform.scale(
                                            scale: _currentScale,
                                            child: SfDataGrid(
                                              source:
                                                  _datadetailsDataSourcePage1,
                                              columnWidthMode: ColumnWidthMode
                                                  .fitByCellValue,
                                              columns: _columns1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            SingleChildScrollView(
              child: isLoading == true
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.35,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 255, 255),
                          semanticsLabel: Intl.defaultLocale,
                          strokeAlign:
                              MediaQuery.of(context).size.height * 0.005,
                          strokeCap: StrokeCap.round,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 255, 255, 255)),
                          strokeWidth:
                              MediaQuery.of(context).size.height * 0.005,
                        ),
                      ),
                    )
                  : Container(
                      //หน้าที่ 2
                      color: Color(0xFF97D3DD),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.0,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.015,
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0001,
                                    ),
                                    SingleChildScrollView(
                                      child: SingleChildScrollView(
                                        child: Container(
                                          color:
                                              Color.fromARGB(0, 255, 255, 255),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              1.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.94,
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.005),
                                                ),
                                                Card(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color:
                                                            Color(0x52000000),
                                                        style:
                                                            BorderStyle.solid),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.002,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.002,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            'การควบคุมด้วยเวลา',
                                                            style: GoogleFonts
                                                                .kanit(
                                                              color: const Color
                                                                  .fromARGB(
                                                                  255, 0, 0, 0),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.06,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Color.fromARGB(
                                                                  255,
                                                                  255,
                                                                  255,
                                                                  255)
                                                              .withOpacity(0.3),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.43, // Adjust the height as needed
                                                          child: Stack(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.01,
                                                                  left: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.01,
                                                                  right: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.01,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.43, // กำหนดความสูงตามที่ต้องการ
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0), // Adjust the radius as needed
                                                                    child:
                                                                        WaveWidget(
                                                                      config:
                                                                          CustomConfig(
                                                                        colors: [
                                                                          Colors
                                                                              .blueAccent
                                                                              .withOpacity(0.3),
                                                                          Colors
                                                                              .blueAccent
                                                                              .withOpacity(0.3),
                                                                          Colors
                                                                              .blueAccent
                                                                              .withOpacity(0.3),
                                                                        ],
                                                                        durations: [
                                                                          2000,
                                                                          4000,
                                                                          6000
                                                                        ],
                                                                        heightPercentages: [
                                                                          0.01,
                                                                          0.05,
                                                                          0.03
                                                                        ],
                                                                        blur: MaskFilter.blur(
                                                                            BlurStyle.solid,
                                                                            5),
                                                                      ),
                                                                      waveAmplitude:
                                                                          5.0,
                                                                      waveFrequency:
                                                                          1,
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              255,
                                                                              255,
                                                                              255)
                                                                          .withOpacity(
                                                                              0.3),
                                                                      size: Size(
                                                                          double
                                                                              .infinity,
                                                                          double
                                                                              .infinity),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              ListView.builder(
                                                                itemCount:
                                                                    _realtimeDataList
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  REALTIME
                                                                      realtimeData =
                                                                      _realtimeDataList[
                                                                          index];

                                                                  return Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            20.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Card(
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                                                                color: const Color.fromARGB(255, 18, 12, 12),
                                                                                child: Card(
                                                                                  color: Colors.black,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(180))),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: IconButton(
                                                                                      color: Color.fromARGB(255, 255, 255, 255),
                                                                                      focusColor: Colors.black,
                                                                                      iconSize: MediaQuery.of(context).size.width * 0.25,
                                                                                      onPressed: () async {
                                                                                        dateTimeList = await showOmniDateTimeRangePicker(
                                                                                          context: context,
                                                                                          startInitialDate: DateTime.now(),
                                                                                          startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                                                                                          startLastDate: DateTime.now().add(
                                                                                            const Duration(days: 3652),
                                                                                          ),
                                                                                          endInitialDate: DateTime.now(),
                                                                                          endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
                                                                                          endLastDate: DateTime.now().add(
                                                                                            const Duration(days: 3652),
                                                                                          ),
                                                                                          is24HourMode: true,
                                                                                          isShowSeconds: false,
                                                                                          minutesInterval: 1,
                                                                                          secondsInterval: 1,
                                                                                          isForce2Digits: true,
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                                                                                          constraints: const BoxConstraints(
                                                                                            maxWidth: 350,
                                                                                            maxHeight: 650,
                                                                                          ),
                                                                                          transitionBuilder: (context, anim1, anim2, child) {
                                                                                            return FadeTransition(
                                                                                              opacity: anim1.drive(
                                                                                                Tween(
                                                                                                  begin: 0,
                                                                                                  end: 1,
                                                                                                ),
                                                                                              ),
                                                                                              child: child,
                                                                                            );
                                                                                          },
                                                                                          transitionDuration: const Duration(milliseconds: 200),
                                                                                          barrierDismissible: true,
                                                                                        );
                                                                                      },
                                                                                      icon: Padding(
                                                                                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0),
                                                                                        child: Icon(color: Color.fromARGB(255, 255, 255, 255), FontAwesomeIcons.clock),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SingleChildScrollView(
                                                                                scrollDirection: Axis.vertical,
                                                                                child: Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: MediaQuery.of(context).size.width * 0.42,
                                                                                      height: MediaQuery.of(context).size.width * 0.12,
                                                                                      child: ListView.builder(
                                                                                        itemCount: _realtimeDataList.length,
                                                                                        itemBuilder: (context, index) {
                                                                                          REALTIME realtimeData = _realtimeDataList[index];
                                                                                          if (realtimeData != null) {
                                                                                            if (realtimeData.realtimeTime == 1) {
                                                                                              time_icon = true;
                                                                                            } else {
                                                                                              time_icon = false;
                                                                                            }

                                                                                            return Card(
                                                                                              color: Colors.black,
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.all(
                                                                                                  Radius.circular(10),
                                                                                                ),
                                                                                              ),
                                                                                              child: SingleChildScrollView(
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: EdgeInsets.only(
                                                                                                        left: MediaQuery.of(context).size.width * 0.025,
                                                                                                        right: MediaQuery.of(context).size.width * 0.05,
                                                                                                        top: MediaQuery.of(context).size.height * 0.005,
                                                                                                        bottom: MediaQuery.of(context).size.height * 0.01,
                                                                                                      ),
                                                                                                      child: Icon(time_icon ? FontAwesomeIcons.toggleOn : FontAwesomeIcons.toggleOff, color: Color.fromARGB(255, 255, 255, 255), size: MediaQuery.of(context).size.width * 0.08),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      "${time_icon ? "กำลังทำงาน" : "ไม่ทำงาน"}",
                                                                                                      style: GoogleFonts.kanit(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            );
                                                                                          } else {
                                                                                            Center(
                                                                                              child: CircularProgressIndicator(color: Colors.red),
                                                                                            );
                                                                                          }
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                    ElevatedButton.icon(
                                                                                      onPressed: () {
                                                                                        if (true) {
                                                                                          DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                                                                                          DateFormat timeFormat = DateFormat('HH:mm:ss');

                                                                                          TIMECONTROL timeInput = TIMECONTROL(userEmail: widget.email, userPassword: widget.password, controlDateOn: dateFormat.format(dateTimeList?[0] ?? DateTime.now()), controlDateOFF: dateFormat.format(dateTimeList?[1] ?? DateTime.now()), controlTimeOn: timeFormat.format(dateTimeList?[0] ?? DateTime.now()), controlTimeOFF: timeFormat.format(dateTimeList?[1] ?? DateTime.now()));

                                                                                          if (dateTimeList?[1].day != null && dateTimeList?[1].month != null && dateTimeList?[1].year != null && dateTimeList?[1].hour != null && dateTimeList?[1].minute != null) {
                                                                                            CALLAPIDATAHOME.callApiUpdatetime(
                                                                                              context,
                                                                                              timeInput,
                                                                                            );
                                                                                          } else {
                                                                                            showWarningDialog(context, "กรุณาตั้งเวลาก่อนทำรายอีกครั้ง");
                                                                                          }
                                                                                        }
                                                                                      },
                                                                                      icon: Icon(FontAwesomeIcons.clock),
                                                                                      label: Text(
                                                                                        "\t\t\t\tเปิดโหมด",
                                                                                        style: GoogleFonts.kanit(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        side: BorderSide(
                                                                                          color: Color.fromRGBO(255, 255, 255, 0),
                                                                                          width: MediaQuery.of(context).size.width * 0.002,
                                                                                        ),
                                                                                        backgroundColor: Color(0x937AE685),
                                                                                        fixedSize: Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.width * 0.1),
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.only(
                                                                                            topLeft: Radius.circular(10),
                                                                                            topRight: Radius.circular(10),
                                                                                            bottomLeft: Radius.circular(10),
                                                                                            bottomRight: Radius.circular(10),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    ElevatedButton.icon(
                                                                                      onPressed: () {
                                                                                        if (true) {
                                                                                          TIMECONTROL timeInput = TIMECONTROL(userEmail: widget.email, userPassword: widget.password, controlDateOn: "00-00-00", controlDateOFF: "00-00-00", controlTimeOn: "00:00:00", controlTimeOFF: "00:00:00");

                                                                                          CALLAPIDATAHOME.callApiUpdatetime(
                                                                                            context,
                                                                                            timeInput,
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                      icon: Icon(FontAwesomeIcons.close),
                                                                                      label: Text(
                                                                                        "\t\t\t\tปิดโหมด",
                                                                                        style: GoogleFonts.kanit(fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold),
                                                                                      ),
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        side: BorderSide(
                                                                                          color: Color.fromRGBO(0, 0, 0, 0),
                                                                                          width: MediaQuery.of(context).size.width * 0.002,
                                                                                        ),
                                                                                        backgroundColor: Color(0xC7C87F7F),
                                                                                        fixedSize: Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.width * 0.1),
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.only(
                                                                                            topLeft: Radius.circular(10),
                                                                                            topRight: Radius.circular(10),
                                                                                            bottomLeft: Radius.circular(10),
                                                                                            bottomRight: Radius.circular(10),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: SingleChildScrollView(
                                                                                  scrollDirection: Axis.vertical,
                                                                                  child: Padding(
                                                                                    padding: EdgeInsets.only(
                                                                                      right: MediaQuery.of(context).size.width * 0.03,
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          height: MediaQuery.of(context).size.height * 0.02,
                                                                                        ),
                                                                                        Center(
                                                                                            child: Text(
                                                                                          "เวลาที่ทำการเลือกปัจจุบัน",
                                                                                          style: GoogleFonts.kanit(fontSize: MediaQuery.of(context).size.height * 0.03, fontWeight: FontWeight.bold),
                                                                                        )),
                                                                                        SingleChildScrollView(
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          child: Center(
                                                                                            child: Padding(
                                                                                              padding: EdgeInsets.only(
                                                                                                left: MediaQuery.of(context).size.width * 0.04,
                                                                                                right: MediaQuery.of(context).size.width * 0.04,
                                                                                              ),
                                                                                              child: Text(
                                                                                                "เริ่มต้นวันที่  : ${dateTimeList?[0]?.day ?? "0"}/${dateTimeList?[0]?.month ?? "0"}/${dateTimeList?[0]?.year ?? "0"} เวลา ${dateTimeList?[0]?.hour ?? "0"}:${dateTimeList?[0]?.minute ?? "0"} ปี ${dateTimeList?[0]?.year ?? "0"} ",
                                                                                                style: GoogleFonts.kanit(
                                                                                                  fontSize: MediaQuery.of(context).size.width * 0.036,
                                                                                                  fontWeight: FontWeight.bold,
                                                                                                ),
                                                                                                textAlign: TextAlign.left, // Set the text alignment here
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SingleChildScrollView(
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          child: Center(
                                                                                            child: Padding(
                                                                                              padding: EdgeInsets.only(
                                                                                                left: MediaQuery.of(context).size.width * 0.04,
                                                                                                right: MediaQuery.of(context).size.width * 0.04,
                                                                                              ),
                                                                                              child: Text(
                                                                                                "สินสุดวันที่   : ${dateTimeList?[1]?.day ?? "0"}/${dateTimeList?[1]?.month ?? "0"}/${dateTimeList?[1]?.year ?? "0"} เวลา ${dateTimeList?[1]?.hour ?? "0"}:${dateTimeList?[1]?.minute ?? "0"} ปี ${dateTimeList?[1]?.year ?? "0"} ",
                                                                                                style: GoogleFonts.kanit(fontSize: MediaQuery.of(context).size.width * 0.036, fontWeight: FontWeight.bold),
                                                                                                textAlign: TextAlign.left,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: MediaQuery.of(context).size.height * 0.02,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.005,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.02,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                  ),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.013,
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.012,
                                                      ),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: GestureDetector(
                                                          onScaleUpdate:
                                                              (ScaleUpdateDetails
                                                                  details) {
                                                            double newScale =
                                                                _currentScale *
                                                                    details
                                                                        .scale;
                                                            setState(() {
                                                              _currentScale =
                                                                  newScale.clamp(
                                                                      _minScale,
                                                                      _maxScale);
                                                            });
                                                          },
                                                          child:
                                                              Transform.scale(
                                                            scale:
                                                                _currentScale,
                                                            child: SfDataGrid(
                                                              source:
                                                                  _datadetailsDataSourcePage2,
                                                              columnWidthMode:
                                                                  ColumnWidthMode
                                                                      .lastColumnFill,
                                                              columns:
                                                                  _columns2,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.005,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
            ),
            SingleChildScrollView(
              child: isLoading == true
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.35,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 255, 255),
                          semanticsLabel: Intl.defaultLocale,
                          strokeAlign:
                              MediaQuery.of(context).size.height * 0.005,
                          strokeCap: StrokeCap.round,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 255, 255, 255)),
                          strokeWidth:
                              MediaQuery.of(context).size.height * 0.005,
                        ),
                      ),
                    )
                  : Container(
                      //หน้าที่ 3
                      color: Color(0xFF97D3DD),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.0,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.015,
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0001,
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.005),
                                              ),
                                              Card(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Color(0x52000000),
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.01,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'สรุปข้อมูลการใช้น้ำ',
                                                        style:
                                                            GoogleFonts.kanit(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 0, 0),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                        ),
                                                      ),
                                                      Card(
                                                        color: Colors.red,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.158,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                _realtimeDataList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              REALTIME
                                                                  realtimeData =
                                                                  _realtimeDataList[
                                                                      index];
                                                              if (realtimeData
                                                                          .productDetailsDayWaterUse !=
                                                                      null &&
                                                                  realtimeData
                                                                          .productDetailsMonthWaterUse !=
                                                                      null) {
                                                                return Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch, // Ensure children are stretched horizontally
                                                                  children: [
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.05,
                                                                    ),
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                          ),
                                                                          Icon(FontAwesomeIcons
                                                                              .glassWaterDroplet),
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat("วันนี้ = " + "#,##0.00 " + 'ลิตร').format(realtimeData.productDetailsDayWaterUse),
                                                                            style:
                                                                                GoogleFonts.kanit(
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                              fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.start, // Align text to the start
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.03,
                                                                    ),
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                          ),
                                                                          Icon(FontAwesomeIcons
                                                                              .houseFloodWaterCircleArrowRight),
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat("เดือนนี้ = " + "#,##0.00 " + 'ลิตร').format(realtimeData.productDetailsMonthWaterUse),
                                                                            style:
                                                                                GoogleFonts.kanit(
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                              fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.start, // Align text to the start
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              } else {
                                                                return Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .stretch, // Ensure children are stretched horizontally
                                                                  children: [
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.05,
                                                                    ),
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                          ),
                                                                          Icon(FontAwesomeIcons
                                                                              .glassWaterDroplet),
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat("วันนี้ = " + "#,##0.00 " + 'ลิตร').format(realtimeData.productDetailsDayWaterUse != null
                                                                                ? realtimeData.productDetailsDayWaterUse
                                                                                : 0),
                                                                            style:
                                                                                GoogleFonts.kanit(
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                              fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.start, // Align text to the start
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.03,
                                                                    ),
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                          ),
                                                                          Icon(FontAwesomeIcons
                                                                              .houseFloodWaterCircleArrowRight),
                                                                          SizedBox(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * 0.05,
                                                                          ),
                                                                          Text(
                                                                            NumberFormat("เดือนนี้ = " + "#,##0.00 " + 'ลิตร').format(realtimeData.productDetailsMonthWaterUse != null
                                                                                ? realtimeData.productDetailsMonthWaterUse
                                                                                : 0),
                                                                            style:
                                                                                GoogleFonts.kanit(
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                              fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.start, // Align text to the start
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.005,
                                                      ),
                                                      Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                side:
                                                                    BorderSide(
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                  color: Colors
                                                                      .yellow,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.002,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15))),
                                                        color: Color.fromARGB(
                                                            255, 68, 65, 238),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.1,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                _realtimeDataList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              REALTIME
                                                                  realtimeData =
                                                                  _realtimeDataList[
                                                                      index];

                                                              double unit = realtimeData
                                                                          .productDetailsMonthWaterUse !=
                                                                      null
                                                                  ? realtimeData
                                                                          .productDetailsMonthWaterUse! /
                                                                      1000
                                                                  : 0;

                                                              if (realtimeData
                                                                          .productDetailsMonthWaterUse !=
                                                                      null &&
                                                                  unit != 0) {
                                                                if (unit <=
                                                                    30) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 8.50),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        31 &&
                                                                    unit <=
                                                                        41) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 10.03),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        41 &&
                                                                    unit <=
                                                                        50) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 10.35),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        51 &&
                                                                    unit <=
                                                                        60) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 10.68),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        61 &&
                                                                    unit <=
                                                                        70) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 11.00),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        71 &&
                                                                    unit <=
                                                                        80) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 11.33),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        81 &&
                                                                    unit <=
                                                                        90) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 12.50),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        91 &&
                                                                    unit <=
                                                                        100) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 12.82),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        101 &&
                                                                    unit <=
                                                                        120) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 13.15),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        121 &&
                                                                    unit <=
                                                                        160) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 13.47),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else if (unit >=
                                                                        161 &&
                                                                    unit <=
                                                                        200) {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 13.80),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                } else {
                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.025,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          right:
                                                                              MediaQuery.of(context).size.width * 0.05,
                                                                          left: MediaQuery.of(context).size.width *
                                                                              0.05,
                                                                        ),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 14.45),
                                                                                style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              SizedBox(
                                                                                width: MediaQuery.of(context).size.width * 0.03,
                                                                              ),
                                                                              Icon(
                                                                                Icons.attach_money_rounded,
                                                                                color: Colors.white,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                }
                                                              } else {
                                                                return Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.025,
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .only(
                                                                        right: MediaQuery.of(context).size.width *
                                                                            0.05,
                                                                        left: MediaQuery.of(context).size.width *
                                                                            0.05,
                                                                      ),
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              NumberFormat("ค่าน้ำเดือนนี้ ≈ " + "#,##0.00 " + 'บาท').format(unit * 0),
                                                                              style: GoogleFonts.kanit(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.03,
                                                                            ),
                                                                            Icon(
                                                                              Icons.attach_money_rounded,
                                                                              color: Colors.white,
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.015,
                                                ),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.012,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.02,
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20))),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                      child: GestureDetector(
                                                        onScaleUpdate:
                                                            (ScaleUpdateDetails
                                                                details) {
                                                          double newScale =
                                                              _currentScale *
                                                                  details.scale;
                                                          setState(() {
                                                            _currentScale =
                                                                newScale.clamp(
                                                                    _minScale,
                                                                    _maxScale);
                                                          });
                                                        },
                                                        child: Transform.scale(
                                                          scale: _currentScale,
                                                          child: SfDataGrid(
                                                            source:
                                                                _datadetailsDataSourcePage3,
                                                            columnWidthMode:
                                                                ColumnWidthMode
                                                                    .lastColumnFill,
                                                            columns: _columns3,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02,
                                              ),
                                            ],
                                          ),
                                        ), ///////////////
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.034,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
            ),
            SingleChildScrollView(
              child: isLoading == true
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.35,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 255, 255, 255),
                          semanticsLabel: Intl.defaultLocale,
                          strokeAlign:
                              MediaQuery.of(context).size.height * 0.005,
                          strokeCap: StrokeCap.round,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 255, 255, 255)),
                          strokeWidth:
                              MediaQuery.of(context).size.height * 0.005,
                        ),
                      ),
                    )
                  : Container(
                      //หน้าที่ 4
                      color: Color(0xFF97D3DD),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.0,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.015,
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.0001,
                                    ),
                                    SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01,
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.01,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.01),
                                              ),
                                              Card(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.01,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.015,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.015,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'ข้อมูลผู้ใช้น้ำ',
                                                        style:
                                                            GoogleFonts.kanit(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 0, 0, 0),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                        ),
                                                      ),
                                                      Container(
                                                        color: const Color
                                                                .fromARGB(255,
                                                                255, 255, 255)
                                                            .withOpacity(0.3),
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.26, // Adjust the height as needed
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.28, // กำหนดความสูงตามที่ต้องการ
                                                              width: double
                                                                  .infinity,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0), // Adjust the radius as needed
                                                                child:
                                                                    WaveWidget(
                                                                  config:
                                                                      CustomConfig(
                                                                    colors: [
                                                                      Colors
                                                                          .blueAccent
                                                                          .withOpacity(
                                                                              0.3),
                                                                      Colors
                                                                          .blueAccent
                                                                          .withOpacity(
                                                                              0.3),
                                                                      Colors
                                                                          .blueAccent
                                                                          .withOpacity(
                                                                              0.3),
                                                                    ],
                                                                    durations: [
                                                                      2000,
                                                                      4000,
                                                                      6000
                                                                    ],
                                                                    heightPercentages: [
                                                                      0.01,
                                                                      0.05,
                                                                      0.03
                                                                    ],
                                                                    blur: MaskFilter.blur(
                                                                        BlurStyle
                                                                            .solid,
                                                                        5),
                                                                  ),
                                                                  waveAmplitude:
                                                                      5.0,
                                                                  waveFrequency:
                                                                      1,
                                                                  backgroundColor: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          255,
                                                                          255,
                                                                          255)
                                                                      .withOpacity(
                                                                          0.3),
                                                                  size: Size(
                                                                      double
                                                                          .infinity,
                                                                      double
                                                                          .infinity),
                                                                ),
                                                              ),
                                                            ),
                                                            ListView.builder(
                                                              itemCount:
                                                                  _realtimeDataList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                REALTIME
                                                                    realtimeData =
                                                                    _realtimeDataList[
                                                                        index];
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start, // Align the column's children to the start (left)
                                                                    children: [
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.person_2_rounded,
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                            ),
                                                                            Text(
                                                                              " : ${realtimeData.userName}",
                                                                              style: GoogleFonts.kanit(
                                                                                color: const Color.fromARGB(255, 0, 0, 0),
                                                                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              textAlign: TextAlign.start,
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.03,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.email_rounded,
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                            ),
                                                                            Text(
                                                                              " : ${realtimeData.userEmail}",
                                                                              style: GoogleFonts.kanit(
                                                                                color: const Color.fromARGB(255, 0, 0, 0),
                                                                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.03,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.phone_android_outlined,
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                            ),
                                                                            Text(
                                                                              " : ${realtimeData.userPhone}",
                                                                              style: GoogleFonts.kanit(
                                                                                color: const Color.fromARGB(255, 0, 0, 0),
                                                                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.03,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.home_rounded,
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                            ),
                                                                            Text(
                                                                              " : ${realtimeData.userAddress}",
                                                                              style: GoogleFonts.kanit(
                                                                                color: const Color.fromARGB(255, 0, 0, 0),
                                                                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.03,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.key_rounded,
                                                                              color: const Color.fromARGB(255, 0, 0, 0),
                                                                            ),
                                                                            Text(
                                                                              " : ${realtimeData.userProductID}",
                                                                              style: GoogleFonts.kanit(
                                                                                color: const Color.fromARGB(255, 0, 0, 0),
                                                                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.03,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005,
                                              ),
                                            ],
                                          ),
                                        ), ///////////////
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.034,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
            ),
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          inactiveIconColor: Colors.black38,
          waterDropColor: Color(0xFF7BD5E5),
          iconSize: MediaQuery.of(context).size.width * 0.08,
          backgroundColor: navigationBarColor,
          onItemSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.slowMiddle);
          },
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              filledIcon: Icons.water_drop_rounded,
              outlinedIcon: Icons.water_drop_outlined,
            ),
            BarItem(
                filledIcon: FontAwesomeIcons.solidClock,
                outlinedIcon: FontAwesomeIcons.clock),
            BarItem(
              filledIcon: FontAwesomeIcons.solidChartBar,
              outlinedIcon: FontAwesomeIcons.chartBar,
            ),
            BarItem(
              filledIcon: Icons.person,
              outlinedIcon: Icons.person_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
