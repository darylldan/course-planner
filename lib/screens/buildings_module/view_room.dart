import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/models/Subject.dart';
import 'package:course_planner/models/Term.dart';
import 'package:course_planner/providers/building_provider.dart';
import 'package:course_planner/providers/subject_provider.dart';
import 'package:course_planner/providers/term_provider.dart';
import 'package:course_planner/screens/buildings_module/edit_room.dart';
import 'package:course_planner/screens/misc/view_location.dart';
import 'package:course_planner/widgets/cards/error_card_no_action.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/quick_notes_card.dart';
import 'package:course_planner/widgets/cards/subject_card.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as c;

import 'dart:io';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:path_provider/path_provider.dart';

class ViewRoom extends StatefulWidget {
  Room room;

  ViewRoom({super.key, required this.room});

  @override
  State<ViewRoom> createState() => _ViewRoomState();
}

class _ViewRoomState extends State<ViewRoom> {
  final Future<CacheStore> _cacheStoreFuture = _getCacheStore();

  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();

    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }

  final TextEditingController _subjSearchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Room? editedRoom = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditRoom(
                      room: widget.room,
                    ),
                  ));

              if (editedRoom != null) {
                setState(() {
                  widget.room = editedRoom;
                });
              }
            },
            icon: Icon(Icons.edit),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: c.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: "View Room"),
              _buildMainCard(context),
              const SizedBox(
                height: 12,
              ),
              QuickNotesCard(
                  notes: widget.room.notes,
                  id: widget.room.id!,
                  type: "room",
                  name: widget.room.roomName),
              const SizedBox(
                height: 12,
              ),
              _subjectsTitle(context),
              _buildSubjects(context),
              SizedBox(
                height: 150,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    LatLng? coords = _getRoomCoordinates(context);
    return Material(
      borderRadius: BorderRadius.circular(c.cardBorderRadius),
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(c.cardBorderRadius),
        onTap: (coords == null)
            ? null
            : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewLocation(coords: coords)));
              },
        child: _mainCardContent(context, coords),
      ),
    );
  }

  Widget _mainCardContent(BuildContext context, LatLng? coords) {
    Building? bldg;
    if (widget.room.buildingId != -1) {
      bldg = context
          .read<BuildingProvider>()
          .getBuildingByID(widget.room.buildingId);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(c.cardBorderRadius),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: c.titleCardPaddingH - 6, vertical: c.titleCardPaddingV),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildingName(context),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: c.cardIconSize,
              ),
              SizedBox(width: 8),
              Text(
                widget.room.lat == null &&
                        widget.room.long == null &&
                        widget.room.buildingId != -1
                    ? "Location (Inherited)"
                    : "Location",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: c.titleCardHeaderFontSize,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              )
            ],
          ),
          SizedBox(height: 8),
          _buildMapLocation(context, coords),
          if (coords != null) ...[
            SizedBox(height: 8),
            _coordinateTitle(context),
            _buildCoordinates(context, coords)
          ],
        ],
      ),
    );
  }

  Widget _buildingName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.domain,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: c.cardIconSize,
            ),
            SizedBox(width: 8),
            Text(
              "Room Name",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: c.titleCardHeaderFontSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )
          ],
        ),
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(widget.room.roomName))),
          child: Text(
            widget.room.roomName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: c.titleCardContentFontSize,
                overflow: TextOverflow.ellipsis,
                color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        )
      ],
    );
  }

  Widget _buildMapLocation(BuildContext context, LatLng? coords) {
    return FutureBuilder(
      future: _cacheStoreFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cacheStore = snapshot.data!;

          return Container(
            height: (coords == null) ? 75 : 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(c.cardBorderRadius)),
            clipBehavior: Clip.hardEdge,
            child: (coords == null)
                ? Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 30,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        Text(
                          "No location set.",
                          style: TextStyle(
                              fontSize: c.titleCardHeaderFontSize,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer),
                        )
                      ],
                    ),
                  )
                : AbsorbPointer(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: MapController(),
                          options: MapOptions(
                              initialCenter: coords,
                              keepAlive: true,
                              initialZoom: 19,
                              interactionOptions: InteractionOptions(
                                  flags: InteractiveFlag.none)),
                          children: [
                            TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName:
                                    'com.example.course_planner',
                                tileProvider:
                                    CachedTileProvider(store: cacheStore)),
                            Center(
                              child: Icon(
                                Icons.location_on,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                size: 32,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Opacity(
                opacity: 20,
                child: Icon(
                  Icons.error,
                  size: 20,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  LatLng? _getRoomCoordinates(BuildContext context) {
    final room = widget.room;

    // First priority: room's own coordinates
    if (room.lat != null && room.long != null) {
      return LatLng(room.lat!, room.long!);
    }

    // Second priority: building coordinates, if valid buildingId
    if (room.buildingId != -1) {
      final building =
          context.read<BuildingProvider>().getBuildingByID(room.buildingId);

      if (building.latitude != null && building.longitude != null) {
        return LatLng(building.latitude!, building.longitude!);
      }
    }

    // No valid coordinates found
    return null;
  }

  Widget _coordinateTitle(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            "Coordinates",
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 14),
          ),
        ),
        Expanded(
          child: Opacity(
            opacity: 0.5,
            child: Divider(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinates(BuildContext context, LatLng? coords) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.swap_horiz,
                  size: c.cardIconSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Latitude",
                  style: TextStyle(
                      fontSize: c.titleCardHeaderFontSize,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                )
              ],
            ),
            Text(
              coords!.latitude.toStringAsFixed(8),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )
          ],
        ),
        Opacity(
            opacity: 0.5,
            child: Container(
              width: 1,
              height: 35,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            )),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.swap_vert,
                  size: c.cardIconSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "Longitude",
                  style: TextStyle(
                      fontSize: c.titleCardHeaderFontSize,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                )
              ],
            ),
            Text(
              coords.longitude.toStringAsFixed(8),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )
          ],
        ),
      ],
    );
  }

  Widget _subjectsTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "COURSES",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onInverseSurface),
                ),
              ),
              const Expanded(
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjects(BuildContext context) {
    Term? currentTerm = context.watch<TermProvider>().currentTerm;

    if (currentTerm == null) {
      return InfoCard(
          content: "No terms yet. Create one via the Terms screen.");
    }

    List<Subject> subjects =
        context.watch<SubjectProvider>().getSubjectsByRoom(widget.room.id!, currentTerm.id!);
    List<Subject> filteredSubjects = subjects;

    if (subjects.isEmpty) {
      return InfoCard(content: "No courses in this room yet.");
    }

    if (_subjSearchCtrl.text.isNotEmpty) {
      filteredSubjects = filteredSubjects
          .where((s) => s.courseCode
              .toLowerCase()
              .contains(_subjSearchCtrl.text.toLowerCase()))
          .toList();
    }

    List<Padding> roomCard = filteredSubjects
        .map((s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClassCard(subject: s),
            ))
        .toList();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: _subjSearchCtrl,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                ),
                onChanged: (String val) {
                  setState(() {});
                },
              ),
            ),
            if (_subjSearchCtrl.text.isNotEmpty)
              IconButton(
                  onPressed: () => setState(() {
                        _subjSearchCtrl.clear();
                      }),
                  icon: Icon(Icons.clear))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        if (filteredSubjects.isEmpty && _subjSearchCtrl.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ErrorCardNoAction(
                title: "SEARCH RESULTS", content: "No rooms found."),
          )
        else
          ...roomCard,
        Center(
          child: Text(
            "${filteredSubjects.length} ${filteredSubjects.length == 1 ? "Course" : "Courses"}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onInverseSurface),
          ),
        ),
      ],
    );
  }
}
