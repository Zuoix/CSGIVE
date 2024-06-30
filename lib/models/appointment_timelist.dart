

class ItemModelAppointmentTime{
  int? appointmentId;
  int? appointmentDateId;
  int? numberOfAllowedAppointments;
  String? appointmentTime;
  DateTime? realTime;

  ItemModelAppointmentTime({this.appointmentId,this.appointmentDateId,this.numberOfAllowedAppointments,this.appointmentTime, this.realTime});
}
List<ItemModelAppointmentTime> timeList = [
  ItemModelAppointmentTime(appointmentId: 0, appointmentDateId: 30, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
  ItemModelAppointmentTime(appointmentId: 1, appointmentDateId: 31, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
  ItemModelAppointmentTime(appointmentId: 2, appointmentDateId: 32, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
  ItemModelAppointmentTime(appointmentId: 3, appointmentDateId: 33, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
  ItemModelAppointmentTime(appointmentId: 4, appointmentDateId: 34, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
  ItemModelAppointmentTime(appointmentId: 5, appointmentDateId: 35, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
  ItemModelAppointmentTime(appointmentId: 6, appointmentDateId: 36, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
  ItemModelAppointmentTime(appointmentId: 7, appointmentDateId: 37, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
  ItemModelAppointmentTime(appointmentId: 8, appointmentDateId: 38, numberOfAllowedAppointments: 1, appointmentTime: "09:00 am", realTime: DateTime.now()),
];

