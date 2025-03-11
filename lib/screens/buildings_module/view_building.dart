import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:course_planner/screens/buildings_module/add_room.dart';
import 'package:course_planner/screens/buildings_module/edit_building.dart';
import 'package:course_planner/screens/misc/view_location.dart';
import 'package:course_planner/widgets/cards/error_card_no_action.dart';
import 'package:course_planner/widgets/cards/info_card.dart';
import 'package:course_planner/widgets/cards/quick_notes_card.dart';
import 'package:course_planner/widgets/cards/room_card.dart';
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

class ViewBuilding extends StatefulWidget {
  Building bldg;

  ViewBuilding({super.key, required this.bldg});

  @override
  State<ViewBuilding> createState() => _ViewBuildingState();
}

class _ViewBuildingState extends State<ViewBuilding> {
  final Future<CacheStore> _cacheStoreFuture = _getCacheStore();

  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();

    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }

  TextEditingController _roomSearchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              Building? editedBuilding = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditBuilding(
                      bldg: widget.bldg,
                    ),
                  ));

              if (editedBuilding != null) {
                setState(() {
                  widget.bldg = editedBuilding;
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
              TitleText(title: "View Building"),
              _buildMainCard(context),
              const SizedBox(
                height: 12,
              ),
              QuickNotesCard(
                  notes: widget.bldg.notes,
                  id: widget.bldg.id!,
                  type: "building",
                  name: widget.bldg.buildingName),
              const SizedBox(
                height: 12,
              ),
              _roomsTitle(context),
              _buildRooms(context),
              SizedBox(
                height: 150,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddRoom(
                        bldg: widget.bldg,
                      )));
        },
        label: Text("Create Room"),
        icon: Icon(Icons.add),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(c.cardBorderRadius),
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(c.cardBorderRadius),
        onTap: (widget.bldg.latitude == null && widget.bldg.longitude == null)
            ? null
            : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewLocation(
                            coords: LatLng(widget.bldg.latitude!,
                                widget.bldg.longitude!))));
              },
        child: _mainCardContent(context),
      ),
    );
  }

  Widget _mainCardContent(BuildContext context) {
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
                "Location",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: c.titleCardHeaderFontSize,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              )
            ],
          ),
          SizedBox(height: 8),
          _buildMapLocation(context),
          if (widget.bldg.longitude != null &&
              widget.bldg.latitude != null) ...[
            SizedBox(height: 8),
            _coordinateTitle(context),
            _buildCoordinates(context)
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
              "Building Name",
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: c.titleCardHeaderFontSize,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            )
          ],
        ),
        GestureDetector(
          onTap: () => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(widget.bldg.buildingName))),
          child: Text(
            widget.bldg.buildingName,
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

  Widget _buildMapLocation(BuildContext context) {
    return FutureBuilder(
      future: _cacheStoreFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cacheStore = snapshot.data!;

          return Container(
            height:
                (widget.bldg.latitude == null && widget.bldg.longitude == null)
                    ? 75
                    : 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(c.cardBorderRadius)),
            clipBehavior: Clip.hardEdge,
            child: (widget.bldg.latitude == null &&
                    widget.bldg.longitude == null)
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
                              initialCenter: LatLng(widget.bldg.latitude!,
                                  widget.bldg.longitude!),
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

  Widget _buildCoordinates(BuildContext context) {
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
              widget.bldg.latitude!.toStringAsFixed(8),
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
              widget.bldg.longitude!.toStringAsFixed(8),
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

  Widget _roomsTitle(BuildContext context) {
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
                  "ROOMS",
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

  Widget _buildRooms(BuildContext context) {
    List<Room> rooms =
        context.watch<RoomProvider>().getAllRoomsInBuilding(widget.bldg.id!);
    List<Room> filteredRooms = rooms;

    if (rooms.isEmpty) {
      return InfoCard(content: "No rooms in this building yet.");
    }

    if (_roomSearchCtrl.text.isNotEmpty) {
      filteredRooms = filteredRooms.where((r) => r.roomName
          .toLowerCase()
          .contains(_roomSearchCtrl.text.toLowerCase())).toList();
    }

    List<Padding> roomCard = filteredRooms
        .map((r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: RoomCard(room: r),
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
                controller: _roomSearchCtrl,
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: 'Search',
                ),
                onChanged: (String val) {
                  setState(() {});
                },
              ),
            ),
            if (_roomSearchCtrl.text.isNotEmpty) 
              IconButton(onPressed: () => setState(() {
                _roomSearchCtrl.clear();
              }), icon: Icon(Icons.clear))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        if (filteredRooms.isEmpty && _roomSearchCtrl.text.isNotEmpty) 
          Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ErrorCardNoAction(
              title: "SEARCH RESULTS", content: "No rooms found."),
        )
        else
          ...roomCard,
        Center(
          child: Text(
            "${filteredRooms.length} ${filteredRooms.length == 1 ? "Room" : "Rooms"}",
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
