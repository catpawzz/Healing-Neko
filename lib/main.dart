//  _    _            _ _               _   _      _             ____  
// | |  | |          | (_)             | \ | |    | |          _|___ \ 
// | |__| | ___  __ _| |_ _ __   __ _  |  \| | ___| | _____   (_) __) |
// |  __  |/ _ \/ _` | | | '_ \ / _` | | . ` |/ _ \ |/ / _ \     |__ < 
// | |  | |  __/ (_| | | | | | | (_| | | |\  |  __/   < (_) |  _ ___) |
// |_|  |_|\___|\__,_|_|_|_| |_|\__, | |_| \_|\___|_|\_\___/  (_)____/ 
//                               __/ |                                 
//                              |___/                                  
//
// ----------------------------------------------------------------------------
// Made with love and a cat by Catpawz
// based on ideas from firebird496
// ----------------------------------------------------------------------------
//
// ignore_for_file: unused_local_variable, depend_on_referenced_packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healing_neko/main/home.dart';
import 'package:healing_neko/pre/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyMain());
}

class MyMain extends StatelessWidget {
  const MyMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healing Neko',
      theme: themeData(),
      home: const MyMainPage(title: 'Healing Neko'),
      routes: {
        '/pre': (context) => const DataSavePage(),
        '/home': (context) => const homePagePage(),
      },
    );
  }
}

ThemeData themeData() {
  Color primaryColor = const Color(0xFF0EF6CC);
  Color accentColor = const Color(0xFF3A4F50);
  Color backgroundColor = const Color(0xFF201B23);

  MaterialColor primarySwatch = MaterialColor(
    primaryColor.value,
    <int, Color>{
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    },
  );

  return ThemeData(
    primarySwatch: primarySwatch,
    hintColor: accentColor,
    fontFamily: 'Quicksand', 
    scaffoldBackgroundColor: backgroundColor,
    useMaterial3: true,
  );
}

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key, required this.title});
  final String title;
  @override
  State<MyMainPage> createState() => _MyMainPageState();
}


Future<void> initializeWindow(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();

  // Get if the user has already saved local data
  final bool? dataNeeded = prefs.getBool('hln_setup');
  final bool shorterBoot = prefs.getBool('hln_shorter_boot') ?? false;

  int sec = shorterBoot ? 1 : 4; // Use a ternary operator for brevity

  // Use a local variable to hold the route name
  String routeName;

  if (dataNeeded == true) {
    // User already has local data saved
    routeName = '/home';
  } else {
    // User doesn't have local data saved
    routeName = '/pre';
  }

  // Delay and then navigate
  await Future.delayed(Duration(seconds: sec));
  // Check if the context is still valid before navigating
  if (context.mounted) {
    Navigator.pushNamed(context, routeName);
  }
}



class _MyMainPageState extends State<MyMainPage> {
  bool _showColumn = false;
  String message = "...";

  vibrate() {
    if (Theme.of(context).platform == TargetPlatform.android) {
      const type = FeedbackType.selection;
      HapticFeedback.vibrate();
    }
  }

  checkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    //get if the user has already saved local data
    final bool? dataNeeded = prefs.getBool('hln_setup');

    if(dataNeeded == true) {
      //user already has local data saved
      setState(() {
        message = "Welcome, ${prefs.getString('hln_name')}";
      });
    } else {
      //user doesn't have local data saved
      message = "Launching setup...";
    }
  }

  @override
  void initState() {
    super.initState();
    checkStatus();

    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _showColumn = true;
      });
    });

    initializeWindow(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set the navigation bar color to the app's background color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
    ));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: AnimatedOpacity(
            opacity: _showColumn ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                SizedBox(
                  height: 220,
                  child: Image.asset('assets/img/CatLoveWhite.png'),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Healing Neko',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFFC8ACEE),
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                const Text(
                  "Made with <3 by Catpawz",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7F698C),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),

                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF7F698C),
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                  ),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}