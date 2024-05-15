import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smart_scarecrow/models/bluetooth.dart';
import 'package:smart_scarecrow/models/bluetooth_localStorage.dart';
import 'package:smart_scarecrow/screens/landing.dart';
import 'package:smart_scarecrow/services/routes.dart';
import 'package:smart_scarecrow/services/stream/analytics.dart';
import 'package:smart_scarecrow/services/stream/motion.dart';
import 'package:smart_scarecrow/services/stream/show_notification.dart';
import 'package:smart_scarecrow/services/stream/soil_moisture.dart';
import 'package:smart_scarecrow/services/stream/sound.dart';
import 'package:smart_scarecrow/services/stream/weekly_report.dart';
import 'dart:async';
import 'dart:convert';

import 'package:smart_scarecrow/utils/palettes/colors.dart';
import 'package:smart_scarecrow/utils/snackbars/notification_message.dart';

class BluetoothMainScreen extends StatefulWidget {
  @override
  State<BluetoothMainScreen> createState() => _BluetoothMainScreenState();
}

class _BluetoothMainScreenState extends State<BluetoothMainScreen> {
  final Routes _routes = new Routes();
  final NotificationMessage _notificationMessage = new NotificationMessage();
  // Initializing the Bluetooth connection state to be unknown
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device

  Map<String, Color> colors = {
    'onBorderColor': Colors.green,
    'offBorderColor': Colors.red,
    'neutralBorderColor': Colors.transparent,
    'onTextColor': Colors.green,
    'offTextColor': Colors.red,
    'neutralTextColor': Colors.blue,
  };

  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  @override
  void initState() {
    super.initState();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    BluetoothModels.deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    enableBluetooth();

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  // @override
  // void dispose() {
  //   // Avoid memory leak and disconnect
  //   if (isConnected) {
  //     isDisconnecting = true;
  //     connection!.dispose();
  //     connection = null;
  //   }
  //
  //   super.dispose();
  // }

  // Request Bluetooth permission from the user
  Future<void> enableBluetooth() async {
    // Retrieving the current Bluetooth state
    _bluetoothState = await FlutterBluetoothSerial.instance.state;

    // If the bluetooth is off, then turn it on first
    // and then retrieve the devices that are paired.
    if (_bluetoothState == BluetoothState.STATE_OFF) {
      await FlutterBluetoothSerial.instance.requestEnable();
      await getPairedDevices();
      // return true;
    } else {
      await getPairedDevices();
    }
    // return false;
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  // FOR LOCAL STORAGE
  _addItem(String title) {
    // final item = new TodoDate(date: DateTime.now());
   //  soundStreamServices.addRecord(data: item);
   // _saveToStorage();
  }

  _saveToStorage() {
    // StorageModels.storage.setItem('todos', StorageModels.list.toJSONEncodable());
  }

  _clearStorage() async {
    // await StorageModels.storage.clear();
    //
    // setState(() {
    //   soundStreamServices.updateRecord(data: StorageModels.storage.getItem('todos') ?? []);
    // });
  }

  // Now, its time to build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Bluetooth connect",style: TextStyle(fontFamily: "bold",fontSize: 17),),
        centerTitle: true,
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            splashColor: Colors.deepPurple,
            onPressed: () async {
              await getPairedDevices().then((_) {
                show('Device list refreshed');
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Visibility(
              visible: _isButtonUnavailable &&
                  _bluetoothState == BluetoothState.STATE_ON,
              child: LinearProgressIndicator(
                backgroundColor: Colors.yellow,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
            Container(
              width: double.infinity,
              height: 55,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Enable Bluetooth',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: "regular"
                      ),
                    ),
                  ),
                  Switch(
                    value: _bluetoothState.isEnabled,
                    onChanged: (bool value) {
                      future() async {
                        if (value) {
                          await FlutterBluetoothSerial.instance
                              .requestEnable();
                        } else {
                          await FlutterBluetoothSerial.instance
                              .requestDisable();
                        }

                        await getPairedDevices();
                        _isButtonUnavailable = false;

                        if (_connected) {
                          _disconnect();
                        }
                      }

                      future().then((_) {
                        setState(() {});
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Device:',
                  style: TextStyle(
                    fontFamily: "bold"
                  ),
                ),
                Expanded(
                  child: DropdownButton(
                    items: _getDeviceItems(),
                    onChanged: (value) =>
                        setState(() => _device = value),
                    value: _devicesList.isNotEmpty ? _device : null,
                  ),
                ),
                TextButton(
                  onPressed: _isButtonUnavailable
                      ? null
                      : _connected ? _disconnect : _connect,
                  child:
                  Text(_connected ? 'Disconnect' : 'Connect',style: TextStyle(fontFamily: "semibold"),),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "If you cannot find the device in the list, please pair the device by going to the bluetooth settings",
                    style: TextStyle(
                      fontFamily: "regular"
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    FlutterBluetoothSerial.instance.openSettings();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Create the List of devices to be shown in Dropdown Menu
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name!),
          value: device,
        ));
      });
    }
    return items;
  }

  // Method to connect to bluetooth
  void _connect() async {
    setState(() {
      _isButtonUnavailable = true;
    });
    if (_device == null) {
      show('No device selected');
    } else {
      if (!BluetoothModels.isConnected) {
        String message='';
        await BluetoothConnection.toAddress(_device!.address)
            .then((_connection) async{
          print('Connected to the device');
          BluetoothModels.connection = _connection;
          setState(() {
            _connected = true;
          });
          BluetoothModels.connection!.input!.listen((Uint8List data) async{
            String dataStr = ascii.decode(data);
            message+=dataStr;
            if (dataStr.contains('\n')) {
              print("EVENT FROM ARDUINO ${message}");
              if(message.toLowerCase().contains("Noise".toLowerCase())){
                // NOISE
                if(!soundStreamServices.value.toString().contains(TodoDate(date: DateFormat("dd MMM, yyyy").format(DateTime.now()).toString()).toString())){
                  soundStreamServices.addRecord(data: TodoDate(date: DateFormat("dd MMM, yyyy").format(DateTime.now()).toString()));
                  soundStreamServices.updateRecord(data: soundStreamServices.value!);
                  await StorageModels.soundStorage.setItem('date', StorageModels.list.SoundDatetoJSONEncodable());
                }
                soundStreamServices.addTimeRecord(data: TodoTime(time: DateTime.now().toString()));
                soundStreamServices.updateTimeRecord(data: soundStreamServices.valueTime!);
                await StorageModels.soundStorage.setItem('time', StorageModels.list.SoundTimetoJSONEncodable());
                showNotificationStreamServices.updateRecord(data: true);
                Future.delayed(const Duration(seconds: 4), () {
                  showNotificationStreamServices.updateRecord(data: false);
                });
              }else if(message.toLowerCase().contains("Motion".toLowerCase())){
                // MOTION
                if(!motionStreamServices.value.toString().contains(TodoDate(date: DateFormat("dd MMM, yyyy").format(DateTime.now()).toString()).toString())){
                  motionStreamServices.addRecord(data: TodoDate(date: DateFormat("dd MMM, yyyy").format(DateTime.now()).toString()));
                  motionStreamServices.updateRecord(data: motionStreamServices.value!);
                  await StorageModels.motionStorage.setItem('date', StorageModels.list.MotionDatetoJSONEncodable());
                }
                motionStreamServices.addTimeRecord(data: TodoTime(time: DateTime.now().toString()));
                motionStreamServices.updateTimeRecord(data: motionStreamServices.valueTime!);
                await StorageModels.motionStorage.setItem('time', StorageModels.list.MotionTimetoJSONEncodable());
                showNotificationStreamServices.updateRecord(data: true);
                Future.delayed(const Duration(seconds: 4), () {
                  showNotificationStreamServices.updateRecord(data: false);
                });
              }else{
                // WEEKLY REPORTS
                if(DateFormat('EEEE').format(DateTime.now()) == "Sunday"){
                  weeklyReportStreamServices.sun = message;
                  await StorageModels.weeklyStorage.setItem("sun", message);

                }else if(DateFormat('EEEE').format(DateTime.now()) == "Monday"){
                  weeklyReportStreamServices.mon = message;
                  await StorageModels.weeklyStorage.setItem("mon", message);

                }else if(DateFormat('EEEE').format(DateTime.now()) == "Tuesday"){
                  weeklyReportStreamServices.tue = message;
                  await StorageModels.weeklyStorage.setItem("tue", message);

                }else if(DateFormat('EEEE').format(DateTime.now()) == "Wednesday"){
                  weeklyReportStreamServices.wed = message;
                  await StorageModels.weeklyStorage.setItem("wed", message);

                }else if(DateFormat('EEEE').format(DateTime.now()) == "Thursday"){
                  weeklyReportStreamServices.thu = message;
                  await StorageModels.weeklyStorage.setItem("thu", message);

                }else if(DateFormat('EEEE').format(DateTime.now()) == "Friday"){
                  weeklyReportStreamServices.fri = message;
                  await StorageModels.weeklyStorage.setItem("fri", message);
                }else{
                  weeklyReportStreamServices.sat = message;
                  await StorageModels.weeklyStorage.setItem("sat", message);
                }
                weeklyReportStreamServices.updateRecord(data: message);
                soilStreamServices.updateRecord(data: double.parse(message));
                print("SOIL"+message);

                // ANALYTICS
                // snapshot.data! < 300 ? "No healthy" : snapshot.data! > 300 && snapshot.data! < 650 ? "Moderate" : "Healthy
                String _notHealthy = double.parse(message) < 300 ? message : "0";
                String _moderate = double.parse(message) > 300 && double.parse(message) < 650 ? message : "0";
                String _healthy = double.parse(message) > 650 ? message : "0";

                if(DateTime.now().day >= 1 && DateTime.now().day <= 7){
                  AnalyticStreamServices.week1 = [_healthy,_moderate,_notHealthy];
                  await StorageModels.analyticStorage.setItem("week1", AnalyticStreamServices.week1);

                }else if(DateTime.now().day >= 8 && DateTime.now().day <= 14){
                  AnalyticStreamServices.week2 = [_healthy,_moderate,_notHealthy];
                  await StorageModels.analyticStorage.setItem("week2", AnalyticStreamServices.week2);

                }else if(DateTime.now().day >= 15 && DateTime.now().day <= 21){
                  AnalyticStreamServices.week3 = [_healthy,_moderate,_notHealthy];
                  await StorageModels.analyticStorage.setItem("week3", AnalyticStreamServices.week3);

                }else if(DateTime.now().day >= 22 && DateTime.now().day <= 28){
                  AnalyticStreamServices.week4 = [_healthy,_moderate,_notHealthy];
                  await StorageModels.analyticStorage.setItem("week4", AnalyticStreamServices.week4);

                }else{
                  AnalyticStreamServices.week5 = [_healthy,_moderate,_notHealthy];
                  await StorageModels.analyticStorage.setItem("week5", AnalyticStreamServices.week5);

                }
                // else if(DateFormat('MMMM').format(DateTime.now()) == "June"){
                //   AnalyticStreamServices.june = [_healthy,_moderate,_notHealthy];
                //   await StorageModels.analyticStorage.setItem("june", AnalyticStreamServices.june);
                //
                // }else if(DateFormat('MMMM').format(DateTime.now()) == "July"){
                //   AnalyticStreamServices.july = [_healthy,_moderate,_notHealthy];
                //   await StorageModels.analyticStorage.setItem("july", AnalyticStreamServices.july);
                //
                // }else if(DateFormat('MMMM').format(DateTime.now()) == "August"){
                //   AnalyticStreamServices.aug = [_healthy,_moderate,_notHealthy];
                //   await StorageModels.analyticStorage.setItem("aug", AnalyticStreamServices.aug);
                //
                // }else if(DateFormat('MMMM').format(DateTime.now()) == "September"){
                //   AnalyticStreamServices.sept = [_healthy,_moderate,_notHealthy];
                //   await StorageModels.analyticStorage.setItem("sept", AnalyticStreamServices.sept);
                //
                // }else if(DateFormat('MMMM').format(DateTime.now()) == "October"){
                //   AnalyticStreamServices.oct = [_healthy,_moderate,_notHealthy];
                //   await StorageModels.analyticStorage.setItem("oct", AnalyticStreamServices.oct);
                //
                // }else if(DateFormat('MMMM').format(DateTime.now()) == "November"){
                //   AnalyticStreamServices.nov = [_healthy,_moderate,_notHealthy];
                //   await StorageModels.analyticStorage.setItem("nov", AnalyticStreamServices.nov);
                //
                // }else{
                //   AnalyticStreamServices.dec = [_healthy,_moderate,_notHealthy];
                //   await StorageModels.analyticStorage.setItem("dec", AnalyticStreamServices.dec);
                // }
              }
              message = '';
            }
          });
          BluetoothModels.connection!.input!.listen(null).onDone(() {
            if (BluetoothModels.isDisconnecting) {
              print('Disconnecting locally!');
            } else {
              print('Disconnected remotely!');
            }
            if (this.mounted) {
              setState(() {});
            }
          });
        }).catchError((error) {
          print('Cannot connect, exception occurred');
          print(error);
        });
        show('Device connected');

        setState(() => _isButtonUnavailable = false);
      }
    }
  }

  // void _onDataReceived(Uint8List data) {
  //   // Allocate buffer for parsed data
  //   int backspacesCounter = 0;
  //   data.forEach((byte) {
  //     if (byte == 8 || byte == 127) {
  //       backspacesCounter++;
  //     }
  //   });
  //   Uint8List buffer = Uint8List(data.length - backspacesCounter);
  //   int bufferIndex = buffer.length;

  //   // Apply backspace control character
  //   backspacesCounter = 0;
  //   for (int i = data.length - 1; i >= 0; i--) {
  //     if (data[i] == 8 || data[i] == 127) {
  //       backspacesCounter++;
  //     } else {
  //       if (backspacesCounter > 0) {
  //         backspacesCounter--;
  //       } else {
  //         buffer[--bufferIndex] = data[i];
  //       }
  //     }
  //   }
  // }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _isButtonUnavailable = true;
      BluetoothModels.deviceState = 0;
    });

    await BluetoothModels.connection!.close();
    show('Device disconnected');
    if (!BluetoothModels.connection!.isConnected) {
      setState(() {
        _connected = false;
        _isButtonUnavailable = false;
      });
    }
  }

  // Method to send message,
  // for turning the Bluetooth device on
  void _sendOnMessageToBluetooth() async {
    // connection!.output.add(utf8.encode("1" + "\r\n"));
    // await connection!.output.allSent;
    // show('Device Turned On');
    // setState(() {
    //   _deviceState = 1; // device on
    // });
  }

  // Method to send message,
  // for turning the Bluetooth device off
  void _sendOffMessageToBluetooth() async {
    // connection!.output.add(utf8.encode("0" + "\r\n"));
    // await connection!.output.allSent;
    // show('Device Turned Off');
    // setState(() {
    //   _deviceState = -1; // device off
    // });
  }

  // Method to show a Snackbar,
  // taking message as the text
  Future show(
      String message, {
        Duration duration = const Duration(seconds: 3),
      }) async {
    await new Future.delayed(new Duration(milliseconds: 100));

  }
}