
class HistoryAppointment {
  final String referenceCode;
  final String patientName;
  final String testType;
  final String hospital;
  final DateTime date;
  final String time;
  final String status;

  HistoryAppointment({
    required this.referenceCode,
    required this.patientName,
    required this.testType,
    required this.hospital,
    required this.date,
    required this.time,
    required this.status,
  });
  
  factory HistoryAppointment.fromApi(Map<String, dynamic> json) {
    return HistoryAppointment(
      referenceCode: json['referenceNum'] ?? '',
      patientName: json['patientName'] ?? 'Unknown',
      testType: json['category'] ?? '',
      hospital: json['hospitalName'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      time: json['time'] ?? '',
      status: json['status'] ?? 'Completed',
    );
  }
}