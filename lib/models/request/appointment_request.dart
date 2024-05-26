class AppointmentRequest {
  final String appointmentTimeId;
  final String date;
  final String appointmentReason;

  AppointmentRequest({
    required this.appointmentTimeId,
    required this.date,
    required this.appointmentReason,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentTimeId': appointmentTimeId,
      'date': date,
      'appointmentReason': appointmentReason,
    };
  }
}
