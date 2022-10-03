import 'package:agora_rtm/agora_rtm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_stream/view/screens/broadcast_screen.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/view/screens/sign_in_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:live_stream/utils/appId.dart';
import '../../res/custom_colors.dart';
import '../../utils/authentication.dart';
import '../widgets/app_bar_title.dart';

class MyHomePage extends StatefulWidget {
  final User? user;
  const MyHomePage({Key? key, required this.user}): super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String check = '';
  late AgoraRtmClient _client;
  late AgoraRtmChannel? _channel;
  late AgoraRtmChannel _subchannel;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState(){
    super.initState();
    start();
  }

  void start()async{
    debugPrint('started');
    _client = await AgoraRtmClient.createInstance(appId);
    _channel = await _client.createChannel("easy");
    _channel!.join().then((value)async {
      var membersData = await _channel?.getMembers();
      debugPrint(membersData!.length.toString());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.firebaseNavy,
          title: const AppBarTitle(),
          actions: [
            IconButton(
              onPressed: () async{
                await Authentication.signOut(context: context);
                Navigator.of(context)
                    .pushReplacement(_routeToSignInScreen());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => onJoin(isBroadcaster: false),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'Just Watch  ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(
                      Icons.remove_red_eye,
                    )
                  ],
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.pink,
                ),
                onPressed: () => onJoin(isBroadcaster: true),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const<Widget>[
                    Text(
                      'Broadcast    ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Icon(Icons.live_tv)
                  ],
                ),
              ),
              Text(
                check,
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
        ));
  }

  Future<void> onJoin({required bool isBroadcaster}) async {
    await [Permission.camera, Permission.microphone].request();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BroadcastPage(
          isBroadcaster: isBroadcaster,
        ),
      ),
    );
  }
}
