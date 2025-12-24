import 'package:ai_scribe_copilot/bloc/login/login_bloc.dart';
import 'package:ai_scribe_copilot/config/routes/routes_name.dart';
import 'package:ai_scribe_copilot/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_scribe_copilot/l10n/app_localizations.dart';
import '../../utils/app_button_util.dart';
import '../../utils/app_textfield_util.dart';
import '../../bloc/password_toggle/password_toggle_bloc.dart';
import '../../utils/enums.dart';

part 'widgets/email_textfield_widget.dart';
part 'widgets/password_textfield_widget.dart';
part 'widgets/login_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Medical illustration
                Image.asset("assets/images/app_icon.png", height: 200),
                const SizedBox(height: 20),

                // App title
                Text(
                  AppLocalizations.of(context)!.welcomeBkTxt,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.signInTxt,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 35),

                // Email Field
                EmailTextfieldWidget(focusNode: emailFocusNode),
                const SizedBox(height: 18),

                // Password Field
                PasswordTextfieldWidget(focusNode: passwordFocusNode),
                const SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      SnackbarUtil.showSnckBar(
                        context,
                        "Updated in future...",
                        showOnTop: true,
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.forgetTxt,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button
                LoginButtonWidget(formKey: _formKey),

                const SizedBox(height: 30),

                // Footer
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
        ),
      ),
    );
  }
}
