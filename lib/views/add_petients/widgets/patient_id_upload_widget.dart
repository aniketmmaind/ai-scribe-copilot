// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../bloc/add_patient/add_patient_bloc.dart';

// class PatientIdUploadWidget extends StatelessWidget {
//   final int formKeyId;
//   const PatientIdUploadWidget({super.key, required this.formKeyId});

//   Future<void> _pickImage(BuildContext context) async {
//     final picker = ImagePicker();
//     final source = await showModalBottomSheet<ImageSource>(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) => _ImageSourceSheet(),
//     );

//     if (source == null) return;

//     final picked = await picker.pickImage(source: source, imageQuality: 80);

//     if (picked != null) {
//       context.read<AddPatientBloc>().add(
//         PatientIdImageSelectedEvent(idImage: File(picked.path)),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return BlocBuilder<AddPatientBloc, AddPatientState>(
//       // buildWhen:
//       //     (previous, current) =>
//       //         previous.patientIdImage != current.patientIdImage,
//       builder: (context, state) {
//         final image = state.patientIdImage;
//         print("hi hi hi hi");
//         return Column(
//           // key: ValueKey(formKeyId),
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Patient ID",
//               style: theme.textTheme.titleSmall?.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 8),

//             GestureDetector(
//               onTap: () => _pickImage(context),
//               child: Container(
//                 height: 140,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: Colors.grey.shade300),
//                   color: theme.cardColor,
//                 ),
//                 child:
//                     image == null
//                         ? _UploadPlaceholder()
//                         : ClipRRect(
//                           borderRadius: BorderRadius.circular(14),
//                           child: Image.file(
//                             image,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                         ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _ImageSourceSheet extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Take Photo"),
//               onTap: () => Navigator.pop(context, ImageSource.camera),
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Choose from Gallery"),
//               onTap: () => Navigator.pop(context, ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _UploadPlaceholder extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: const [
//           Icon(Icons.badge_outlined, size: 36, color: Colors.grey),
//           SizedBox(height: 8),
//           Text("Upload Photo ID", style: TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   }
// }
