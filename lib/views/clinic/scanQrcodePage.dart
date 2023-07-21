import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/views/clinic/viewClinicAppointment.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fyp/views/common/component.dart';
import 'package:fyp/views/clinic/chooseInsertRecordOrViewRecordPage.dart';

import '../../style/app_style.dart';


class ScanQrCodeClinicArea extends StatefulWidget {
  static const String routeName = '/scan_qrcode_clinic';

  const ScanQrCodeClinicArea({Key? key, this.id, this.appointmentData}) : super(key: key);
  final String? id;
  final AppointmentInfo? appointmentData;

  @override
  State<ScanQrCodeClinicArea> createState() => _ScanQrCodeClinicAreaState();
}

class _ScanQrCodeClinicAreaState extends State<ScanQrCodeClinicArea> {
  final HealthRecordService healthRecordService = HealthRecordService();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool qrCodeExist = false;
  Barcode? result;

  @override
  void initState() {
    super.initState();
  }

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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<bool> scanQrCodeWithAppointmentId(String code) async {
    return await healthRecordService.checkScannedQrCodeWithId(context:context, id:widget.id, code: code, userAddress: widget.appointmentData?.userAddress);
  }

  Future<bool> scanQrCodeWithoutAppointmentId(String code) async{
    return await healthRecordService.checkScannedQrCodeWithoutId(context: context, code: code);
  }

  guideToNextPage(String code) async{
    await controller?.pauseCamera();
    if(widget.id != null){
      scanQrCodeWithAppointmentId(code).then((value){
        if(value){
          Navigator.pop(context);
          Navigator.pushNamed(context, InsertRecordOrViewRecordPage.routeName, arguments: {"userAddress": code.toString(), "appointmentId": widget.id, "appointmentData": widget.appointmentData});
        }else{
          showSnackBar(context, "User do not exist");
          Navigator.pop(context);
        }
      });
    }else{
      scanQrCodeWithoutAppointmentId(code).then((value){
        if(value){
          insertSuccessfullyPopupWindow(context);
        }else{
          showSnackBar(context, "User do not exist");
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text("QR code",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                )),
            background: Image.asset(
              'assets/images/bg_or1.jpg',
              fit: BoxFit.cover,
            )),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                child: Icon(Icons.flashlight_on_outlined,
                                    size: 35)),
                            onPressed: () async {
                              await controller?.toggleFlash();
                            },
                          ),
                          ElevatedButton(
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                child: Icon(Icons.flip_camera_ios_outlined,
                                    size: 35)),
                            onPressed: () async {
                              await controller?.flipCamera();
                            },
                          ),
                        ]),
                  )
                ],
              )),
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Center(
                    child: (result != null)
                        ? Text(
                            'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                        : Text('Scan a code'),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async{
      await guideToNextPage(scanData.code ?? "");
      setState(() {
        result = scanData;
      });
    });
  }

  Future<void> insertSuccessfullyPopupWindow(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AlertDialog(
                      scrollable: true,
                      content: Column(children: <Widget>[
                        const Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFFF5F8FF),
                              child: Icon(Icons.check_circle_rounded, size: 50.0),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Text(
                                "Insert Trust Health Provider Successfully",
                                textAlign: TextAlign.center,
                                style: Styles.headLineStyle6)),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: <Widget>[
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                                            if (states.contains(MaterialState.disabled)) { return Colors.grey; }
                                            if (states.contains(MaterialState.pressed)) { return const Color(0xff65ba79); }
                                            return Color(0xff70cf86);
                                          }),
                                        ),
                                        child: Text('OK', style: Styles.buttonTextStyle1),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  )

                              )
                            ]))
                      ]))
                ],
              ));
        });
  }
}
