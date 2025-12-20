import 'package:ai_scribe_copilot/views/langtheme/widgets/theme_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../config/routes/routes_name.dart';
import 'widgets/continue_button_widget.dart';

class ThemeSelectorScreen extends StatefulWidget {
  const ThemeSelectorScreen({super.key});

  @override
  State<ThemeSelectorScreen> createState() => _ThemeSelectorScreenState();
}

class _ThemeSelectorScreenState extends State<ThemeSelectorScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TITLE
              Text(
                AppLocalizations.of(context)!.selectThemeTxt,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),

              const SizedBox(height: 30),

              // IMAGE
              Image.asset(
                'assets/images/app_icon.png',
                width: 260,
                height: 260,
              ),

              const SizedBox(height: 40),

              ThemeDropdownWidget(),
              const SizedBox(height: 50),

              ContinueButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.loginScreen);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
