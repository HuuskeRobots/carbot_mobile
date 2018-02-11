import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

import 'robot_info.dart';

class RobotControlScreen extends StatefulWidget {
  final RobotInfo _robot;

  RobotControlScreen(this._robot, {Key key}) : super(key: key);

  @override
  _RobotControlScreenState createState() =>
      new _RobotControlScreenState(_robot);
}

class _RobotControlScreenState extends State<RobotControlScreen> {
  final RobotInfo _robot;
  var httpClient = new HttpClient();
  bool _busy = false;

  _RobotControlScreenState(this._robot);

  @override
  Widget build(BuildContext context) {
    return new Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      new Expanded(
          child: new Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
            new Expanded(
                child: new RaisedButton(
              child: new Text("Vooruit"),
              onPressed: _busy ? null : _onForward,
            )),
          ])),
      new Expanded(
          child: new Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
            new Expanded(
                child: new RaisedButton(
              child: new Text("Links"),
              onPressed: _busy ? null : _onLeft,
            )),
            new Expanded(
                child: new RaisedButton(
              child: new Text("Stop"),
              onPressed: _onStop,
            )),
            new Expanded(
                child: new RaisedButton(
              child: new Text("Rechts"),
              onPressed: _busy ? null : _onRight,
            )),
          ])),
      new Expanded(
          child: new Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
            new Expanded(
                child: new RaisedButton(
              child: new Text("Achteruit"),
              onPressed: _busy ? null : _onBackward,
            )),
          ]))
    ]);
  }

  Future<Null> _control(String path) async {
    setState(() => _busy = true);
    try {
      var host = _robot.hostname;
      var url = "http://$host$path";
      var req = await httpClient.getUrl(Uri.parse(url));
      await req.close();
    } finally {
      setState(() => _busy = false);
    }
  }

  void _onForward() {
    _control("/motor/vooruit");
  }

  void _onStop() {
    _control("/motor/stop");
  }

  void _onBackward() {
    _control("/motor/achteruit");
  }

  void _onLeft() {
    _control("/motor/links");
  }

  void _onRight() {
    _control("/motor/rechts");
  }
}
