import 'package:course_planner/screens/buildings_module/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../utils/constants.dart' as C;

class LocationPickerButton extends StatefulWidget {
  final ValueChanged<LatLng?> onLocationSelected;
  final LatLng? initialLoc;
  const LocationPickerButton(
      {super.key, required this.onLocationSelected, required this.initialLoc});

  @override
  State<LocationPickerButton> createState() => _LocationPickerButtonState();
}

class _LocationPickerButtonState extends State<LocationPickerButton> {
  LatLng? _pickedLocation;

  void _setLocation(double lat, double long) {
    LatLng newLocation = LatLng(lat, long);

    setState(() {
      _pickedLocation = newLocation;
    });

    widget.onLocationSelected(newLocation);
  }

  void _removeLocation() {
    setState(() {
      _pickedLocation = null;
    });

    widget.onLocationSelected(null);
  }

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLoc;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Material(
        borderRadius: BorderRadius.circular(C.cardBorderRadius),
        clipBehavior: Clip.hardEdge,
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(C.cardBorderRadius),
              color: Theme.of(context).colorScheme.onInverseSurface),
          child: InkWell(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            onTap: () async {
              Map<String, double>? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LocationPicker(id: -1, structType: "new")));

              if (result != null) {
                _setLocation(result['lat']!, result['long']!);
              }
            },
            child: SizedBox(
              height: _pickedLocation == null ? 100 : 235,
              child: Column(
                children: [
                  if (_pickedLocation != null) _buildLocation(context),
                  if (_pickedLocation != null) _buildLatLng(context),
                  if (_pickedLocation != null)
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Opacity(
                            opacity: 0.5,
                            child: Divider(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_rounded,
                              size: 18,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Edit Location",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (_pickedLocation == null)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 36,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                            Text(
                              "Select Location",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      if (_pickedLocation != null)
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: IconButton(
              onPressed: () => _removeLocation(),
              icon: Icon(
                Icons.cancel,
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
          ),
        ),
    ]);
  }

  Widget _buildLocation(BuildContext context) {
    return SizedBox(
      height: 125, // Increased height for better visibility
      child: Stack(
        children: [
          FlutterMap(
            mapController: MapController(),
            options: MapOptions(
                initialCenter: LatLng(
                    _pickedLocation!.latitude, _pickedLocation!.longitude),
                keepAlive: true,
                initialZoom: 19,
                interactionOptions:
                    InteractionOptions(flags: InteractiveFlag.none)),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.course_planner',
                tileProvider: NetworkTileProvider(), // Ensure network loading
              ),
            ],
          ),
          Center(
            child: Icon(
              Icons.location_on,
              color: Theme.of(context).colorScheme.primaryContainer,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatLng(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "LATITUDE",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                _pickedLocation!.latitude.toStringAsFixed(8),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "LONGITUDE",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                _pickedLocation!.longitude.toStringAsFixed(8),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
