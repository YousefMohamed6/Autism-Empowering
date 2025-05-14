import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/View/Doctors/doctor_follow_requests.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/utils/constants/images.dart';
import '../../core/utils/constants/texts.dart';
import 'doctor_approved_screen.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});
static const String routeName = '/doctor-screen';
  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            SizedBox(
                height: 100, width: 100, child: Image.asset(AppImages.logo)),
            Divider(
              height: 60,
              color: Colors.grey.shade200,
            ),
            CustomDrawerItem(
              onPressed: () {
                Get.to(() => DoctorApprovedScreen(),
                    transition: Transition.zoom);
              },
              title: 'Parents',
            ),
            const SizedBox(height: 10),
            CustomDrawerItem(
              onPressed: () {
                Get.to(() => const DoctorRequestsScreen(),
                    transition: Transition.zoom);
              },
              title: 'Follow Requests',
            ),
            const SizedBox(height: 10),
            CustomDrawerItem(
              onPressed: () {
              },
              title: 'Logout',
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: text('Quick Check'),
        centerTitle: true,
      ),
      body: Center(
        child: FadeInRight(child: const DottedBorderImagePicker()),
      ),
    );
  }
}

class DottedBorderImagePicker extends StatefulWidget {
  const DottedBorderImagePicker({super.key});

  @override
  _DottedBorderImagePickerState createState() =>
      _DottedBorderImagePickerState();
}

class _DottedBorderImagePickerState extends State<DottedBorderImagePicker> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _getImage,
          child: SizedBox(
            width: 200.w,
            height: 200.h,
            child: CustomPaint(
              painter: DottedBorderPainter(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25.r),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : SvgPicture.asset(
                        AppImages.image,
                        color: AppColors.primaryColor,
                      ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30.h),
        text('Upload Patient Image', fontSize: 24.sp)
      ],
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(RRect.fromLTRBR(
          0, 0, size.width, size.height, const Radius.circular(25)));

    // Define the dash pattern (dot length and gap length)
    const double dashWidth = 4.0;
    const double dashSpace = 4.0;
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        final Path extractPath =
            pathMetric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
