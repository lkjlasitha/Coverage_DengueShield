class AppointmentData {
  final String referenceCode;
  final String patientName;
  final String testType;
  final String hospital;
  final DateTime date;
  final String time;
  final List<String> documents;
  final String qrData;

  AppointmentData({
    required this.referenceCode,
    required this.patientName,
    required this.testType,
    required this.hospital,
    required this.date,
    required this.time,
    required this.documents,
    required this.qrData,
  });
}
