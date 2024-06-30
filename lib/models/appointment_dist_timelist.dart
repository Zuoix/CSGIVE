

import 'appointment_timelist.dart';

class ItemModelAppointmentTimeList {
  List<ItemModelAppointmentTime>? morning;
  List<ItemModelAppointmentTime>? afternoon;
  List<ItemModelAppointmentTime>? evening;

  ItemModelAppointmentTimeList({required this.morning,required this.afternoon,required this.evening});
}
List<List<ItemModelAppointmentTime>> timeDistList = [
];

