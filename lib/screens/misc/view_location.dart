import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:path_provider/path_provider.dart';

class ViewLocation extends StatefulWidget {
  final LatLng coords;
  const ViewLocation({super.key, required this.coords});

  @override
  State<ViewLocation> createState() => _ViewLocationState();
}

class _ViewLocationState extends State<ViewLocation> {
  final Future<CacheStore> _cacheStoreFuture = _getCacheStore();

  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();

    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Location"),
      ),
      body: FutureBuilder<CacheStore>(
          future: _cacheStoreFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final cacheStore = snapshot.data!;
              return _buildMap(context, cacheStore);
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
          }),
    );
  }

  Widget _buildMap(BuildContext context, CacheStore cacheStore) {
    return Stack(
      children: [
        FlutterMap(
          mapController: MapController(),
          options: MapOptions(initialZoom: 19, initialCenter: widget.coords),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.iscompanion',
              tileProvider: CachedTileProvider(store: cacheStore),
            ),
            MarkerLayer(markers: [
              Marker(
                  point: widget.coords,
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    size: 32,
                  ))
            ])
          ],
        )
      ],
    );
  }
}
