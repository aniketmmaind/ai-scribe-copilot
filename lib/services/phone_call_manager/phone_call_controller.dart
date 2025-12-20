// import 'dart:async';

// import 'package:permission_handler/permission_handler.dart';
// import 'package:phone_state/phone_state.dart';

// class PhoneCallController {
//   StreamSubscription<PhoneState>? _callSub;
//   Function()? onCallStarted; // callback pause
//   Function()? onCallEnded; // callback resume

//   Future<void> startCallListener() async {
//     final status = await Permission.phone.request();
//    if (!status.isGranted) {
//       return;
//     }
//     _callSub = PhoneState.stream.listen((event) async {
//       // if (event == null) return;

//       if (event.status == PhoneStateStatus.CALL_INCOMING ||
//           event.status == PhoneStateStatus.CALL_STARTED) {
//         onCallStarted?.call();
//         // await pause();
//       }

//       if (event.status == PhoneStateStatus.CALL_ENDED) {
//        onCallEnded?.call();

//         // await resume();
//       }
//     });
//   }
// }
