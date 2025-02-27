import 'dart:io';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:autism_empowering/Controller/Const/colors.dart';
import 'package:autism_empowering/Controller/Const/images.dart';
import 'package:autism_empowering/Controller/Const/texts.dart';
import 'package:autism_empowering/View/patient_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class CheckByImage extends StatelessWidget {
  const CheckByImage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        while (Navigator.canPop(context)) {
          Get.offAll(() => const PatientScreen(), transition: Transition.zoom);
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: text('Check by Image', fontSize: 20),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Get.offAll(() => const PatientScreen(),
                    transition: Transition.zoom);
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Center(
          child: FadeInLeft(child: const DottedBorderImagePicker()),
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
  Future<String?> loadModel() async {
    return await Tflite.loadModel(
      model: 'assets/models/face_model.tflite',
      labels: 'assets/models/labels.txt',
    );
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool? loading = false;
  List? _output;

  Future<void> _getImage() async {
    loading = true;
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      await classifyImage(_imageFile!);
    }
  }

  Future<void> classifyImage(File image) async {
    try {
      var output = await Tflite.runModelOnImage(
        path: image.path,
        threshold: 0.05,
        numResults: 6,
        imageMean: 127.5,
        imageStd: 127.5,
      );
      setState(() {
        loading = false;
        _output = output;
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
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
              child: Column(
                children: [
                  _imageFile != null
                      ? Expanded(
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.contain,
                          ),
                        )
                      : SvgPicture.asset(
                          image,
                          color: primaryColor,
                        ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _output == null
            ? const SizedBox()
            : Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Text(
                      "Result: ${_output![0]["label"]}",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Accurcy: ${(_output![0]["confidence"] * 100).toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
