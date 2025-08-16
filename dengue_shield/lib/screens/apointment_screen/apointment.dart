import 'package:dengue_shield/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

class MosquitoTestFlowScreen extends StatefulWidget {
  const MosquitoTestFlowScreen({Key? key}) : super(key: key);

  @override
  State<MosquitoTestFlowScreen> createState() => _MosquitoTestFlowScreenState();
}

enum PageState { selectType, selectTest, selectHospital, bookAppointment, appointmentDetails }

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
}

class _MosquitoTestFlowScreenState extends State<MosquitoTestFlowScreen> {
  PageState _page = PageState.selectType;
  String? _selectedType;
  String? _selectedTypeLocal;
  String? _selectedTest;
  String? _selectedHospital;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  Color? _selectedColor;
  List<PlatformFile>? _selectedFiles;
  AppointmentData? _appointmentData;
  int _selectedNavIndex = 0;
  bool _showHistory = false;

  // Hardcoded history data
  final List<HistoryAppointment> _historyAppointments = [
    HistoryAppointment(
      referenceCode: 'A1B2C3D4',
      patientName: 'Venuka Harshana',
      testType: 'NS1 Antigen',
      hospital: 'General Hospital',
      date: DateTime(2024, 11, 5),
      time: '09:00 - 12:00',
      status: 'Completed',
    ),
    HistoryAppointment(
      referenceCode: 'E5F6G7H8',
      patientName: 'Venuka Harshana',
      testType: 'Full Blood Count',
      hospital: 'City Hospital',
      date: DateTime(2024, 10, 20),
      time: '12:00 - 15:00',
      status: 'Completed',
    ),
    HistoryAppointment(
      referenceCode: 'I9J0K1L2',
      patientName: 'Venuka Harshana',
      testType: 'PCR Test',
      hospital: 'Medical Center',
      date: DateTime(2024, 10, 15),
      time: '15:00 - 18:00',
      status: 'Cancelled',
    ),
  ];

  final List<String> hospitals = [
    'Hospital 1',
    'Hospital 2',
    'Hospital 3',
    'Hospital 4',
  ];

  final List<String> timeSlots = [
    "09:00 - 12:00",
    "12:00 - 15:00",
    "15:00 - 18:00",
  ];

  final List<TestType> testTypes = [
    TestType('Dengue Test', 'Dengue Tests', Color(0xffEB4335), 'ඩෙංගු පරීක්ෂණ'),
    TestType('Malaria Test', 'Malaria Tests', Color(0xff34A853), 'මලේරියා පරීක්ෂණ'),
    TestType('Japanese Encephalitis', 'Japanese Encephalitis Tests', Color(0xff4285F4), 'බරවා පරීක්ෂණ'),
    TestType('Chikungunya Test', 'Chikungunya Tests', Color(0xffFBBC05), 'චිකන්ගුන්යා පරීක්ෂණ'),
  ];

  static const Map<String, List<String>> testByType = {
    'Dengue Test': [
      'NS1 Antigen Test',
      'IgG Antibody Test',
      'Full Blood Count',
      'PCR Test',
    ],
    'Malaria Test': [
      'Blood Smear Microscopy',
      'Rapid Diagnostic Test',
    ],
    'Japanese Encephalitis': [
      'Serological ELISA',
      'PCR Test',
    ],
    'Chikungunya Test': [
      'RT-PCR Assay',
      'IgM Capture ELISA',
    ],
  };

  String _generateReferenceCode() {
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();
  }

  String _generateQRData(String referenceCode) {
    return 'REF:$referenceCode|TEST:$_selectedTest|HOSPITAL:$_selectedHospital|DATE:${DateFormat('dd/MM/yyyy').format(_selectedDate)}|TIME:$_selectedTime';
  }

  void _bookAppointment() {
    final referenceCode = _generateReferenceCode();
    final qrData = _generateQRData(referenceCode);
    
    _appointmentData = AppointmentData(
      referenceCode: referenceCode,
      patientName: 'Venuka Harshana',
      testType: _selectedTest!,
      hospital: _selectedHospital!,
      date: _selectedDate,
      time: _selectedTime!,
      documents: _selectedFiles?.map((f) => f.name).toList() ?? [],
      qrData: qrData,
    );

    _showAppointmentConfirmationDialog();
  }

  void _showAppointmentConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Note',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your appointment has been successfully booked. Details have been sent to your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap:() {
                      Navigator.of(context).pop();
                      setState(() {
                        _page = PageState.appointmentDetails;
                      });
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
      for (var file in result.files) {
        debugPrint("Picked file: ${file.name}, path: ${file.path}");
      }
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
      if (index == 0) {
        // Home - show current flow
        _showHistory = false;
      } else if (index == 1) {
        // History - show history page
        _showHistory = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: _showHistory ? _buildHistoryPage() : _buildMainContent(),
      ),
      bottomNavigationBar: (_page == PageState.bookAppointment || _page == PageState.appointmentDetails || _showHistory) ? BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: _onNavItemTapped,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ) : null,
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
      child: Column(
        children: [
          if (_page != PageState.appointmentDetails) ...[
            Row(
              children: [
                if (_page != PageState.selectType)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (_page == PageState.bookAppointment) {
                          _page = PageState.selectHospital;
                        } else if (_page == PageState.selectHospital) {
                          _page = PageState.selectTest;
                          _selectedHospital = null;
                        } else if (_page == PageState.selectTest) {
                          _page = PageState.selectType;
                          _selectedType = null;
                          _selectedTest = null; 
                          _selectedColor = null;
                        }
                      });
                    },
                  ),
                if (_page == PageState.selectType)
                  const SizedBox(width: 51),
                Expanded(
                  child: Center(
                    child: Text(
                      _page == PageState.selectTest ? "Choose a Test" :
                      _page == PageState.selectHospital
                          ? 'Select the Hospital'
                          : _page == PageState.bookAppointment
                              ? 'Book Appointment'
                              : 'Select a Test',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _page == PageState.selectType ? "Please select the mosquito\nrelated test from the options below." : _page == PageState.selectTest
                  ? "Select the test you want to \ncontinue with."
                  : _page == PageState.selectHospital
                      ? "Please select your preferred hospital from the list below to proceed with the test."
                      : "",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
          ],
          Expanded(child: _buildPageContent()),
        ],
      ),
    );
  }

  Widget _buildHistoryPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
      child: Column(
        children: [
          // Header
          const SizedBox(height: 10),
          const Text(
            'History',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'View your past appointments &\ntest reports',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          
          // History content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Appointments section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Appointments',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ..._historyAppointments.map((appointment) => _buildHistoryAppointmentCard(appointment)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Results Summary section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Results Summary',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildResultSummaryCard('Dengue - Negative', '12/10/2024', 'General Hospital', 'Full Blood Count', '09:00 - 12:00'),
                        _buildResultSummaryCard('Malaria - Negative', '28/09/2024', 'City Hospital', 'Blood Smear', '14:00 - 17:00'),
                        _buildResultSummaryCard('Dengue - Positive', '15/09/2024', 'Medical Center', 'NS1 Antigen', '10:00 - 13:00'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryAppointmentCard(HistoryAppointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: mainColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(appointment.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appointment.testType} - ${appointment.hospital}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  appointment.time,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: appointment.status == 'Completed' ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              appointment.status,
              style: TextStyle(
                color: appointment.status == 'Completed' ? Colors.green[800] : Colors.red[800],
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSummaryCard(String result, String date, String hospital, String test, String time) {
    final isPositive = result.contains('Positive');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description,
            color: mainColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isPositive ? Colors.red[700] : Colors.green[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$test - $hospital',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '$date, $time',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('View full report')),
              );
            },
            icon: Icon(
              Icons.visibility,
              color: Colors.grey[600],
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_page) {
      case PageState.selectType:
        return SingleChildScrollView(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.9,
            children: testTypes.map((tt) => _testTypeCard(tt)).toList(),
          ),
        );

      case PageState.selectTest:
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 125,
                  decoration: BoxDecoration(
                    color: _selectedColor ?? Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _selectedType ?? "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedTypeLocal ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 35),
                ...testByType[_selectedType]!.map((test) {
                  final selected = _selectedTest == test;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTest = test;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected ? Color(0xff4F46E5).withOpacity(0.23) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:  Color(0xff4F46E5).withOpacity(0.19),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          test,
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 16,
                            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                _bottomButton("Next", _selectedTest != null ? () {
                  setState(() {
                    _page = PageState.selectHospital;
                  });
                } : null),  
              ],
            ),
          ),
        );

      case PageState.selectHospital:
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text(
                  _selectedType ?? "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _selectedTypeLocal ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(height: 35),
                ...hospitals.map((h) {
                  final selected = _selectedHospital == h;
                  return _optionCard(h, selected, () {
                    setState(() {
                      _selectedHospital = h;
                    });
                  });
                }).toList(),
                const SizedBox(height: 20),
                _bottomButton("Start", _selectedHospital != null ? () {
                  setState(() {
                    _page = PageState.bookAppointment;
                  });
                } : null),
              ],
            ),
          ),
        );

      case PageState.bookAppointment:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Select a Time:",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              Wrap(
                spacing: 2,
                direction: Axis.vertical,
                children: timeSlots.map((slot) {
                  final selected = _selectedTime == slot;
                  return ChoiceChip(
                    label: Text(slot),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedTime = slot;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                "Upload your Reports:",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  dashPattern: const [6, 3],
                  color: Colors.white,
                  strokeWidth: 2,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.17),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Drag your file(s) to start uploading",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 1,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white
                              ),
                            ),
                            const Text(
                              "OR",
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            Container(
                              height: 1,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _pickFiles,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: mainColor,
                          ),
                          child: const Text("Browse files"),
                        ),
                        if (_selectedFiles != null && _selectedFiles!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            "${_selectedFiles!.length} file(s) selected",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _bottomButton("Start", _selectedTime != null ? _bookAppointment : null),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );

      case PageState.appointmentDetails:
        return _buildAppointmentDetailsPage();
    }
  }

  Widget _buildAppointmentDetailsPage() {
    if (_appointmentData == null) return Container();

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _page = PageState.bookAppointment;
                  });
                },
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Your Appointment',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _detailRow('Patient Name', _appointmentData!.patientName),
                    _detailRow('Test', _appointmentData!.testType),
                    _detailRow('Hospital', _appointmentData!.hospital),
                    _detailRow('Date', DateFormat('dd/MM/yyyy').format(_appointmentData!.date)),
                    _detailRow('Time', _appointmentData!.time),
                    _detailRow('Documents', _appointmentData!.documents.isEmpty ? 'No' : 'Yes'),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // QR Code Section
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Scan this QR at the hospital',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: QrImageView(
                        data: _appointmentData!.qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Appointment ID: ${_appointmentData!.referenceCode}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('QR Code downloaded')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Download QR',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cancel appointment')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffE54646),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel appointment',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _testTypeCard(TestType type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type.key;
          _selectedTypeLocal = type.localLabel;
          _selectedTest = null; 
          _selectedColor = type.color; 
          _page = PageState.selectTest;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(height: 4, color: type.color),
            ),
            Column(
              children: [
                const SizedBox(height: 25),
                Text(type.display, textAlign: TextAlign.center, style: TextStyle(color: mainColor, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Text(type.localLabel, textAlign: TextAlign.center, style: TextStyle(color: mainColor, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionCard(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? Color(0xff4F46E5).withOpacity(0.23) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:  Color(0xff4F46E5).withOpacity(0.19),
              width: selected ? 2 : 1,
            ),
          ),
        child: Center(
          child: Text(text, style: TextStyle(color: mainColor, fontWeight: selected ? FontWeight.bold : FontWeight.w500, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _bottomButton(String text, VoidCallback? onPressed) {
    return onPressed != null ? SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _page == PageState.bookAppointment ? Color(0xffFFC92B) : mainColor,
          foregroundColor:  _page == PageState.bookAppointment ? Color(0xffFFC92B) : mainColor,  
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 , color: Colors.white, )),
      ),
    ) : SizedBox();
  }
}

class TestType {
  final String key;
  final String display;
  final Color color;
  final String localLabel;

  TestType(this.key, this.display, this.color, this.localLabel);
}