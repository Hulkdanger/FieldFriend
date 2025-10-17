// Automatic FlutterFlow imports
import '/backend/backend.dart';
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import '/actions/actions.dart' as action_blocks;
import "package:supabase_google_map_library_s065pd/backend/schema/structs/index.dart"
    as supabase_google_map_library_s065pd_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class LocustObservationWidget extends StatefulWidget {
  const LocustObservationWidget({
    Key? key,
    this.width,
    this.height,
    this.primaryColor,
    this.textColor,
    this.navigateToPage,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? primaryColor;
  final Color? textColor;
  final String? navigateToPage;

  @override
  _LocustObservationWidgetState createState() =>
      _LocustObservationWidgetState();
}

class _LocustObservationWidgetState extends State<LocustObservationWidget> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Map initialization state
  bool _mapInitialized = false;
  String? _mapInitError;

  // Form variables
  DateTime? _selectedDate;
  String? _selectedCountry;
  String? _selectedMaturity;
  String? _selectedBreeding;
  String? _selectedBehaviour;
  gmaps.LatLng? _selectedLocation;
  bool _useCurrentLocation = true;
  bool _isLoading = false;
  String? _locationError;

  // Google Maps controller
  gmaps.GoogleMapController? _mapController;

  // Complete list of all 195 countries
  final List<String> _countries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Antigua and Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Democratic Republic of the Congo',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'East Timor (Timor-Leste)',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Eswatini',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Ivory Coast',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kosovo',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent and the Grenadines',
    'Samoa',
    'San Marino',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican City',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ];

  // Dropdown options
  final List<String> _maturityOptions = ['Mature', 'Immature'];
  final List<String> _breedingOptions = ['Breeding', 'Not Breeding'];
  final List<String> _behaviourOptions = ['Scattered', 'Groups', 'Swarms'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  Future<void> _initializeMap() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _mapInitialized = true;
          _mapInitError = null;
        });
      }
    } catch (e) {
      print('[LocustObservationWidget] Map initialization error: $e');
      if (mounted) {
        setState(() {
          _mapInitialized = false;
          _mapInitError =
              'Failed to initialize map. Please ensure Google Maps API key is configured.';
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = 'Location permissions are permanently denied';
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedLocation = gmaps.LatLng(position.latitude, position.longitude);
      });

      // Get country from coordinates using API
      await _updateCountryFromLocation(position.latitude, position.longitude);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Error getting location: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateCountryFromLocation(
      double latitude, double longitude) async {
    try {
      // Using BigDataCloud's free reverse geocoding API (no API key required)
      final url = Uri.parse(
          'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$latitude&longitude=$longitude&localityLanguage=en');

      final response = await http.get(url).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String? detectedCountry = data['countryName'];

        if (detectedCountry != null && detectedCountry.isNotEmpty) {
          // Try to match with our country list
          String? matchedCountry = _countries.firstWhere(
            (country) => country.toLowerCase() == detectedCountry.toLowerCase(),
            orElse: () => detectedCountry,
          );

          if (mounted) {
            setState(() {
              _selectedCountry = matchedCountry;
            });
          }
        }
      }
    } catch (e) {
      print('Error getting country from location: $e');
      // Fail silently - this is a convenience feature
    }
  }

  Widget _buildMapPicker() {
    if (!_mapInitialized || _mapInitError != null) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: widget.primaryColor ?? Colors.black),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_mapInitError != null) ...[
                Icon(Icons.error_outline, size: 48, color: Colors.red),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Map unavailable. Please use "Current Location" option.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(
                      color: Colors.red[700],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: _initializeMap,
                  child: Text(
                    'Retry',
                    style: GoogleFonts.sora(),
                  ),
                ),
              ] else ...[
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text(
                  'Initializing map...',
                  style: GoogleFonts.sora(),
                ),
              ],
            ],
          ),
        ),
      );
    }

    try {
      return Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: widget.primaryColor ?? Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onVerticalDragStart: (_) {}, // Prevents parent scroll
                onHorizontalDragStart: (_) {}, // Prevents parent scroll
                child: gmaps.GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: gmaps.CameraPosition(
                    target: gmaps.LatLng(0, 0),
                    zoom: 2,
                  ),
                  onLongPress: (gmaps.LatLng location) {
                    setState(() {
                      _selectedLocation = location;
                      _locationError = null;
                    });
                    // Update country when location is selected on map
                    _updateCountryFromLocation(
                        location.latitude, location.longitude);
                  },
                  markers: _selectedLocation != null
                      ? {
                          gmaps.Marker(
                            markerId: gmaps.MarkerId('selected'),
                            position: _selectedLocation!,
                          ),
                        }
                      : {},
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer(),
                    ),
                    Factory<ScaleGestureRecognizer>(
                      () => ScaleGestureRecognizer(),
                    ),
                    Factory<TapGestureRecognizer>(
                      () => TapGestureRecognizer(),
                    ),
                    Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer(),
                    ),
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Long press on the map to select a location',
              style: GoogleFonts.sora(
                color: widget.textColor ?? Colors.black,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      print('[LocustObservationWidget] Map widget creation error: $e');
      return Container(
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: widget.primaryColor ?? Colors.black),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'Map temporarily unavailable',
                style: GoogleFonts.sora(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Please use "Current Location" option',
                style: GoogleFonts.sora(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> options,
    required void Function(String?) onChanged,
    bool isRequired = false,
  }) {
    final primaryColor = widget.primaryColor ?? Colors.black;
    final textColor = widget.textColor ?? Colors.black;
    final creamColor = Color(0xFFFFDEA); // The cream background color

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label *' : '$label (Optional)',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: creamColor, // Changed from Colors.white to creamColor
            border: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            hintStyle: GoogleFonts.sora(color: Colors.black),
          ),
          hint: Text(
            'Select $label',
            style: GoogleFonts.sora(color: Colors.black),
          ),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(
                option,
                style: GoogleFonts.sora(color: textColor),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select $label';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Future<void> _submitObservation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedLocation == null) {
      setState(() {
        _locationError = 'Please select a location';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final DateTime delayedTime = DateTime.now().add(Duration(hours: 2));
      final String installID = FFAppState().installID;

      final observationData = {
        'location': GeoPoint(
          _selectedLocation!.latitude,
          _selectedLocation!.longitude,
        ),
        'obsDate': Timestamp.fromDate(_selectedDate!),
        'Country': _selectedCountry!,
        'Maturity': _selectedMaturity ?? 'N/A',
        'Breeding': _selectedBreeding ?? 'N/A',
        'Behaviour': _selectedBehaviour ?? 'N/A',
        'UCG': 'Yes',
        'scheduledTime': Timestamp.fromDate(delayedTime),
        'isScheduled': true,
        'installID': installID,
        'Verified': '', // Added empty Verified field
      };

      await FirebaseFirestore.instance
          .collection('scheduledLocustObservations')
          .add(observationData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Observation uploaded successfully! It will appear once reviewed.',
            style: GoogleFonts.sora(),
          ),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedDate = null;
        _selectedCountry = null;
        _selectedMaturity = null;
        _selectedBreeding = null;
        _selectedBehaviour = null;
        _selectedLocation = null;
        _useCurrentLocation = true;
      });

      if (widget.navigateToPage != null && widget.navigateToPage!.isNotEmpty) {
        Navigator.pushNamed(context, widget.navigateToPage!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error scheduling observation: ${e.toString()}',
            style: GoogleFonts.sora(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? Colors.black;
    final backgroundColor = Color(0xFFFFDEA);
    final textColor = widget.textColor ?? Colors.black;

    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Locust Sighting',
                style: GoogleFonts.sora(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 20),

              // Location Section
              Text(
                'Location *',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8),

              RadioListTile<bool>(
                title: Text(
                  'Current Location',
                  style: GoogleFonts.sora(
                    color: _useCurrentLocation ? textColor : Colors.grey,
                    fontSize: 14,
                  ),
                ),
                value: true,
                groupValue: _useCurrentLocation,
                activeColor: primaryColor,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() {
                    _useCurrentLocation = value!;
                    if (_useCurrentLocation) {
                      _getCurrentLocation();
                    }
                  });
                },
              ),
              RadioListTile<bool>(
                title: Text(
                  'Pick on Map',
                  style: GoogleFonts.sora(
                    color: !_useCurrentLocation ? textColor : Colors.grey,
                    fontSize: 14,
                  ),
                ),
                value: false,
                groupValue: _useCurrentLocation,
                activeColor: primaryColor,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (_mapInitError != null)
                    ? null
                    : (value) {
                        setState(() {
                          _useCurrentLocation = value!;
                        });
                      },
              ),
              if (_mapInitError != null)
                Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    '(Map unavailable - use Current Location)',
                    style: GoogleFonts.sora(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              if (_useCurrentLocation) ...[
                ElevatedButton(
                  onPressed: _isLoading ? null : _getCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    _selectedLocation != null
                        ? 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}'
                        : 'Get Current Location',
                    style: GoogleFonts.sora(color: Colors.white),
                  ),
                ),
              ] else ...[
                _buildMapPicker(),
                if (_selectedLocation != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Selected: ${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                      style: GoogleFonts.sora(
                        color: textColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],

              if (_locationError != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    _locationError!,
                    style: GoogleFonts.sora(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),

              SizedBox(height: 20),

              // Observation Date
              Text(
                'Observation Date *',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: primaryColor,
                          ),
                          textTheme: GoogleFonts.soraTextTheme(
                            Theme.of(context).textTheme,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFDEA), // Added cream background color
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                              : 'Select Date',
                          style: GoogleFonts.sora(
                            color:
                                _selectedDate != null ? textColor : Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.calendar_today, color: primaryColor),
                    ],
                  ),
                ),
              ),
              if (_selectedDate == null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Please select a date',
                    style: GoogleFonts.sora(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),

              SizedBox(height: 20),

              // Country Dropdown
              _buildDropdownField(
                label: 'Country',
                value: _selectedCountry,
                options: _countries,
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
                isRequired: true,
              ),

              SizedBox(height: 20),

              // Maturity Dropdown
              _buildDropdownField(
                label: 'Maturity',
                value: _selectedMaturity,
                options: _maturityOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedMaturity = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Breeding Status Dropdown
              _buildDropdownField(
                label: 'Breeding Status',
                value: _selectedBreeding,
                options: _breedingOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedBreeding = value;
                  });
                },
              ),

              SizedBox(height: 20),

              // Behaviour Dropdown
              _buildDropdownField(
                label: 'Behaviour',
                value: _selectedBehaviour,
                options: _behaviourOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedBehaviour = value;
                  });
                },
              ),

              SizedBox(height: 30),

              // Submit Button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_selectedDate == null) {
                          setState(() {});
                          return;
                        }
                        _submitObservation();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Upload Observation for Review',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sora(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),

              // Bottom padding
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
