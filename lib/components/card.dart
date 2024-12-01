import 'package:finance_tracker/utils/tracks/tracks_bloc.dart';
import 'package:finance_tracker/views/income_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

SnackBar snackBar(BuildContext context,
    {String? title, Function()? onPressed}) {
  Color text = Theme.of(context).colorScheme.surface;
  return SnackBar(
    content: Text(
      title ?? 'TEST',
      style: TextStyle(color: text, fontSize: 14),
    ),
    duration: const Duration(seconds: 5),
    showCloseIcon: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.fromLTRB(40, 0, 40, 10),
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    backgroundColor: Theme.of(context).colorScheme.onSurface,
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

class TrackCard extends StatefulWidget {
  const TrackCard(this.data, this.index, {super.key});
  final TrackState data;
  final int index;

  @override
  State<TrackCard> createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> with TickerProviderStateMixin {
  late AnimationController _ctrl;

  bool descOpen = false;
  double originX = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: Durations.medium2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _ctrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String description = widget.data.description;
    Size screen = MediaQuery.sizeOf(context);
    double bannerMaxWidth = screen.width / 4;

    return Container(
      width: screen.width,
      constraints: const BoxConstraints(minHeight: 72),
      decoration: BoxDecoration(
          color: Color.alphaBlend(
              Colors.black45, Theme.of(context).colorScheme.secondaryContainer),
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.only(bottom: 32),
      child: Slidable(
        key: Key(widget.data.id),
        startActionPane: ActionPane(
          extentRatio: 0.15,
          motion: const StretchMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            setState(() {
              incomeListKey.currentState!.removeItem(
                  widget.index,
                  (c, a) => buildItem(c, a, Offset.zero, _ctrl,
                      TrackCard(widget.data, widget.index)));
              context
                  .read<TrackCollectionBloc>()
                  .add(TrackCollectionRemoveTrackEvent(widget.data.id));
            });
          }),
          children: [
            CustomSlidableAction(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(26),
                    bottomLeft: Radius.circular(26)),
                onPressed: (_) {},
                autoClose: true,
                backgroundColor: Colors.redAccent.shade200,
                child: Container(
                  alignment: Alignment.center,
                  height: 72,
                  constraints: BoxConstraints(maxWidth: bannerMaxWidth - 25),
                  child: Icon(
                    MdiIcons.close,
                    color: Colors.black87,
                    size: 36,
                  ),
                ))
          ],
        ),
        endActionPane: ActionPane(
            extentRatio: 0.15,
            motion: const StretchMotion(),
            dismissible: DismissiblePane(onDismissed: () {}),
            children: [
              CustomSlidableAction(
                  flex: 1,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(26),
                      bottomRight: Radius.circular(26)),
                  onPressed: (_) {},
                  autoClose: true,
                  backgroundColor: Colors.greenAccent.shade200,
                  child: Container(
                    alignment: Alignment.center,
                    height: 72,
                    constraints: BoxConstraints(maxWidth: bannerMaxWidth - 25),
                    child: Icon(
                      MdiIcons.squareEditOutline,
                      color: Colors.black87,
                      size: 36,
                    ),
                  ))
            ]),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(24),
            color: Color.alphaBlend(Colors.black45,
                Theme.of(context).colorScheme.secondaryContainer),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  constraints:
                      BoxConstraints(maxHeight: descOpen ? double.infinity : 0),
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
        ),
      ),
    );
  }
}
