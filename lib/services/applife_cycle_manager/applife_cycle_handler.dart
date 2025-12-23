// import 'package:flutter/widgets.dart';

// class AppLifecycleHandler with WidgetsBindingObserver {
//   final VoidCallback onPause;
//   final VoidCallback onResume;

//   AppLifecycleHandler({
//     required this.onPause,
//     required this.onResume,
//   });

//   void start() {
//     WidgetsBinding.instance.addObserver(this);
//   }

//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive) {
//       onPause();
//     } else if (state == AppLifecycleState.resumed) {
//       onResume();
//     }
//   }
// }
