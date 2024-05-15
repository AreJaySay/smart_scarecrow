import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothModels{
 static BluetoothConnection? connection;
 static int? deviceState;
 static bool isDisconnecting = false;
 static bool get isConnected => connection != null && connection!.isConnected;

}