import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fyp/views/services/healthRecordService.dart';
import 'package:fyp/views/common/loader.dart';

class ShowQRCodeUserArea extends StatefulWidget {
  static const String routeName = '/health_record_qrcode_user';
  const ShowQRCodeUserArea({Key? key}) : super(key: key);

  @override
  State<ShowQRCodeUserArea> createState() => _ShowQRCodeUserAreaState();
}

class _ShowQRCodeUserAreaState extends State<ShowQRCodeUserArea> {
  final HealthRecordService healthRecordService =  HealthRecordService();
  late Uint8List qrCode = Uint8List.fromList([]);

  @override
  void initState(){
    //TODO: check if login or not, if login: change drawer and show e-health record
    super.initState();
    fetchQrCode();
  }

  fetchQrCode() async {
    String code = await healthRecordService.getQrCode(context);
    final UriData? data = Uri.parse(code).data;
    Uint8List? myImage = data?.contentAsBytes();
    setState(() {
      qrCode = myImage!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(shrinkWrap: true, slivers: [
        SliverAppBar(
          expandedHeight: 0,
          floating: false,
          pinned: true,
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
        qrCode.isEmpty ? SliverList( delegate: SliverChildListDelegate(<Widget>[const Loader()])) : SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
                    child: Card(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(children: [
                              ListTile(
                                title: Text("My QR Code",
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
                                dense: true,
                                visualDensity: VisualDensity(vertical: -3),

                              ),
                              ListTile(
                                title: Image.memory(qrCode, scale:0.5),
                                dense: true,
                                visualDensity: VisualDensity(vertical: -3),

                              ),
                            ])))),
              ]
              )
        ),
      ]),
    );
  }
}
