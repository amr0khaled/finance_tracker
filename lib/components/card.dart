import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// {
//   'name': String,
//   'description': String,
//   'is_expense': bool,
//   'value': int,
//   'category': String
// }

bool descOpen = false;

class TrackCard extends StatefulWidget {
  const TrackCard(this.data, {super.key});
  final TrackState data;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  @override
  Widget build(BuildContext context) {
    String description = widget.data.description;
    Size screen = MediaQuery.sizeOf(context);

    return Container(
      width: screen.width,
      constraints:
          const BoxConstraints(minHeight: 72, maxHeight: double.infinity),
      decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.secondaryContainer.withAlpha(127),
          borderRadius: BorderRadius.circular(24)),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  description.isEmpty
                      ? Container()
                      : IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          onPressed: () {
                            setState(() {
                              descOpen = !descOpen;
                            });
                          },
                          isSelected: descOpen,
                          icon: Icon(MdiIcons.chevronDown),
                          selectedIcon: Icon(MdiIcons.chevronUp),
                          iconSize: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(widget.data.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        )),
                  )
                ]),
                FilledButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(5),
                      backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primaryContainer),
                      foregroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.onPrimaryContainer)),
                  child: Text(widget.data.value.toString()),
                )
              ],
            ),
          ),
          descOpen
              ? Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
