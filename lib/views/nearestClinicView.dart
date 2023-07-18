import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/style/app_style.dart';
import 'package:gap/gap.dart';
import 'package:fyp/models/clinic.dart';

class NearestClinicView extends StatefulWidget {
  const NearestClinicView({Key? key, required this.clinicData}) : super(key: key);
  final ClinicInfo clinicData;

  @override
  State<NearestClinicView> createState() => _NearestClinicViewState();
}
class _NearestClinicViewState extends State<NearestClinicView> {

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Row(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                height: 100,
                                width: size.width * 0.28,
                                color: Color(0xffffffff),
                                child: Image.asset(widget.clinicData.imagePath.isNotEmpty? widget.clinicData.imagePath : 'assets/images/clinic_1.png',
                                    fit: BoxFit.fill)
                              // Image(image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),),
                            ),
                          )
                        ],
                      ),
                      const Gap(7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: size.width * 0.28,
                            child: Text(
                              widget.clinicData.name,
                              style: Styles.boxTextStyle1,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            FontAwesomeIcons.locationDot,
                            size: 14,
                            color: Colors.red,
                          ),
                          Text(widget.clinicData.district, style: Styles.boxTextStyle2),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

}