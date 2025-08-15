import 'dart:async';

import 'package:dengue_shield/widgets/appbar/appbar.dart';
import 'package:dengue_shield/widgets/stats_card/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LocationData? _currentLocation;
  MapType _currentMapType = MapType.hybrid;

  // Default camera position
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.2906, 80.6337), // Sri Lanka coordinates
    zoom: 10.0,
  );

  // Example outbreak data
  final List<Map<String, dynamic>> outbreakData = [
    {
      "tile_id": "lat7.123_lon80.456",
      "date_generated": "2025-08-07",
      "forecast_horizon_days": 28,
      "outbreak_prob": 0.82,
      "risk_level": "HIGH",
      "recommended_action": "Source reduction & fogging within 7 days",
      "lat": 7.123,
      "lon": 80.456
    },
    {
      "tile_id": "lat7.1223_lon80.456",
      "date_generated": "2025-08-07",
      "forecast_horizon_days": 28,
      "outbreak_prob": 0.82,
      "risk_level": "HIGH",
      "recommended_action": "Source reduction & fogging within 7 days",
      "lat": 7.200, // latitude
      "lon": 80.500
    },
    // sample outbreak data ad more for testinf depends on what brian sends
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final loc = await location.getLocation();
    if (!mounted) return;
    setState(() {
      _currentLocation = loc;
    });
  }

  void _goToMyLocation() async {
    if (_currentLocation != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
      ));
    }
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Appbar(),
          Positioned(
            top: screenWidth * 0.35,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: 0,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Community Health Map',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w700,
                                    height: 1),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: Color(0xff818181),
                                size: screenWidth * 0.04,
                              ),
                              Text(
                                'Molabe',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1),
                              ),
                              Spacer(),
                              //map layer button
                              IconButton(
                                icon: Icon(
                                  Icons.layers,
                                  color: Color(0xff818181),
                                  size: screenWidth * 0.04,
                                ),
                                onPressed: _toggleMapType,
                              ),
                              //map location button
                              IconButton(
                                icon: Icon(
                                  Icons.share_location_sharp,
                                  color: Color(0xff818181),
                                  size: screenWidth * 0.04,
                                ),
                                onPressed: _goToMyLocation,
                              ),
                            ],
                          ),
                          SizedBox(height: 0),
                          SizedBox(
                            height: 450,
                            child: GoogleMap(
                              mapType: _currentMapType,
                              initialCameraPosition: _currentLocation != null
                                  ? CameraPosition(
                                      target: LatLng(
                                          _currentLocation!.latitude!,
                                          _currentLocation!.longitude!),
                                      zoom: 14.5,
                                    )
                                  : _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              circles: Set<Circle>.from(
                                outbreakData.map((data) => Circle(
                                      circleId: CircleId(data["tile_id"]),
                                      center:
                                          LatLng(data["lat"], data["lon"]),
                                      radius: 2000, // 2km
                                      fillColor: Colors.red.withOpacity(0.2),
                                      strokeColor: Colors.red,
                                      strokeWidth: 2,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  //Stats cards row
                  Row(
                    children: [
                      Expanded(
                        child: StatsCard(
                          number: "202",
                          title: "Total Reports",
                          width: double.infinity,
                          height: 80,
                          numberColor: const Color(0xFFD2593C),
                          titleColor: Colors.grey[600]!,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: StatsCard(
                          number: "1,031",
                          title: "Communities",
                          width: double.infinity,
                          height: 80,
                          numberColor: const Color(0xFF4A90E2),
                          titleColor: Colors.grey[600]!,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: StatsCard(
                          number: "70",
                          title: "Sites Cleared",
                          width: double.infinity,
                          height: 80,
                          numberColor: const Color(0xFF28A745),
                          titleColor: Colors.grey[600]!,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: StatsCard(
                          number: "8",
                          title: "New Today",
                          width: double.infinity,
                          height: 80,
                          numberColor: const Color(0xFFFFC107),
                          titleColor: Colors.grey[600]!,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  //change location button
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(44, 39, 127, 1),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        // Handle change location
                      },
                      child: Text("Change Location",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
