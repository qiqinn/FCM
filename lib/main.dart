
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token =" ";

  @override
  void initState() {
    final pushNotificationService = 
    PushNotificationService( _firebaseMessaging, context);
    pushNotificationService.initialise();
    pushNotificationService.getToken().then(
      (value){
        setState(
          () {
            _token = value;
          },
        );  
      }
    );
    super.initState();
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('FCM'),
      ),
    );
  }
}
class PushNotificationService {
  final FirebaseMessaging _fcm;
  final context;
  PushNotificationService(this._fcm, this.context);
  
  // ignore: empty_constructor_bodies
  Future getToken() async{
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
    return token;
  }
  void initialise(){

  _fcm.configure(
    onMessage:(Map<String, dynamic> message ) async{
      print("onMessage: $message");
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          content: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Text(message['notification']['title']),
              new Text(message['notification']['body']),
              new Text(message['data']['lab']),
              new Text(message['data']['tempat']),
              new Text(message['data']['jam']),
            ],
          ),
          actions: <Widget>[
                        TextButton(
                            child: Text('Ok',
                            style: TextStyle(color: Colors.blue),),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    ],
        ),
      );
    },
    onLaunch:(Map<String, dynamic> message ) async{
      print("onLaunch: $message");
    },
    onResume:(Map<String, dynamic> message ) async{
      print("onResume: $message");;
    },
  );
}
}
