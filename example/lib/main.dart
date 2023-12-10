import 'package:flutter/material.dart';

import 'package:flutter_dnd/flutter_dnd.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _filterName = '';
  bool _isNotificationPolicyAccessGranted = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state.toString());
    if (state == AppLifecycleState.resumed) {
      updateUI();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateUI();
  }

  void updateUI() async {
    int filter = await FlutterDnd.getCurrentInterruptionFilter();
    String filterName = FlutterDnd.getFilterName(filter);
    bool isNotificationPolicyAccessGranted =
        await FlutterDnd.isNotificationPolicyAccessGranted;

    setState(() {
      _isNotificationPolicyAccessGranted = isNotificationPolicyAccessGranted;
      _filterName = filterName;
    });
  }

  void setInterruptionFilter(int filter) async {
    if (await FlutterDnd.isNotificationPolicyAccessGranted) {
      await FlutterDnd.setInterruptionFilter(filter);
      updateUI();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter DND Example app'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Current Filter: $_filterName'),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'isNotificationPolicyAccessGranted: ${_isNotificationPolicyAccessGranted ? 'YES' : 'NO'}'),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    FlutterDnd.gotoPolicySettings();
                  },
                  child: Text('GOTO POLICY SETTINGS'),
                ),
                TextButton(
                  onPressed: () async {
                    setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);
                  },
                  child: Text('TURN ON DND'),
                ),
                TextButton(
                  onPressed: () {
                    setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
                  },
                  child: Text('TURN OFF DND'),
                ),
                TextButton(
                  onPressed: () {
                    setInterruptionFilter(
                        FlutterDnd.INTERRUPTION_FILTER_ALARMS);
                  },
                  child: Text('TURN ON DND - ALLOW ALARM'),
                ),
                TextButton(
                  onPressed: () {
                    setInterruptionFilter(
                        FlutterDnd.INTERRUPTION_FILTER_PRIORITY);
                  },
                  child: Text('TURN ON DND - ALLOW PRIORITY'),
                )
              ]),
        ),
      ),
    );
  }
}
