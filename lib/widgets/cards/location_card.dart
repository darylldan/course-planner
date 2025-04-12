import 'dart:io';

import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/constants.dart' as C;

/*
 *  This widget expects a LatLng to be resolved 
 */

class LocationCard extends StatefulWidget {
  final LatLng coords;
  const LocationCard({super.key, required this.coords});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
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
                  color: Theme.of(context).colorScheme.tertiaryContainer),
              child: InkWell(
                child: Column(
                  children: [
                    _buildLocation(context, cacheStore),
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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(C.cardBorderRadius)),
      clipBehavior: Clip.hardEdge,
      height: 150, // Increased height for better visibility
      child: Stack(
        children: [
          AbsorbPointer(
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                  initialCenter: widget.coords,
                  keepAlive: true,
                  initialZoom: 19,
                  interactionOptions:
                      InteractionOptions(flags: InteractiveFlag.none)),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.iscompanion',
                  tileProvider: CachedTileProvider(
                      store: cacheStore), // Ensure network loading
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
          ),
        ],
      ),
    );
  }
}
