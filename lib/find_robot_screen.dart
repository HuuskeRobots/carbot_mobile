import 'package:flutter/material.dart';
import 'package:mdns/mdns.dart';
import 'robot_info.dart';

const String discovery_service = "_carbot._tcp";

typedef void RobotInfoCallback(RobotInfo);

class FindRobotScreen extends StatefulWidget {
  final RobotInfoCallback _onSelected;
  FindRobotScreen(this._onSelected, {Key key}) : super(key: key);

  @override
  _FindRobotScreenState createState() => new _FindRobotScreenState(_onSelected);
}

class _FindRobotScreenState extends State<FindRobotScreen> {
  final RobotInfoCallback _onSelected;
  List<RobotInfo> _robots = <RobotInfo>[];
  Mdns _mdns;
  String _state = "";
  bool _busy = false;
  DiscoveryCallbacks discoveryCallbacks;

  _FindRobotScreenState(this._onSelected);
  @override
  initState() {
    super.initState();

    discoveryCallbacks = new DiscoveryCallbacks(
      onDiscovered: (ServiceInfo info) {
        print("Discovered ${info.toString()}");
        if (mounted) {
          setState(() {
            _state = "Finding ${info.name}";
          });
        }
      },
      onDiscoveryStarted: () {
        print("Discovery started");
        if (mounted) {
          setState(() {
            _state = "DISCOVERY: Discovery Running";
          });
        }
      },
      onDiscoveryStopped: () {
        print("Discovery stopped");
        if (mounted) {
          setState(() {
            _state = "DISCOVERY: Discovery Not Running";
            _busy = false;
          });
        }
      },
      onResolved: (ServiceInfo info) {
        print("Resolved Service ${info.toString()}");
        if (mounted) {
          setState(() {
            _robots.add(new RobotInfo(info.name, info.host));
          });
        }
      },
    );

    _state = "Starting mDNS for service [$discovery_service]";
    _mdns = new Mdns(discoveryCallbacks: discoveryCallbacks);
    startMdnsDiscovery(discovery_service);
  }

  startMdnsDiscovery(String serviceType) {
    setState(() {
      _busy = true;
      _robots = [];
    });
    _mdns.startDiscovery(serviceType);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          body: new ListView.builder(
            itemCount: _robots.length,
            itemBuilder: (BuildContext context, int index) {
              return new ListTile(
                title: new Text(_robots[index].name),
                onTap: () => _onSelected(_robots[index]),
              );
            },
          ),
          floatingActionButton: new IconButton(
            icon: new Icon(Icons.refresh),
            onPressed: _onRefresh,
          )),
    );
  }

  void _onRefresh() {
    startMdnsDiscovery(discovery_service);
  }
}
