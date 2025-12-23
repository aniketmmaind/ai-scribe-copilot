import 'package:ai_scribe_copilot/views/add_petients/add_patients_screen.dart';
import 'package:ai_scribe_copilot/views/home/home_screen.dart';
import 'package:ai_scribe_copilot/views/langtheme/languageselector_screen.dart';
import 'package:ai_scribe_copilot/views/langtheme/themeselector_screen.dart';
import 'package:ai_scribe_copilot/views/patient/patient_details_screen.dart';
import 'package:ai_scribe_copilot/views/recorder/recording_screen.dart';
import 'package:ai_scribe_copilot/views/session/session_detail_screen.dart';
import 'package:ai_scribe_copilot/views/session/session_list_screen.dart';
import 'package:ai_scribe_copilot/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';

import '../../views/login/login_screen.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case RoutesName.languageSelectorScreen:
        return MaterialPageRoute(
          builder: (context) => LanguageSelectorScreen(),
        );
      case RoutesName.themeSelectorScreen:
        return MaterialPageRoute(builder: (context) => ThemeSelectorScreen());
      case RoutesName.loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case RoutesName.patientDetailsScreen:
        return MaterialPageRoute(
          builder:
              (context) => PatientDetailScreen(
                args: settings.arguments as Map<String, dynamic>?,
              ),
        );
      case RoutesName.addPatientScreen:
        return MaterialPageRoute(builder: (context) => AddPatientScreen());
      case RoutesName.recordingScreen:
        return MaterialPageRoute(builder: (context) => RecordingScreen());
      case RoutesName.sessionListScreen:
        return MaterialPageRoute(builder: (context) => SessionListScreen());
      case RoutesName.sessionDetailScreen:
        return MaterialPageRoute(
          builder:
              (context) => SessionDetailScreen(
                args: settings.arguments as Map<String, dynamic>?,
              ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(body: Center(child: Text("Route Bot Generated")));
          },
        );
    }
  }
}
