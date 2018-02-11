class RobotInfo {
  final String _name;
  final String _hostname;

  RobotInfo(this._name, this._hostname);

  String get name => _name;
  String get hostname => _hostname.replaceAll("/", "");
}