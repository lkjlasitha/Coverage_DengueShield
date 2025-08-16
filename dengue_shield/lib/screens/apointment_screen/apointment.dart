import 'package:dengue_shield/config/theme.dart';
import 'package:dengue_shield/services/message_service/message_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import '../../models/appointment/appointment/appointments.dart';
import '../../models/appointment/history_appointments/HistoryAppointment .dart';
import '../../services/appointment_service/appointment_api_service.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

enum PageState { selectType, selectTest, selectHospital, bookAppointment, appointmentDetails }

class _AppointmentScreenState extends State<AppointmentScreen> {
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
  bool _isLoadingHistory = false;
  List<HistoryAppointment> _apiHistoryAppointments = [];

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

  void _bookAppointment() async {
    final referenceCode = _generateReferenceCode();
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final timeForApi = _selectedTime!.split(' - ')[0]; // Gets "09:00" from "09:00 - 12:00"
    
    final result = await AppointmentApiService.bookAppointment(
      hospitalName: _selectedHospital!,
      date: formattedDate,
      time: timeForApi,
      category: _selectedTest!,
      referenceNum: referenceCode,
      pdf: true,
      context: context
    );
    
    if (result != null) {
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
    } else {
      MessageUtils.showApiErrorMessage(context, 'Failed to book appointment. Please try again.');
    }
  }

  Future<void> _loadAppointmentHistory() async {
    if (_isLoadingHistory) return;
    
    setState(() {
      _isLoadingHistory = true;
    });

    final appointments = await AppointmentApiService.getAppointmentHistory(context);
    
    setState(() {
      _isLoadingHistory = false;
      if (appointments != null) {
        _apiHistoryAppointments = appointments;
      }
    });
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
        _showHistory = false;
      } else if (index == 1) {
        _showHistory = true;
        if (_apiHistoryAppointments.isEmpty) {
          _loadAppointmentHistory();
        }
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
            'View your past appointments &\ntest records',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      if (_isLoadingHistory)
                        const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      else if (_apiHistoryAppointments.isEmpty)
                        const Center(
                          child: Text(
                            'No appointments found',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        ..._apiHistoryAppointments.map((appointment) => _buildHistoryAppointmentCard(appointment)),
                    ],
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 26 , vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Colors.grey[600],
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                DateFormat('dd/MM/yyyy').format(appointment.date),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.local_hospital_outlined,
                color: Colors.grey[600],
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                appointment.hospital,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.science_outlined,
                color: Colors.grey[600],
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                appointment.testType,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                color: Colors.grey[600],
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                appointment.time,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                _showAppointmentDetailsDialog(appointment);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: mainColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'View Details',
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetailsDialog(HistoryAppointment appointment) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 16),
                  blurRadius: 100,
                  color: Colors.black.withOpacity(0.25)
                ),
                BoxShadow(
                  offset: Offset(0, 16),
                  blurRadius: 100,
                  color: Colors.black.withOpacity(0.25)
                )
              ]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Appointment Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  appointment.patientName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Appointment details
                _buildDetailRow(
                  Icons.calendar_today_outlined,
                  DateFormat('dd/MM/yyyy').format(appointment.date),
                ),
                const SizedBox(height: 16),
                
                _buildDetailRow(
                  Icons.local_hospital_outlined,
                  appointment.hospital,
                ),
                const SizedBox(height: 16),
                
                _buildDetailRow(
                  Icons.science_outlined,
                  appointment.testType,
                ),
                const SizedBox(height: 16),
                
                _buildDetailRow(
                  Icons.access_time_outlined,
                  appointment.time,
                ),
                const SizedBox(height: 32),
                Column(
                  children: [
                    const Text(
                      'Results Summary',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Platelet Count: 150,000 (Normal)',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Negative',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Documents: Yes (link)',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF saved successfully'),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: mainColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Save as PDF',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Icon(
            icon,
            color: mainColor,
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: mainColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
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