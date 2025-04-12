// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:course_planner/models/SharedCourse.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/shared_course_provider.dart';
import 'package:course_planner/screens/classes_module/add_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScannerScreen extends StatefulWidget {
  final Term term;

  const QrScannerScreen({super.key, required this.term});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool _flash = false;
  bool _isBackCamera = true;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
        actions: [
          IconButton(
              onPressed: () async {
                await controller?.toggleFlash();

                setState(() {
                  _flash = !_flash;
                });
              },
              icon: Icon(_flash ? Icons.flash_on : Icons.flash_off)),
          IconButton(
              onPressed: () async {
                await controller?.flipCamera();

                setState(() {
                  _isBackCamera = !_isBackCamera;
                });
              },
              icon:
                  Icon(_isBackCamera ? Icons.camera_rear : Icons.camera_front))
        ],
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: Theme.of(context).colorScheme.primaryContainer),
            formatsAllowed: [BarcodeFormat.qrcode],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();

      bool isCancelled = false;

      if (context.mounted) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Getting course..."),
                content: IntrinsicHeight(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        isCancelled = true;

                        await controller.resumeCamera();
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"))
                ],
              );
            });
      }

      if (scanData.code!.trim().isEmpty || scanData.code!.length < 20) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid code.")));
        Navigator.pop(context);

        await controller.resumeCamera();
        return;
      }

      if (context
          .read<ShareCourseProvider>()
          .isCourseMine(scanData.code!.trim())) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("This course is yours.")));

        Navigator.pop(context);

        await controller.resumeCamera();
        return;
      }

      bool internetCheck = await hasNetwork();

      if (context.mounted) Navigator.pop(context);

      if (isCancelled) return;

      if (!internetCheck) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Internet connection required for course sharing."),
            ),
          );

          await controller.resumeCamera();
        }
        return;
      }

      if (context.mounted) {
        SharedCourse? sc = await context
            .read<ShareCourseProvider>()
            .downloadCourse(scanData.code!);

        if (context.mounted) {
          Navigator.pop(context);
          if (sc == null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Course not found.")));

            return;
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddClass(
                        term: widget.term,
                        sc: sc,
                        fromSharing: true,
                      )));
        }
      }
    }, onError: (error) {
      print("Camera Error: $error");
    });
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
