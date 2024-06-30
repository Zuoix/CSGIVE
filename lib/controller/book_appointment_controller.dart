
import 'dart:developer';

import 'package:cs_give/core/utils/common.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../app.dart';
import '../models/appointment_timelist.dart';
import '../models/appointment_type_data.dart';
import '../models/request/appointment_request.dart';
import '../services/appointment_services.dart';


var timeDistListNullable;
class BookAppointmentController extends GetxController{

  var selectedPackageIndex = 0.obs;

  var appointmentReason = ''.obs;
  var appointMentCompleted = false.obs;
  var selectedTime = '30 minutes'.obs;

  void changeTime(String language) {
    selectedTime.value = language;
  }



  var selectedDate = DateTime.now().obs;
  var appointmentTimes = <AppointmentType>[].obs;
  var isDateWithAppointments = false.obs;

  RxList<List<ItemModelAppointmentTime>> timeDistList =  <List<ItemModelAppointmentTime>>[].obs;
  void fetchAppointmentsForSelectedDate(DateTime date) async {
    selectedDate.value = date;
    try {
      var appointments = await AppointmentServices().getAppointmentsByDate(date.toIso8601String().split('T')[0]);
      appointmentTimes.value = appointments;

      isDateWithAppointments.value = appointmentTimes.isNotEmpty;
      updateTimeList();
    } catch (e) {
      appointmentTimes.clear();
      isDateWithAppointments.value = false;
      showError(e.toString());
      if (!kDebugMode) {
        log('Error fetching appointments: ${e.toString()}');
      }
    }

  }

  void updateTimeList() {
    timeDistList.clear();
    if (appointmentTimes.isNotEmpty) {
      appointmentTimes.sort((a, b) => a.appointmentTime.compareTo(b.appointmentTime));
      // Your existing logic...

      // Add debug prints to check the contents of morning, afternoon, and evening lists


      List<ItemModelAppointmentTime> morning = [];
      List<ItemModelAppointmentTime> afternoon = [];
      List<ItemModelAppointmentTime> evening = [];

      for (int index = 0; index < appointmentTimes.length; index++) {

        var appointment = appointmentTimes[index];
        var time = DateTime.parse('1970-01-01 ${appointment.appointmentTime}');
        var formattedTime = DateFormat.jm().format(time); // 12-hour format

        var item = ItemModelAppointmentTime(
          appointmentId: appointment.id,
          appointmentDateId: appointment.appointmentDateId,
          numberOfAllowedAppointments: appointment.numberOfAllowedAppointments,
          realTime: time,
          appointmentTime: formattedTime,
        );

        if (time.hour < 12 && time.hour >= 0) {
          morning.add(item);
        } else if (time.hour < 18 && time.hour >= 12) {
          afternoon.add(item);
        } else if (time.hour >= 18 && time.hour < 24) {
          evening.add(item);
        }
      }

      if (morning.isNotEmpty) {
        timeDistList.add(morning);
      }
      if (afternoon.isNotEmpty) {
        timeDistList.add(afternoon);
      }
      if (evening.isNotEmpty) {
        timeDistList.add(evening);
      }

    }
  }

  Future<void>  submitApointmentRequest(String appointmentTimeId, String date, String appointmentReason) async {

    final request = AppointmentRequest(
        appointmentTimeId: appointmentTimeId,
        date: date,
        appointmentReason:appointmentReason,
    );
    try {

      final response = await appointmentServices.submitAppointmentRequest(request);
       if (response != null && response.statusCode == '00') {
         appointMentCompleted.value = true;
       } else {
         appointMentCompleted.value = false;
         showError(response?.message ?? 'Failed to book appointment');
       }

    } catch (e) {
      if (kDebugMode) {
        showError('Controller area: '+e.toString());
      }
    }
  }

}







  

