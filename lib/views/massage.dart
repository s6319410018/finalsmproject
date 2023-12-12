import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyFadeContainer(),
    );
  }
}

class MyFadeContainer extends StatefulWidget {
  @override
  _MyFadeContainerState createState() => _MyFadeContainerState();
}

class _MyFadeContainerState extends State<MyFadeContainer> {
  double opacityLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fade Animation'),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: opacityLevel,
          duration: Duration(seconds: 1),
          child: Container(
            width: 200.0,
            height: 200.0,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Fade me!',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            opacityLevel = opacityLevel == 1.0 ? 0.0 : 1.0;
          });
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
