part of 'patient_info_section.dart';

class DetailCard extends StatelessWidget {
  final Widget child;

  const DetailCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              blurRadius: 8,
              spreadRadius: 1,
              color: Colors.black.withOpacity(0.05),
            ),
        ],
      ),
      child: child,
    );
  }
}
