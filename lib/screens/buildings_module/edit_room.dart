import 'package:iskotrack/models/Building.dart';
import 'package:iskotrack/models/Room.dart';
import 'package:iskotrack/providers/room_provider.dart';
import 'package:iskotrack/screens/buildings_module/select_building.dart';
import 'package:iskotrack/widgets/cards/info_card.dart';
import 'package:iskotrack/widgets/elements/location_picker_button.dart';
import 'package:iskotrack/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class EditRoom extends StatefulWidget {
  final Room room;
  final Building? bldg;
  const EditRoom({super.key, required this.room, this.bldg});

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roomNameCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  LatLng? _selectedLocation;
  Building? _selectedBuilding;

  void _onLocationSelected(LatLng? location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedBuilding = widget.bldg;
    _roomNameCtrl.text = widget.room.roomName;
    _notesCtrl.text = widget.room.notes ?? "";

    if (widget.room.lat != null) {
      _selectedLocation = LatLng(widget.room.lat!, widget.room.long!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: "Edit Room"),
              InfoCard(content: "Complete required fields."),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Opacity(
                  opacity: 0.5,
                  child: Divider(),
                ),
              ),
              _buildForms(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForms(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          if (_canPop) {
            if (context.mounted) Navigator.of(context).pop();
          } else {
            var shouldExit = await _onWillPop(context);

            if (shouldExit) {
              if (context.mounted) Navigator.of(context).pop();
            }
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: _roomNameCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'ICS PC Lab 7',
                    labelText: 'Room Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a room name.";
                  }

                  return null;
                },
              ),
            ),
            SizedBox(
              height: 12,
            ),
            LocationPickerButton(
              onLocationSelected: _onLocationSelected,
              initialLoc: _selectedLocation,
            ),
            SizedBox(
              height: 12,
            ),
            _buildingSelector(context),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Opacity(
                opacity: 0.5,
                child: Divider(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _notesCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: '"Enter notes here (Optional)"',
                    labelText: 'Notes (Optional)'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.primaryContainer)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          Room editedRoom = widget.room
                            ..buildingId = _selectedBuilding?.id ?? -1
                            ..roomName = _roomNameCtrl.text
                            ..lat = _selectedLocation?.latitude
                            ..long = _selectedLocation?.longitude
                            ..notes = _notesCtrl.text;

                          context.read<RoomProvider>().editRoom(editedRoom);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Room edited."),
                          ));
                          Navigator.of(context).pop(editedRoom);
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildingSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Building",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
          ),
          Spacer(),
          Flexible(
            fit: FlexFit.loose,
            child: TextButton(
                onPressed: () async {
                  Building? selectedBldg = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectBuilding()));
                  if (selectedBldg != null) {
                    setState(() {
                      _selectedBuilding = selectedBldg;
                    });
                  }
                },
                child: Text(
                  _selectedBuilding?.buildingName ?? "Select",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                )),
          ),
          if (_selectedBuilding != null)
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Building cleared.")));
                setState(() {
                  _selectedBuilding = null;
                });
              },
              icon: Icon(
                Icons.cancel,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              iconSize: 18,
            )
        ],
      ),
    );
  }

  // Responsible for "Discard creation?"
  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Discard building editing?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Discard'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  )
                ],
              );
            })) ??
        false;
  }

  bool get _canPop =>
      _roomNameCtrl.text == widget.room.roomName &&
      _notesCtrl.text == widget.room.notes &&
      _selectedBuilding?.id! == widget.room.buildingId &&
      _selectedLocation?.longitude == widget.room.long &&
      _selectedLocation?.latitude == widget.room.lat;
}
