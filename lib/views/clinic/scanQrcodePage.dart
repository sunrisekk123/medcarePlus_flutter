import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/views/clinic/viewClinicAppointment.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fyp/views/common/component.dart';
import 'package:fyp/views/clinic/chooseInsertRecordOrViewRecordPage.dart';


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
    return await healthRecordService.checkScannedQrCodeWithId(context:context, id:widget.id, code: code);
  }

  Future<bool> scanQrCodeWithoutAppointmentId(String code) async{
    return await healthRecordService.checkScannedQrCodeWithoutId(context: context, code: code);
  }

  guideToNextPage(String code) async{
    await controller?.pauseCamera();
    if(widget.id != null){
      scanQrCodeWithAppointmentId(code).then((value){
        if(value){
          Navigator.pushNamedAndRemoveUntil(context, MyAppointmentClinicArea.routeName, (Route<dynamic> route) => false,arguments: {"userAddress": code.toString(), "appointmentId": widget.id, "appointmentData": widget.appointmentData});
          Navigator.pushNamed(context, InsertRecordOrViewRecordPage.routeName, arguments: {"userAddress": code.toString(), "appointmentId": widget.id, "appointmentData": widget.appointmentData});
        }else{
          showSnackBar(context, "User do not exist");
          Navigator.pop(context);
        }
      });
    }else{
      scanQrCodeWithoutAppointmentId(code).then((value){
        if(value){
          Navigator.pushNamedAndRemoveUntil(context, MyAppointmentClinicArea.routeName, (Route<dynamic> route) => false, arguments: {"userAddress": code.toString() });
          Navigator.pushNamed(context, InsertRecordOrViewRecordPage.routeName, arguments: {"userAddress": code.toString() });
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
}
