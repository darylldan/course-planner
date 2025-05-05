import 'package:iskotrack/models/Building.dart';
import 'package:iskotrack/models/Room.dart';
import 'package:iskotrack/providers/building_provider.dart';
import 'package:iskotrack/providers/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:iskotrack/utils/constants.dart' as c;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class LocationPicker extends StatefulWidget {
  final int id;
  final String structType;
  const LocationPicker({super.key, required this.id, required this.structType});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late double _initLong;
  late double _initLat;

  @override
  Widget build(BuildContext context) {
    _getStructureObject(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Location"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: MapController(),
            options: MapOptions(
                initialCenter: LatLng(_initLat, _initLong), initialZoom: 19),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.iskotrack',
              ),
              Center(
                child: Icon(
                  Icons.center_focus_weak_sharp,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              _infoConfirmBox(context)
            ],
          )
        ],
      ),
    );
  }

  void _getStructureObject(BuildContext context) {
    if (widget.structType == "new") {
      _initLong = c.obleLong;
      _initLat = c.obleLat;
    }

    if (widget.structType == "building") {
      Building building =
          context.read<BuildingProvider>().getBuildingByID(widget.id);
      _initLat = building.latitude!;
      _initLong = building.longitude!;
    }

    if (widget.structType == "room") {
      Room room = context.read<RoomProvider>().getRoomByID(widget.id);
      _initLat = room.lat!;
      _initLong = room.long!;
    }
  }

  Widget _infoConfirmBox(BuildContext context) {
    return Builder(
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: IntrinsicHeight(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(c.cardBorderRadius),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  border: Border.all(
                      color: Theme.of(context).colorScheme.primary, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87.withOpacity(.25),
                      spreadRadius: 5,
                      blurRadius: 20,
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              MapCamera.of(context)
                                  .center
                                  .latitude
                                  .toStringAsFixed(8),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                              MapCamera.of(context)
                                  .center
                                  .longitude
                                  .toStringAsFixed(8),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, {
                              'long': MapCamera.of(context).center.longitude,
                              'lat': MapCamera.of(context).center.latitude
                            });
                          },
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(context)
                                      .colorScheme
                                      .inverseSurface)),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onInverseSurface),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
