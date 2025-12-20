import 'package:ai_scribe_copilot/services/splash/splash_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices _splashServices = SplashServices();
  @override
  void initState() {
    super.initState();
    _splashServices.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Text(
              "MediNote",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black54,
                letterSpacing: 0.5,
              ),
            ),
            Image.asset('assets/images/app_icon.png'),
            Padding(
              padding: EdgeInsets.all(50),
              child: CircularProgressIndicator(),
            ),
            Spacer(),
            Text(
              "MediNote Transcriber App",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
