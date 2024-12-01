import 'package:finance_tracker/views/add_view/todo.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddTodoSubTodo extends StatelessWidget {
  const AddTodoSubTodo(
      {super.key,
      required this.onChanged,
      required this.onDone,
      required this.onCancel});
  final void Function(String) onChanged;
  final VoidCallback onDone;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    print(VisualDensity.minimumDensity);
    print(VisualDensity.maximumDensity);
    return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints:
                    BoxConstraints(maxWidth: (screen.width - 40) * 0.6),
                child: SizedBox(
                  child: TextFormField(
                    onChanged: onChanged,
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                        hintText: ' Enter the Sub To Do.',
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w300)),
                    maxLines: 1,
                  ),
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.surface,
                height: 32,
                constraints: BoxConstraints(
                  maxWidth: (screen.width - 40) * 0.21,
                  minWidth: (32 * 2) + 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: onCancel,
                      icon: Icon(MdiIcons.close, size: 24),
                      style: IconButton.styleFrom(
                          foregroundColor: Color.alphaBlend(Colors.black54,
                              Theme.of(context).colorScheme.error),
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          padding: const EdgeInsets.all(0),
                          fixedSize: const Size(32, 32),
                          backgroundColor:
                              Theme.of(context).colorScheme.errorContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                    ),
                    IconButton(
                      onPressed: onDone,
                      icon: Icon(MdiIcons.check, size: 24),
                      style: IconButton.styleFrom(
                          foregroundColor: Color.alphaBlend(Colors.black54,
                              Theme.of(context).colorScheme.onPrimaryContainer),
                          visualDensity: const VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity),
                          padding: const EdgeInsets.all(0),
                          fixedSize: const Size(32, 32),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6))),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class AddTodoSubTodoCompleted extends StatelessWidget {
  const AddTodoSubTodoCompleted({
    super.key,
    required this.data,
    required this.onDelete,
    required this.onChecked,
  });
  final void Function(Todo) onDelete;
  final void Function(bool?) onChecked;
  final Todo data;

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.sizeOf(context);
    return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screen.width * 0.6,
                child: Row(
                  children: [
                    Checkbox.adaptive(
                        splashRadius: 16,
                        value: data.value,
                        onChanged: onChecked,
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        side: const BorderSide(width: 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                    Text(
                      data.title,
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.surface,
                height: 32,
                width: 32,
                child: IconButton(
                  onPressed: () => onDelete(this.data),
                  icon: Icon(MdiIcons.trashCan, size: 18),
                  style: IconButton.styleFrom(
                      foregroundColor: Color.alphaBlend(
                          Colors.black54, Theme.of(context).colorScheme.error),
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      fixedSize: const Size(32, 32),
                      backgroundColor:
                          Theme.of(context).colorScheme.errorContainer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                ),
              )
            ],
          ),
        ));
  }
}
