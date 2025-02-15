import 'package:course_planner/models/Building.dart';
import 'package:course_planner/screens/misc/view_location.dart';
import 'package:course_planner/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../utils/constants.dart' as c;

import 'dart:io';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:path_provider/path_provider.dart';

class ViewBuilding extends StatefulWidget {
  final Building bldg;

  const ViewBuilding({super.key, required this.bldg});

  @override
  State<ViewBuilding> createState() => _ViewBuildingState();
}

class _ViewBuildingState extends State<ViewBuilding> {
  final Future<CacheStore> _cacheStoreFuture = _getCacheStore();

  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();

    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: c.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: "View Building"),
              _buildMainCard(context),
              _roomsTitle(context)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
              widget.bldg.latitude!.toStringAsFixed(8),
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
}
