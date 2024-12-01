import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class CategorySegment<T> {
  CategorySegment({this.icon, this.label, required this.value});
  final T value;
  Widget? label;
  Widget? icon;
}

class CategoryButton<T> extends StatefulWidget {
  CategoryButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onChange,
    this.lastButton = false,
    this.lastLabel,
    this.onLastButton,
  });
  final List<CategorySegment<T>> segments;
  final Set<T> selected;
  final bool lastButton;
  String? lastLabel;

  void Function(Set<T>)? onChange;
  Future<T> Function()? onLastButton;

  @override
  State<CategoryButton<T>> createState() => _CategoryButtonState<T>();
}

class _CategoryButtonState<T> extends State<CategoryButton<T>> {
  late Set<T> _selected;
  late List<CategorySegment<T>> _segments;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
    _segments = widget.segments;
    addLastButton();
  }

  void addLastButton() {
    if (widget.lastButton != false && !_endbuttonAdded) {
      setState(() {
        _segments.add(
            CategorySegment<String>(value: "+ ${widget.lastLabel ?? 'New'}")
                as CategorySegment<T>);
        _endbuttonAdded = true;
      });
    }
  }

  late bool _endbuttonAdded = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (var i = 0; i < _segments.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            child: TextButton.icon(
              style: OutlinedButton.styleFrom(
                  backgroundColor: _segments[i] != _segments.last
                      ? _selected.any((e) => e == _segments[i].value)
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.transparent
                      : Theme.of(context).colorScheme.secondaryContainer,
                  foregroundColor: _segments[i] != _segments.last
                      ? _selected.any((e) => e == _segments[i].value)
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Colors.black54
                      : Theme.of(context).colorScheme.onSecondaryContainer,
                  side: BorderSide(
                    width: 1.2,
                    color: _segments[i] != _segments.last
                        ? _selected.any((e) => e == _segments[i].value)
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Colors.black54
                        : Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64))),
              onPressed: _segments[i] == _segments.last && widget.lastButton
                  ? () async {
                      if (widget.onLastButton != null && widget.lastButton) {
                        final newCategory = await widget.onLastButton!();
                        // setState(() => _endbuttonAdded = false);
                        // _segments.remove(_segments.last);
                        // _segments.add(CategorySegment(value: newCategory));
                      }
                    }
                  : () => setState(() {
                        if (_selected
                                .toList()
                                .indexWhere((e) => e == _segments[i].value) ==
                            -1) {
                          _selected.add(_segments[i].value);
                        } else {
                          _selected.remove(_segments[i].value);
                        }
                        if (widget.onChange != null) {
                          widget.onChange!(_selected);
                        }
                      }),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSize(
                      duration: Durations.short3,
                      child: Icon(
                        UniconsSolid.check,
                        size: _segments[i] != _segments.last &&
                                _selected.any((e) => e == _segments[i].value)
                            ? null
                            : 0,
                      ),
                    ),
                    _segments[i].label ?? Text(_segments[i].value.toString()),
                  ],
                ),
              ),
              icon: _segments[i].icon,
            ),
          )
      ],
    );
  }
}
