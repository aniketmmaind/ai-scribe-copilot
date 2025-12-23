import 'package:ai_scribe_copilot/config/routes/routes_name.dart';
import 'package:ai_scribe_copilot/views/langtheme/widgets/lang_dropdown_widget.dart';
import 'package:flutter/material.dart';

import 'widgets/continue_button_widget.dart';

class LanguageSelectorScreen extends StatefulWidget {
  const LanguageSelectorScreen({super.key});

  @override
  State<LanguageSelectorScreen> createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguageSelectorScreen>
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
              const Text(
                "Select Language",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),

              // SUBTITLE (Hindi)
              Text(
                "भाषा चुने",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              // IMAGE
              Image.asset(
                'assets/images/app_icon.png',
                width: 260,
                height: 260,
              ),

              const SizedBox(height: 40),

              // _buildDropdown(),
              LangDropdownWidget(),
              const SizedBox(height: 50),

              ContinueButtonWidget(
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.themeSelectorScreen);
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
