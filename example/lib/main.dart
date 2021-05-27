import 'dart:async';

import 'package:custom_counts_down/custom_counts_down.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;
  StreamController<String> _streamController1;
  StreamController<String> _streamController2;
  ScrollController _scrollController1;
  ScrollController _scrollController2;
  int _currentTimes1 = 0;
  int _currentTimes2 = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _streamController1 = StreamController<String>.broadcast();
    _streamController2 = StreamController<String>.broadcast();
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamController1.close();
    _streamController2.close();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TabBar(
            tabs: [
              Container(
                child: Text(
                  'data0',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              Container(
                child: Text(
                  'data1',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ],
            controller: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: ListView(
                    controller: _scrollController1,
                    children: [
                      HSYCountDownButton(
                        maxTimes: 60,
                        onCurrentTimes: () {
                          return _currentTimes1;
                        },
                        changedStreamController: _streamController1,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.amber,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        onTap: (int maxTimes, int minTimes) {
                          return Future.value(true);
                        },
                        onTimerChanged: (int currentTimes, int residueTimes,
                            HSYTimerState state) {
                          _currentTimes1 = residueTimes;
                          print(
                              'currentTimes: $currentTimes, residueTimes: $residueTimes, state: ${state.toString()}');
                        },
                        onDefaultText: (bool isEndedStateCallBack) {
                          return (isEndedStateCallBack
                              ? "Reset!"
                              : "Let's Go!");
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: ListView(
                    controller: _scrollController2,
                    children: [
                      HSYCountDownButton(
                        maxTimes: 60,
                        onCurrentTimes: () {
                          return _currentTimes2;
                        },
                        changedStreamController: _streamController2,
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.amber,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        onTap: (int maxTimes, int minTimes) {
                          return Future.value(true);
                        },
                        onTimerChanged: (int currentTimes, int residueTimes,
                            HSYTimerState state) {
                          _currentTimes2 = residueTimes;
                          print(
                              'currentTimes: $currentTimes, residueTimes: $residueTimes, state: ${state.toString()}');
                        },
                        onDefaultText: (bool isEndedStateCallBack) {
                          return (isEndedStateCallBack
                              ? "Reset!"
                              : "Let's Go!");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
