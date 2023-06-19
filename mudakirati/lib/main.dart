import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/notes_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /*SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.orange, // navigation bar color
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.orange, // status bar color
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));*/
  static const String title = 'Mudakirati';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],

          // Define the default font family.
          //fontFamily: 'Georgia',

          // Define the default `TextTheme`. Use this to specify the default
          textTheme: GoogleFonts.ralewayTextTheme(
            Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.white, displayColor: Colors.white),
          ),
          /*textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),*/
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const NotePage(),
      );
}
