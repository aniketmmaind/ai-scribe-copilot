part of '../add_patients_screen.dart';

class PatientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const PatientAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBarUtil(title: title);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
