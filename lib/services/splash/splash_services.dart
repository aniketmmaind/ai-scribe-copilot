import 'dart:async';
import 'package:flutter/material.dart';

import '../../config/routes/routes_name.dart';
import '../session_manager/session_controller.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    SessionController()
        .getUserFromPreference()
        .then((value) {
          if (SessionController.isLogin!) {
            Timer(
              const Duration(seconds: 5),
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.homeScreen,
                (route) => false,
              ),
            );
          } else {
            Timer(
              const Duration(seconds: 5),
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.languageSelectorScreen,
                (route) => false,
              ),
            );
          }
        })
        .onError((er, st) {
          Timer(
            const Duration(seconds: 5),
            () => Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.loginScreen,
              (route) => false,
            ),
          );
        });
  }
}
