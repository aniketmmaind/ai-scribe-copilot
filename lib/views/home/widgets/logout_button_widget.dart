part of 'app_drawer_widget.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          icon: const Icon(Icons.logout),
          label: Text(
            AppLocalizations.of(context)!.logoutTxt,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
            side: BorderSide(color: Theme.of(context).colorScheme.error),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            final isLogOut = await ConfirmationDialogUtil.show(
              context: context,
              title: AppLocalizations.of(context)!.logoutTxt,
              message: AppLocalizations.of(context)!.logoutqueTxt,
              confirmText: AppLocalizations.of(context)!.logoutTxt,
              cancelText: AppLocalizations.of(context)!.noTxt,
              isDestructive: true,
            );

            if (isLogOut) {
              final value = await SessionController().clearUserFromPreference();
              if (value) {
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.languageSelectorScreen,
                    (route) => false,
                  );
                }
              }
              return;
            }
          },
        ),
      ),
    );
  }
}
