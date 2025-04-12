import 'package:iscompanion/models/Building.dart';
import 'package:iscompanion/providers/building_provider.dart';
import 'package:iscompanion/widgets/cards/info_card.dart';
import 'package:iscompanion/widgets/elements/location_picker_button.dart';
import 'package:iscompanion/widgets/elements/title_text.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../utils/constants.dart' as C;

class AddBuilding extends StatefulWidget {
  const AddBuilding({super.key});

  @override
  State<AddBuilding> createState() => _AddBuildingState();
}

class _AddBuildingState extends State<AddBuilding> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: C.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: "Add Building"),
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
            LocationPickerButton(
              onLocationSelected: _onLocationSelected,
              initialLoc: null,
            ),
            SizedBox(
              height: 12,
            ),
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

                          Building newBuilding = Building()
                            ..buildingName = _buildingNameCtrl.text
                            ..latitude = _selectedLocation?.latitude
                            ..longitude = _selectedLocation?.longitude
                            ..notes = _notesCtrl.text;

                          context
                              .read<BuildingProvider>()
                              .createBuilding(newBuilding);

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Building added."),
                          ));
                          Navigator.of(context).pop();
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
                title: const Text("Discard building creation?"),
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
      _buildingNameCtrl.text.isEmpty &&
      _notesCtrl.text.isEmpty &&
      _selectedLocation == null;
}
