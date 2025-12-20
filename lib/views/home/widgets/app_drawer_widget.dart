import 'package:ai_scribe_copilot/config/routes/routes_name.dart';
import 'package:ai_scribe_copilot/services/session_manager/session_controller.dart';
import 'package:ai_scribe_copilot/views/home/widgets/theme_switch.dart';
import 'package:ai_scribe_copilot/views/langtheme/widgets/lang_dropdown_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../utils/confirmation_dialog_util.dart';
part 'logout_button_widget.dart';

typedef ThemeToggleCallback = void Function(bool isDark);
typedef LanguageChangeCallback = void Function(String langCode);

class AppDrawerWidget extends StatelessWidget {
  final String profileUrl;
  final String currentLanguage;

  const AppDrawerWidget({
    super.key,
    required this.profileUrl,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            currentAccountPicture: ClipOval(
              child: Image.network(
                profileUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Icon(Icons.account_circle_outlined, size: 60),
                  );
                },
              ),
            ),
            accountName: Text(
              SessionController.user!.name!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(
              SessionController.user!.email!,
              style: TextStyle(fontSize: 14),
            ),
          ),

          // THEME & LANGUAGE SETTINGS
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text(AppLocalizations.of(context)!.themeTxt),
            trailing: ThemeSwitch(),
          ),

          ListTile(
            leading: Icon(Icons.language),
            title: Text(AppLocalizations.of(context)!.langTxt),
            trailing: LangDropdownWidget(),
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.homeTxt),
            onTap: () {
              Navigator.of(context).pop();
            
            },
          ),
          const Spacer(),
          LogoutButtonWidget(),
        ],
      ),
    );
  }
}
