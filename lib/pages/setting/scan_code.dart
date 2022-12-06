import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../core/utils/string_util.dart';
import '../../core/widget/custom_app_bar.dart';

/// 二维码扫码页面
class ScanCode extends StatefulWidget {
  const ScanCode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanCodeState();
}

class _ScanCodeState extends State<ScanCode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (StringUtil.isNotEmpty(result)) {
      controller?.dispose();
      super.dispose();
      Get.back(result: {"message": result?.code});
      return const Scaffold();
    }
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: customAppbar(
          context: context,
          title: '扫一扫',
          titleColor: Colors.white,
          backgroundColor: Colors.black87,
          borderBottom: false,
          actions: [
            IconButton(
                color: Colors.white,
                onPressed: () async {
                  await controller?.flipCamera();
                },
                icon: FutureBuilder(
                  future: controller?.getCameraInfo(),
                  builder: (context, snapshot) {
                    return const Icon(Icons.cameraswitch_outlined);
                  },
                )),
            IconButton(
                color: Colors.white,
                onPressed: () async {
                  await controller?.toggleFlash();
                },
                icon: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    bool switchFlash = false;
                    if (snapshot.data != null) {
                      switchFlash = snapshot.data as bool;
                    }
                    return Icon(switchFlash ? Icons.flash_on : Icons.flash_off);
                  },
                )),
          ]),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: const [BarcodeFormat.qrcode],
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      controller = qrController;
    });
    controller?.resumeCamera();
    controller?.scannedDataStream.listen((scanData) {
      print("扫描到的信息：$scanData");
      ToastUtils.toast("扫描到的信息：$scanData");
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
