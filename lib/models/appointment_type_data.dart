import 'dart:convert';

class AppointmentType {
  int id;
  int appointmentDateId;
  String appointmentTime;
  int? numberOfAllowedAppointments;


  AppointmentType({
    required this.id,
    required this.appointmentDateId,
    required this.appointmentTime,
    required this.numberOfAllowedAppointments,
  });

  factory AppointmentType.fromJson(Map<String, dynamic> json) {
    return AppointmentType(
      id: json['id'],
      appointmentDateId: json['appointmentDateId'],
      numberOfAllowedAppointments: json['numberOfAllowedAppointments'] ?? 0,
      appointmentTime: json['appointmentTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentDateId': appointmentDateId,
      'appointmentTime': appointmentTime,
      'numberOfAllowedAppointments': numberOfAllowedAppointments,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory AppointmentType.fromJsonString(String jsonString) {
    return AppointmentType.fromJson(jsonDecode(jsonString));
  }
}
