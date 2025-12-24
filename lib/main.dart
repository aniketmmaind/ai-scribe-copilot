import 'package:ai_scribe_copilot/bloc/add_patient/add_patient_bloc.dart';
import 'package:ai_scribe_copilot/bloc/lang_theme_selector/lang_selector_bloc.dart';
import 'package:ai_scribe_copilot/bloc/login/login_bloc.dart';
import 'package:ai_scribe_copilot/bloc/patient/patient_bloc.dart';
import 'package:ai_scribe_copilot/bloc/patient_details/patient_detail_bloc.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_bloc.dart';
import 'package:ai_scribe_copilot/bloc/recorder/recorder_event.dart';
import 'package:ai_scribe_copilot/bloc/session/session_bloc.dart';
import 'package:ai_scribe_copilot/l10n/app_localizations.dart';
import 'package:ai_scribe_copilot/services/notification_manager/notification_service.dart';
import 'package:flutter/services.dart';
import 'bloc/audio_route/audio_route_bloc.dart';
import 'bloc/password_toggle/password_toggle_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await NotificationService.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService(context);
    });
  }

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
      child: BlocListener<
        LanguageThemeSelectorBloc,
        LanguageThemeSelectorState
      >(
        listenWhen:
            (previous, current) => previous.themeMode != current.themeMode,
        listener: (context, state) {
          _sysNavBar(state);
        },
        child: BlocBuilder<
          LanguageThemeSelectorBloc,
          LanguageThemeSelectorState
        >(
          builder: (context, state) {
            _notificationService(context);
            return MaterialApp(
              title: 'Medinote',
              themeMode: state.themeMode,

              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                scaffoldBackgroundColor: Colors.white,
                colorScheme: ColorScheme.light(primary: Colors.blue),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // icon color
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(),
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
      ),
    );
  }

  _notificationService(BuildContext context) {
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
  }

  _sysNavBar(LanguageThemeSelectorState state) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            state.themeMode == ThemeMode.dark
                ? const Color.fromARGB(255, 11, 11, 11)
                : const Color.fromARGB(181, 244, 242, 242),
        systemNavigationBarIconBrightness:
            state.themeMode == ThemeMode.dark
                ? Brightness.light
                : Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            state.themeMode == ThemeMode.dark
                ? Brightness.light
                : Brightness.dark,
      ),
    );
  }
}
