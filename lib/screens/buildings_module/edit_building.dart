import 'package:iscompanion/models/Building.dart';
import 'package:iscompanion/providers/building_provider.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/elements/location_picker_button.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class EditBuilding extends StatefulWidget {
  final Building bldg;

  EditBuilding({super.key, required this.bldg});

  @override
  State<EditBuilding> createState() => _EditBuildingState();
}

class _EditBuildingState extends State<EditBuilding> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _buildingNameCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  LatLng? _selectedLocation;

  void _onLocationSelected(LatLng? location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  void initState() {
    super.initState();
    _buildingNameCtrl.text = widget.bldg.buildingName;
    _notesCtrl.text = widget.bldg.notes ?? "";
    if (widget.bldg.latitude != null) {
      _selectedLocation = LatLng(widget.bldg.latitude!, widget.bldg.longitude!);
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
              TitleText(title: "Edit Building"),
              InfoCard(content: "Complete all required forms."),
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
            LocationPickerButton(
              onLocationSelected: _onLocationSelected,
              initialLoc: _selectedLocation,
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextFormField(
                controller: _buildingNameCtrl,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Physical Sciences Building',
                    labelText: 'Building Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a building name.";
                  }

                  return null;
                },
              ),
            ),
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

                          Building editedBuilding = widget.bldg;

                          editedBuilding.buildingName = _buildingNameCtrl.text;
                          editedBuilding.notes = _notesCtrl.text;

                          if (_selectedLocation == null) {
                            editedBuilding.latitude = null;
                            editedBuilding.longitude = null;
                          } else {
                            editedBuilding.latitude =
                                _selectedLocation?.latitude;
                            editedBuilding.longitude =
                                _selectedLocation?.longitude;
                          }

                          context
                              .read<BuildingProvider>()
                              .editBuilding(editedBuilding);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Building edited."),
                          ));
                          Navigator.of(context).pop(editedBuilding);
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
      _buildingNameCtrl.text == widget.bldg.buildingName &&
      _notesCtrl.text == widget.bldg.notes &&
      _selectedLocation?.latitude == widget.bldg.latitude &&
      _selectedLocation?.longitude == widget.bldg.longitude;
}
