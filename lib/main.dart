import 'package:ai_scribe_copilot/bloc/add_patient/add_patient_bloc.dart';
import 'package:ai_scribe_copilot/bloc/lang_theme_selector/lang_selector_bloc.dart';
import 'package:ai_scribe_copilot/bloc/login/login_bloc.dart';
import 'package:ai_scribe_copilot/bloc/patient/patient_bloc.dart';
import 'package:ai_scribe_copilot/bloc/patient_details/patient_detail_bloc.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_bloc.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_event.dart';
import 'package:ai_scribe_copilot/bloc/session/session_bloc.dart';
import 'package:ai_scribe_copilot/services/notification_manager/notification_service.dart';
import 'bloc/audio_route/audio_route_bloc.dart';
import 'bloc/password_toggle/password_toggle_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await NotificationService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  LanguageThemeSelectorBloc()
                    ..add(LoadSavedLanguageEvent())
                    ..add(LoadSavedThemeEvent()),
        ),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => PasswordToggleBloc()),
        BlocProvider(create: (context) => PatientBloc()),
        BlocProvider(create: (context) => AddPatientBloc()),
        BlocProvider(create: (context) => PatientDetailBloc()),
        BlocProvider(create: (context) => RecorderBloc()),
        BlocProvider(
          create: (_) => AudioRouteBloc()..add(StartAudioRouteListening()),
        ),
        BlocProvider(create: (context) => SessionBloc()),
      ],
      child: BlocBuilder<LanguageThemeSelectorBloc, LanguageThemeSelectorState>(
        builder: (context, state) {
          NotificationService.setOnAction((actionId) {
            final recorderBloc = BlocProvider.of<RecorderBloc>(
              context,
              listen: false,
            );
            if (actionId == 'pause') {
              recorderBloc.add(PauseRecording(isFromCall: false));
            } else if (actionId == 'resume') {
              recorderBloc.add(ResumeRecording(isFromCall: false));
            } else if (actionId == 'stop') {
              recorderBloc.add(StopRecording());
            } else {}
          });

          return MaterialApp(
            title: 'Medinote Recorder',
            themeMode: state.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.light(primary: Colors.blue),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white, // icon color
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              colorScheme: ColorScheme.dark(primary: Colors.teal),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white, // icon color in dark mode
              ),
            ),

            locale: state.locale,
            supportedLocales: const [Locale('en'), Locale('hi')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: Routes.generateRoute,
            initialRoute: RoutesName.splashScreen,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

// // lib/main.dart
// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:ai_scribe_copilot/controllers/app_controller.dart';
// import 'package:ai_scribe_copilot/controllers/language_change_controller.dart';
// import 'package:provider/provider.dart';
// import 'utils/pcmtowav_util.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'services/recorder_service.dart';
// import 'services/api_service.dart';
// import 'services/upload_manager.dart';
// import 'services/local_db.dart';
// import 'models/pending_chunk.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';
// import 'package:vibration/vibration.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final appController = AppController();

//   MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => LanguageChangeController()),
//       ],
//       child: Consumer<LanguageChangeController>(
//         builder: (context, value, child) {
//           return MaterialApp(
//             title: 'MediNote Recorder',
//             home: HomePage(),
//             themeMode: value.themeMode,
//             theme: ThemeData.light(),
//             darkTheme: ThemeData.dark(),
//             locale: value.appLocale,
//             supportedLocales: const [Locale('en'), Locale('hi')],

//             localizationsDelegates: const [
//               AppLocalizations.delegate,
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//               GlobalCupertinoLocalizations.delegate,
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// enum Language { english, hindi }

// class _HomePageState extends State<HomePage> {
//   late RecorderService recorder;
//   ApiService? api;
//   late UploadManager uploadManager;
//   String? sessionId;
//   bool recording = false;
//   bool isLastChunk = false;
//   int chunkCounter = 0;
//   String jwt =
//       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6InVzZXJfY2EyZTQ1MzItYTIyZi00YTkzLThiOTctNzI5ZjFhZTNjMzliIiwiZW1haWwiOiJ0ZXN0MUBnbWFpbC5jb20iLCJpYXQiOjE3NjUwMDIxNjEsImV4cCI6MTc2NTA4ODU2MX0.bZTNgBwJMCvSjcP9fmu26W6fBSk6Q8V5lc4ZzGa3JSU"; // inject real token
//   final userId = 'user_ca2e4532-a22f-4a93-8b97-729f1ae3c39b';
//   final patientId = 'patient_92915cd1-ab8d-406a-9ae8-829c584f2b29';
//   final templateId = 'temp_001';

//   @override
//   void initState() {
//     super.initState();
//     initAll();
//   }

//   Future<void> initAll() async {
//     await _ensurePermissions();
//     recorder = await RecorderService.create(chunkMs: 2000); // 2s chunks
//     api = ApiService(baseUrl: 'http://192.168.42.252:3000/api', jwtToken: jwt);
//     uploadManager = UploadManager(api: api!);
//     // background retry loop
//     Timer.periodic(Duration(seconds: 5), (_) {
//       uploadManager.autoDrainQueue();
//     });
//   }

//   Future<void> _ensurePermissions() async {
//     await Permission.microphone.request();
//     await Permission.storage.request();
//   }

//   Future<void> startRecording() async {
//     if (recording) return;
//     // create session on backend
//     final sId = await api!.createSession(
//       userId: userId,
//       patientId: patientId,
//       patientName: 'Niketan',
//       templateId: templateId,
//     );
//     setState(() {
//       sessionId = sId;
//       recording = true;
//       chunkCounter = 0;
//     });
//     WakelockPlus.enable(); // keep CPU on while recording
//     Vibration.vibrate(duration: 50);

//     final stream = recorder.startRecordingStream();
//     stream.listen(
//       (chunkPath) async {
//         // chunkPath is local wav path
//         final chunkNum = chunkCounter++;
//         final mime = 'audio/wav';

//         // 1) request presigned url from backend
//         // Map<String, dynamic> presigned;
//         // try {
//         //   presigned = await api!.getPresignedUrl(
//         //     sessionId: sessionId!,
//         //     chunkNumber: chunkNum,
//         //     mimeType: mime,
//         //   );
//         // } catch (e) {
//         //   return;
//         // }

//         // final gcsPath = presigned['gcsPath'] ?? '';
//         // final publicUrl = presigned['publicUrl'] ?? '';
//         // final uploadUrl = presigned['url'] ?? null;
//         // print("uploadUrl: $uploadUrl");
//         print("chunkPath: $chunkPath");

//         // ---------- 1) SAVE TO LOCAL DB ----------
//         final pending = PendingChunk(
//           id: const Uuid().v4(),
//           sessionId: sessionId!,
//           chunkNumber: chunkNum,
//           localFilePath: chunkPath,
//           gcsPath: "",
//           publicUrl: "",
//           mimeType: 'audio/wav',
//           isLast: isLastChunk,
//         );

//         await LocalDb.instance.insert('pending_chunks', pending.toMap());
//         print("Saved chunk locally: $chunkPath");
//         uploadManager.tryUploadNow(pending);
//         ////--------------backup-------------
//         // File file = File(chunkPath);

//         // Uint8List pcmBytes = await file.readAsBytes();

//         // // Convert PCM -> WAV
//         // final wavBytes = PcmtowavUtil.pcmToWav(pcmBytes);
//         // print("bytes: ${wavBytes.take(10).toList()}");
//         // try {
//         //   final resp = await http
//         //       .put(
//         //         Uri.parse(uploadUrl),
//         //         headers: {
//         //           'Content-Type': 'audio/wav',
//         //           'Authorization': 'Bearer $jwt',
//         //         },
//         //         body: wavBytes,
//         //       )
//         //       .timeout(Duration(seconds: 40));
//         //   print("_uploadChunk status Code: ${resp.statusCode}");
//         //   if (resp.statusCode == 200 || resp.statusCode == 201) {
//         //     // success - call backend notify
//         //     await api?.notifyChunkUploaded(
//         //       sessionId: sessionId!,
//         //       gcsPath: gcsPath,
//         //       chunkNumber: chunkNum,
//         //       isLast: false,
//         //       totalChunksClient: 0, // if you track total chunks, pass it
//         //       publicUrl: publicUrl,
//         //       mimeType: 'audio/wav',
//         //     );
//         //     return;
//         //   } else {
//         //     throw Exception('Upload failed ${resp.statusCode} ${resp.body}');
//         //   }
//         // } catch (e) {
//         //   print("error occure: ${e.toString()}");
//         // }
//       },
//       onError: (e) {
//         print('recording stream error $e');
//       },
//       onDone: () {
//         print('recorder stream done');
//       },
//     );
//   }

//   Future<void> stopRecording() async {
//     if (!recording) return;
//     await recorder.stop();
//     setState(() {
//       recording = false;
//       isLastChunk = true;
//     });
//     WakelockPlus.disable();
//     Vibration.vibrate(duration: 50);
//   }

//   @override
//   void dispose() {
//     recorder.dispose();
//     // uploadManager?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('MediNote Recorder')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(AppLocalizations.of(context)!.helloWorld.toString()),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Consumer<LanguageChangeController>(
//                   builder: (context, value, child) {
//                     return DropdownButton<ThemeMode>(
//                       value: value.themeMode,
//                       items: const [
//                         DropdownMenuItem(
//                           child: Text("System"),
//                           value: ThemeMode.system,
//                         ),
//                         DropdownMenuItem(
//                           child: Text("Light"),
//                           value: ThemeMode.light,
//                         ),
//                         DropdownMenuItem(
//                           child: Text("Dark"),
//                           value: ThemeMode.dark,
//                         ),
//                       ],
//                       onChanged: (v) {
//                         if (v != null) value.setThemeMode(v);
//                       },
//                     );
//                   },
//                 ),
//                 SizedBox(width: 20),
//                 Consumer<LanguageChangeController>(
//                   builder: (context, value, child) {
//                     return DropdownButton<Language>(
//                       value:
//                           value.appLocale == Locale('en')
//                               ? Language.english
//                               : Language.hindi,
//                       items: const [
//                         DropdownMenuItem(
//                           child: Text("English"),
//                           value: Language.english,
//                         ),
//                         DropdownMenuItem(
//                           child: Text("Hindi"),
//                           value: Language.hindi,
//                         ),
//                       ],
//                       onChanged: (v) {
//                         // if (v != null) widget.appController.setLanguage(v);
//                         if (v == Language.hindi) {
//                           value.changeLanguage(Locale('hi'));
//                         } else {
//                           value.changeLanguage(Locale('en'));
//                         }
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),

//             Text('Session: ${sessionId ?? "none"}'),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: recording ? stopRecording : startRecording,
//               child: Text(recording ? 'Stop Recording' : 'Start Recording'),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () async {
//                 // force drain queue
//                 // await uploadManager?.drainQueue();
//                 final rows = await LocalDb.instance.query('pending_chunks');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Queued: ${rows.length}')),
//                 );
//               },
//               child: const Text('Show Queue Size'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
