import 'package:course_planner/models/Building.dart';
import 'package:course_planner/models/Room.dart';
import 'package:course_planner/providers/building_provider.dart';
import 'package:course_planner/providers/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

import 'dart:io';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:path_provider/path_provider.dart';

class BuildingCard extends StatefulWidget {
  final Building bldg;

  const BuildingCard({super.key, required this.bldg});

  @override
  State<BuildingCard> createState() => _BuildingCardState();
}

class _BuildingCardState extends State<BuildingCard> {
  final Future<CacheStore> _cacheStoreFuture = _getCacheStore();

  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();

    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CacheStore>(
      future: _cacheStoreFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cacheStore = snapshot.data!;

          return Material(
            borderRadius: BorderRadius.circular(C.cardBorderRadius),
            clipBehavior: Clip.hardEdge,
            child: Ink(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(C.cardBorderRadius),
                  color: Theme.of(context).colorScheme.onInverseSurface),
              child: InkWell(
                borderRadius: BorderRadius.circular(C.cardBorderRadius),
                onTap: () {},
                onLongPress: () => _showActions(context),
                child: Column(
                  children: [
                    _buildLocation(context, cacheStore),
                    _buildingCardContainer(context),
                  ],
                ),
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

  Widget _buildLocation(BuildContext context, CacheStore cacheStore) {
    return SizedBox(
      height: 150, // Increased height for better visibility
      child: Stack(
        children: [
          FlutterMap(
            mapController: MapController(),
            options: MapOptions(
                initialCenter:
                    LatLng(widget.bldg.latitude, widget.bldg.longitude),
                keepAlive: true,
                initialZoom: 19,
                interactionOptions:
                    InteractionOptions(flags: InteractiveFlag.none)),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.course_planner',
                tileProvider: CachedTileProvider(
                    store: cacheStore), // Ensure network loading
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

  Widget _buildingCardContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: C.titleCardPaddingH, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                  width: 4,
                  height: 50,
                ),
                const SizedBox(width: 8), // Add some spacing
                // Column with text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bldg.buildingName,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow
                            .ellipsis, // Add this to prevent overflow
                        maxLines: 1, // Ensure it fits within one line
                      ),
                      _roomCount(context)
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showActions(context),
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
    );
  }

  Widget _roomCount(BuildContext context) {
    List<Room> rooms =
        context.read<RoomProvider>().getAllRoomsInBuilding(widget.bldg.id!);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
      child: Text(
        "${rooms.length} ROOM${rooms.length == 1 ? '' : 'S'}",
        style: TextStyle(
            color: Theme.of(context).colorScheme.onInverseSurface,
            fontSize: 11,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: C.screenHorizontalPadding, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Actions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: const Text("Edit Building"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => EditClass(
                    //               subject: subject,
                    //             )));
                  },
                ),
                ListTile(
                  title: const Text("Delete Building"),
                  leading: const Icon(Icons.delete_forever_rounded),
                  onTap: () {
                    // To-Do add modal confimation
                    context
                        .read<BuildingProvider>()
                        .deleteBuilding(widget.bldg.id!);

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Building deleted."),
                      ));
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
