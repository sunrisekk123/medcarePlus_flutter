import 'package:flutter/material.dart';
import 'package:fyp/models/appointment.dart';
import 'package:fyp/views/basePage.dart';
import 'package:fyp/views/clinic/chooseInsertRecordOrViewRecordPage.dart';
import 'package:fyp/views/clinic/clinicBookingConfirmPage.dart';
import 'package:fyp/views/clinic/clinicBookingPage.dart';
import 'package:fyp/views/clinic/clinicDetails.dart';
import 'package:fyp/views/clinic/clinicInfoPage.dart';
import 'package:fyp/views/clinic/healthRecordInputPage.dart';
import 'package:fyp/views/clinic/scanQrcodePage.dart';
import 'package:fyp/views/clinic/viewClinicAppointment.dart';
import 'package:fyp/views/clinic/viewClinicAppointmentAll.dart';
import 'package:fyp/views/clinic/viewClinicAppointmentDetails.dart';
import 'package:fyp/views/clinic/viewUserPastHealthRecords.dart';
import 'package:fyp/views/forgotPassword.dart';
import 'package:fyp/views/login.dart';
import 'package:fyp/views/member/TrustedHealthProviderAll.dart';
import 'package:fyp/views/member/healthRecordOverview.dart';
import 'package:fyp/views/member/showQRcode.dart';
import 'package:fyp/views/member/viewHealthRecordDetails.dart';
import 'package:fyp/views/member/viewMyAppointment.dart';
import 'package:fyp/views/member/viewPersonalProfile.dart';
import 'package:fyp/views/member/viewHealthRecordAll.dart';
import 'package:fyp/views/register.dart';
import 'package:fyp/views/registerClinic.dart';
import 'package:fyp/models/clinic.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {

    case BasePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BasePage(),
      );

    case ViewUserHealthRecordArea.routeName:
      final argument = routeSettings.arguments as Map;
      var userAddress = argument["userAddress"];
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ViewUserHealthRecordArea(userAddress: userAddress),
      );

    case InsertRecordOrViewRecordPage.routeName:
      final argument = routeSettings.arguments as Map;
      var appointmentId = argument["appointmentId"];
      var appointmentData = argument["appointmentData"];
      var userAddress = argument["userAddress"];
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => InsertRecordOrViewRecordPage(appointmentId: appointmentId, appointmentData: appointmentData, userAddress: userAddress),
      );

    case HealthRecordInputArea.routeName:
      final argument = routeSettings.arguments as Map;
      var appointmentId = argument["appointmentId"];
      var appointmentData = argument["appointmentData"];
      var userAddress = argument["userAddress"];
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HealthRecordInputArea(appointmentId: appointmentId, appointmentData: appointmentData, userAddress: userAddress),
      );

    case MyAppointmentDetailsClinicArea.routeName:
      final argument = routeSettings.arguments as Map;
      var appointmentData = argument["appointmentId"] as AppointmentInfo;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => MyAppointmentDetailsClinicArea(data: appointmentData),
      );

    case ClinicInfoArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ClinicInfoArea(),
      );

    case MyAppointmentAllClinicArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => MyAppointmentAllClinicArea(),
      );

    case MyAppointmentClinicArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => MyAppointmentClinicArea(),
      );

    case ScanQrCodeClinicArea.routeName:
      final argument = routeSettings.arguments as Map;
      var appointmentId = argument["appointmentId"];
      var appointmentData = argument["appointmentData"];
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ScanQrCodeClinicArea(id: appointmentId, appointmentData: appointmentData??[]),
      );

      //Member
    case ClinicDetailsArea.routeName:
      final argument = routeSettings.arguments as Map;
      var clinicData = argument["clinic"] as ClinicInfo;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ClinicDetailsArea(clinic: clinicData),
      );

    case ClinicBookingPageArea.routeName:
      final argument = routeSettings.arguments as Map;
      var clinicData = argument["clinic"] as ClinicInfo;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ClinicBookingPageArea(clinic: clinicData),
      );

    case ClinicBookingConfirmPageArea.routeName:
      final argument = routeSettings.arguments as Map;
      var clinicData = argument["clinic"] as ClinicInfo;
      var doctor = argument["selectedDoctor"] as String;
      var date = argument["selectedDate"] as DateTime;
      var time = argument["selectedTime"] as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ClinicBookingConfirmPageArea(clinic: clinicData, doctor: doctor, date: date, time:time),
      );

    case PersonalProfileArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PersonalProfileArea(),
      );

    case MyAppointmentUserArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MyAppointmentUserArea(),
      );

    case HealthRecordOverviewUserArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HealthRecordOverviewUserArea(),
      );

    case HealthRecordViewAllUserArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HealthRecordViewAllUserArea(),
      );

    case HealthRecordViewDetailsUserArea.routeName:
      final argument = routeSettings.arguments as Map;
      var healthRecordData = argument["healthRecordData"];
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HealthRecordViewDetailsUserArea(healthRecordData:healthRecordData),
      );

    case TrustedHealthProviderAllArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const TrustedHealthProviderAllArea(),
      );

    case ShowQRCodeUserArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ShowQRCodeUserArea(),
      );

      //common page
    case RegisterPageDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterPageDetails(),
      );

    case RegisterClinicArea.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const RegisterClinicArea(),
      );

    case ForgotPasswordPageDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ForgotPasswordPageDetails(),
      );

    case LoginPageDetails.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginPageDetails(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
