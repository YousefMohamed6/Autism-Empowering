import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/core/utils/constants/colors.dart';
import 'package:autism_empowering/core/utils/constants/images.dart';
import 'package:autism_empowering/core/utils/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Child Info/patient_screen.dart';

class CheckByFMRI extends StatelessWidget {
  const CheckByFMRI({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        while (Navigator.canPop(context)) {
          Get.offAll(() => PatientScreen(), transition: Transition.zoom);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: text('Check by Image', fontSize: 20),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.offAll(() => PatientScreen(), transition: Transition.zoom);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Center(
          child: FadeInRight(child: DottedBorderImagePicker()),
        ),
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
    return GestureDetector(
      onTap: _getImage,
      child: SizedBox(
        width: 200.w,
        height: 200.h,
        child: CustomPaint(
          painter: DottedBorderPainter(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: _imageFile != null
                ? Image.file(_imageFile!, fit: BoxFit.cover)
                : SvgPicture.asset(
                    AppImages.image,
                    color: AppColors.primaryColor,
                  ),
          ),
        ),
      ),
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
