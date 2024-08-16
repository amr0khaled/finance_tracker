import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// {
//   'name': String,
//   'description': String,
//   'is_expense': bool,
//   'value': int,
//   'category': String
// }
//

SnackBar snackBar(BuildContext context,
    {String? title, Function()? onPressed}) {
  Color text = Theme.of(context).colorScheme.onErrorContainer;
  Color backgroundColor = Theme.of(context).colorScheme.errorContainer;
  return SnackBar(
    content: Text(
      title ?? 'TEST',
      style: TextStyle(color: text, fontSize: 18),
    ),
    duration: const Duration(seconds: 3),
    showCloseIcon: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    margin: const EdgeInsets.fromLTRB(40, 0, 40, 10),
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    backgroundColor: backgroundColor,
    closeIconColor: text,
    dismissDirection: DismissDirection.horizontal,
    elevation: 6,
    action: SnackBarAction(
      label: 'Undo',
      textColor: text,
      onPressed: onPressed ??
          () {
            BlocProvider.of<TrackCollectionBloc>(context)
                .add(const TrackCollectionUndoTrackEvent());
          },
    ),
  );
}

bool descOpen = false;

class TrackCard extends StatefulWidget {
  const TrackCard(this.data, {super.key});
  final TrackState data;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  double originX = 0;
  double _editBannerWidth = 0;
  double cardDims = 0;
  Offset _slideOffset = Offset.zero;

  bool _editSnap = false;

  bool _redBannerOpen = false;
  bool _removeSnap = false;
  double _redBannerWidth = 0;

  GlobalKey cardKey = GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    String description = widget.data.description;
    Size screen = MediaQuery.sizeOf(context);
    double bannerMaxWidth = screen.width / 4;

    return GestureDetector(
      onHorizontalDragStart: (details) {
        originX = details.localPosition.dx;
        descOpen = false;
        print('originX $originX');
      },
      onHorizontalDragUpdate: (details) {
        double draggingValue = 0;
        setState(() {
          _slideOffset += Offset(details.delta.dx / screen.width, 0);
          draggingValue = details.localPosition.dx - originX;
          print('draggingValue $draggingValue');
          if (details.delta.dx < 0) {
            _editBannerWidth += (details.delta.dx) * -1;
            if (_editBannerWidth == 0) {
              _editBannerWidth = 0;
            }
          } else {
            _editBannerWidth += details.delta.dx;
          }
          if (draggingValue > 0 && !_editSnap) {
            _redBannerWidth += details.delta.dx;
            if (_redBannerWidth == 0) {
              _redBannerWidth = 0;
            }
            _redBannerOpen = true;
          } else if (draggingValue <= 0 && !_removeSnap) {
            _redBannerOpen = false;
          }
          if (_editSnap) {
            _slideOffset = Offset(_slideOffset.dx.clamp(-1.0, 0), 0);
          }
          if (_removeSnap) {
            _slideOffset = Offset(_slideOffset.dx.clamp(0, 1.0), 0);
          }
          _slideOffset = Offset(_slideOffset.dx.clamp(-1.0, 1.0), 0);
        });

        if (originX > details.delta.dx) {
          double value = details.delta.dx;
          if (value.sign < 0) {
            value *= -1;
          } else {
            value *= -1;
          }
          //double width = (value / fullWidth) * (screen.width / 4);
        }
      },
      onHorizontalDragEnd: (details) {
        double snapPoint = 0;
        double maxSnapPoint = ((bannerMaxWidth - 45) / (screen.width - 40));
        if (_slideOffset.dx.abs() < (0.65 * maxSnapPoint)) {
          snapPoint = 0.0; // Snap to center (min position)
          _editSnap = false;
          _removeSnap = false;
        } else if (_slideOffset.dx < 0) {
          snapPoint = ((bannerMaxWidth - 25) / (screen.width - 40)) *
              -1; // Snap to max position (left)
          _editSnap = true;
          _removeSnap = false;
        } else if (_redBannerOpen) {
          snapPoint = ((bannerMaxWidth - 25) /
              (screen.width - 40)); // Snap to min position (right)
          _editSnap = false;
          _removeSnap = true;
        }

        setState(() {
          _slideOffset = Offset(snapPoint, 0);
          if (snapPoint == 0) {
            _editBannerWidth = 0;
          }
        });
      },
      child: Stack(
        fit: StackFit.loose,
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade200,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Container(
                  alignment: Alignment.center,
                  width: _editBannerWidth,
                  height: 72,
                  constraints: BoxConstraints(maxWidth: bannerMaxWidth - 25),
                  child: Icon(
                    MdiIcons.squareEditOutline,
                    color: _editBannerWidth == 0
                        ? Colors.transparent
                        : Colors.black87,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
          _redBannerOpen
              ? Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade200,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        alignment: Alignment.center,
                        width: _redBannerWidth,
                        height: 72,
                        constraints: BoxConstraints(maxWidth: bannerMaxWidth),
                        child: IconButton(
                          onPressed: () {
                            context.watch<TrackCollectionBloc>().add(
                                TrackCollectionRemoveTrackEvent(
                                    widget.data.id));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar(context));
                          },
                          icon: Icon(
                            MdiIcons.close,
                            color: _redBannerWidth == 0
                                ? Colors.transparent
                                : Colors.black87,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          AnimatedSlide(
              key: cardKey,
              offset: _slideOffset,
              duration: Durations.medium2,
              curve: Curves.linearToEaseOut,
              child: Container(
                width: screen.width,
                constraints: const BoxConstraints(minHeight: 72),
                decoration: BoxDecoration(
                    color: Color.alphaBlend(Colors.black45,
                        Theme.of(context).colorScheme.secondaryContainer),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
                                    Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                foregroundColor: WidgetStatePropertyAll(
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer)),
                            child: Text(widget.data.value.toString()),
                          )
                        ],
                      ),
                    ),
                    AnimatedSize(
                      duration: Durations.medium2,
                      curve: Curves.linearToEaseOut,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(bottom: 24),
                        constraints: BoxConstraints(
                            maxHeight: descOpen ? double.infinity : 0),
                        child: Text(
                          description,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
