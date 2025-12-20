part of '../session_list_screen.dart';

class SessionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String patienName;

  const SessionAppBar({super.key, required this.patienName});

  @override
  Widget build(BuildContext context) {
    return AppBarUtil(
      title: "$patienName ${AppLocalizations.of(context)!.sessionlstTxt}",
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
