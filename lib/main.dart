import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_scarecrow/models/bluetooth.dart';
import 'package:smart_scarecrow/screens/landing.dart';
import 'package:smart_scarecrow/services/routes.dart';
import 'package:smart_scarecrow/utils/palettes/colors.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Scarecrow',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Routes _routes = new Routes();

  void _disconnect() async {
    setState(() {
      BluetoothModels.deviceState = 0;
      BluetoothModels.isDisconnecting = true;
      BluetoothModels.connection!.dispose();
      BluetoothModels.connection = null;
    });
    await BluetoothModels.connection!.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), (){
      if (BluetoothModels.isConnected) {
        _disconnect();
      }
      _routes.navigator_pushreplacement(context, Landing());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image(
              width: 170,
              image: AssetImage("assets/logos/app_icon.png"),
            ),
            CircularProgressIndicator(color: AppColors.green,)
          ],
        ),
      )
    );
  }
}
