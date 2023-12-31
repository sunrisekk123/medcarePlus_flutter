import 'package:flutter/material.dart';
import 'package:fyp/style/app_layout.dart';
import 'package:fyp/style/app_style.dart';
import 'package:gap/gap.dart';
import 'package:fyp/models/doctor.dart';

class ClinicDoctorListView extends StatelessWidget {
  const ClinicDoctorListView({Key? key, required this.doctorData}) : super(key: key);
  final Doctor doctorData;

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
                                width: size.width * 0.27,
                                color: Color(0xffffffff),
                                child: Image.asset(
                                    doctorData.imagePath.isNotEmpty? doctorData.imagePath: 'assets/images/doctor_1.webp',
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
                            width: size.width * 0.27,
                            child: Text(
                              "Dr. ${doctorData.name}",
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
                          SizedBox(
                            width: size.width * 0.27,
                            child: Text(
                              "Cheng Hing Chung Clinic",
                              style: Styles.boxTextStyle2,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
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
