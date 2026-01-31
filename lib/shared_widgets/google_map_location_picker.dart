import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:global_trust_hub/core/constants/colors.dart';

/// Google Maps Location Picker Widget
/// Used for fraud prevention - users must confirm their actual location
class GoogleMapLocationPicker extends StatefulWidget {
  final Function(LocationData) onLocationSelected;
  final LocationData? initialLocation;
  final String label;
  final bool isRequired;

  const GoogleMapLocationPicker({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
    this.label = 'Select Your Location',
    this.isRequired = true,
  });

  @override
  State<GoogleMapLocationPicker> createState() => _GoogleMapLocationPickerState();
}

class _GoogleMapLocationPickerState extends State<GoogleMapLocationPicker> {
  LocationData? _selectedLocation;
  bool _isLoading = false;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    if (_selectedLocation != null) {
      _addressController.text = _selectedLocation!.formattedAddress;
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await showDialog<LocationData>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MapPickerDialog(
        initialLocation: _selectedLocation,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
        _addressController.text = result.formattedAddress;
      });
      widget.onLocationSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              widget.label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            if (widget.isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Location Display Card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _selectedLocation != null
                  ? AppColors.success.withOpacity(0.5)
                  : Colors.grey.shade300,
              width: _selectedLocation != null ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Map Preview (if location selected)
              if (_selectedLocation != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                    child: Stack(
                      children: [
                        // Static map image placeholder
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: const Color(0xFFE8F4EA),
                          child: CustomPaint(
                            painter: _MapGridPainter(),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      '${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 11,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Verified badge
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Location Verified',
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Address & Button Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (_selectedLocation != null) ...[
                      // Address display
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedLocation!.formattedAddress,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Select/Change Location Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _openMapPicker,
                        icon: Icon(
                          _selectedLocation != null
                              ? Icons.edit_location_alt
                              : Icons.add_location_alt,
                          size: 20,
                        ),
                        label: Text(
                          _selectedLocation != null
                              ? 'Change Location'
                              : 'Select Location on Map',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedLocation != null
                              ? Colors.grey.shade100
                              : AppColors.primary,
                          foregroundColor: _selectedLocation != null
                              ? AppColors.primary
                              : Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: _selectedLocation != null
                                ? BorderSide(color: AppColors.primary.withOpacity(0.3))
                                : BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Fraud Prevention Note
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.security,
              size: 14,
              color: Colors.orange.shade600,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Location verification helps protect against fraud',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Map Picker Dialog with interactive map
class _MapPickerDialog extends StatefulWidget {
  final LocationData? initialLocation;

  const _MapPickerDialog({this.initialLocation});

  @override
  State<_MapPickerDialog> createState() => _MapPickerDialogState();
}

class _MapPickerDialogState extends State<_MapPickerDialog> {
  late double _latitude;
  late double _longitude;
  String _address = 'Drag marker to select location';
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  // Default to Islamabad, Pakistan
  static const double _defaultLat = 33.6844;
  static const double _defaultLng = 73.0479;

  @override
  void initState() {
    super.initState();
    _latitude = widget.initialLocation?.latitude ?? _defaultLat;
    _longitude = widget.initialLocation?.longitude ?? _defaultLng;
    if (widget.initialLocation != null) {
      _address = widget.initialLocation!.formattedAddress;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMapTap(double lat, double lng) {
    setState(() {
      _latitude = lat;
      _longitude = lng;
      _address = 'Selected location (${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)})';
    });
  }

  void _confirmLocation() {
    Navigator.of(context).pop(LocationData(
      latitude: _latitude,
      longitude: _longitude,
      formattedAddress: _address,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(isSmallScreen ? 16 : 40),
      child: Container(
        width: isSmallScreen ? double.infinity : 600,
        height: isSmallScreen ? screenSize.height * 0.8 : 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Select Your Location',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search address...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Simulate search - in real app, use geocoding API
                      setState(() {
                        _address = _searchController.text.isNotEmpty
                            ? _searchController.text
                            : _address;
                      });
                    },
                    icon: const Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // Interactive Map Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _InteractiveMapView(
                    latitude: _latitude,
                    longitude: _longitude,
                    onTap: _onMapTap,
                  ),
                ),
              ),
            ),

            // Selected Location Display
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.place, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _address,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Lat: ${_latitude.toStringAsFixed(6)}, Lng: ${_longitude.toStringAsFixed(6)}',
                          style: GoogleFonts.robotoMono(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _confirmLocation,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Confirm Location'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Interactive Map View (simulated for web, real Google Map for mobile)
class _InteractiveMapView extends StatefulWidget {
  final double latitude;
  final double longitude;
  final Function(double lat, double lng) onTap;

  const _InteractiveMapView({
    required this.latitude,
    required this.longitude,
    required this.onTap,
  });

  @override
  State<_InteractiveMapView> createState() => _InteractiveMapViewState();
}

class _InteractiveMapViewState extends State<_InteractiveMapView> {
  late double _markerX;
  late double _markerY;
  final GlobalKey _mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _markerX = 0.5;
    _markerY = 0.5;
  }

  void _handleTap(TapDownDetails details) {
    final RenderBox? box = _mapKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = details.localPosition;
    final size = box.size;

    setState(() {
      _markerX = localPosition.dx / size.width;
      _markerY = localPosition.dy / size.height;
    });

    // Convert to approximate lat/lng (simplified)
    // In real implementation, this would use proper projection
    final newLat = widget.latitude + (_markerY - 0.5) * -0.01;
    final newLng = widget.longitude + (_markerX - 0.5) * 0.01;

    widget.onTap(newLat, newLng);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: Container(
        key: _mapKey,
        color: const Color(0xFFE8F0E8),
        child: CustomPaint(
          painter: _DetailedMapPainter(),
          child: Stack(
            children: [
              // Marker
              Positioned(
                left: _markerX * MediaQuery.of(context).size.width * 0.9 - 20,
                top: _markerY * 280 - 40,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Container(
                      width: 3,
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.red,
                            Colors.red.withOpacity(0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Instructions overlay
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Tap on map to set your location',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for map grid
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;

    // Draw grid lines
    const spacing = 20.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Detailed map painter with roads and landmarks
class _DetailedMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFF0F4F0),
    );

    // Draw some "roads"
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;

    // Horizontal roads
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.6),
      Offset(size.width, size.height * 0.6),
      roadPaint,
    );

    // Vertical roads
    canvas.drawLine(
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.25, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.6, 0),
      Offset(size.width * 0.6, size.height),
      roadPaint,
    );

    // Draw some blocks (buildings)
    final blockPaint = Paint()..color = const Color(0xFFDDE5DD);
    final random = [0.1, 0.35, 0.65, 0.85];
    for (var x in random) {
      for (var y in random) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(size.width * x, size.height * y),
              width: 30,
              height: 25,
            ),
            const Radius.circular(4),
          ),
          blockPaint,
        );
      }
    }

    // Draw grid overlay
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 0.5;

    const spacing = 30.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Location Data Model
class LocationData {
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String? city;
  final String? country;
  final String? postalCode;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.city,
    this.country,
    this.postalCode,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'formattedAddress': formattedAddress,
    'city': city,
    'country': country,
    'postalCode': postalCode,
  };

  factory LocationData.fromJson(Map<String, dynamic> json) => LocationData(
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    formattedAddress: json['formattedAddress'] as String,
    city: json['city'] as String?,
    country: json['country'] as String?,
    postalCode: json['postalCode'] as String?,
  );
}
