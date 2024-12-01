import 'package:finance_tracker/components/card.dart';
import 'package:finance_tracker/components/snack_bar.dart';
import 'package:finance_tracker/layout/add_view/add_action_buttons.dart';
import 'package:finance_tracker/layout/add_view/add_todo_sub_todo.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Todo {
  Todo({this.title = '', this.value = false});
  String title;
  bool value;

  Todo copyWith({String? title, bool? value}) {
    return Todo(title: title ?? this.title, value: value ?? this.value);
  }

  setValue(bool newValue) {
    value = newValue;
  }
}

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  String whatTodo = '';
  String aboutTodo = '';
  String subTodoValue = '';
  List<Todo> subTodosValue = [];
  removeSubTodo(e) {
    setState(() {
      subTodosValue.removeWhere((v) => v.title == e.title);
      subTodos.removeWhere((v) => v.data.title == e.title);
    });
  }

  cancelSubField() {
    if (subTodoFieldList.isNotEmpty) {
      setState(() => subTodoFieldList.removeAt(0));
    }
  }

  addTodo(Todo todo) {
    setState(() {
      subTodosValue.add(todo);
      subTodos.add(AddTodoSubTodoCompleted(
        data: todo,
        onDelete: removeSubTodo,
        onChecked: (e) => setState(() => todo.setValue(!todo.value)),
      ));
      subTodoValue = '';
      cancelSubField();
    });
  }

  late Widget subField = AddTodoSubTodo(
    onChanged: (a) => setState(() => subTodoValue = a),
    onCancel: cancelSubField,
    onDone: () {
      var todo = Todo(title: subTodoValue, value: false);
      print(subTodosValue.indexWhere((v) => v.title == todo.title));
      print(subTodosValue.isEmpty);
      if (subTodosValue.indexWhere((v) => v.title == todo.title) == -1 ||
          subTodosValue.isEmpty) {
        addTodo(todo);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar(context, title: 'Sub-Todo must be unique'));
      }
    },
  );
  late List<Widget> subTodoFieldList = [];
  late List<AddTodoSubTodoCompleted> subTodos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24)
            .add(const EdgeInsets.only(top: 48, bottom: 20)),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "What To Do?",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        onChanged: (a) {
                          setState(() => whatTodo = a);
                        },
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 2)),
                            hintText: ' Enter What You Want To Do.',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About This To Do?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        cursorColor: Colors.black,
                        maxLines: 3,
                        onChanged: (a) {},
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(width: 2)),
                            hintText: ' Enter What this To Do is about.',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
              const Text(
                "Want Sub To Do?",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subTodoFieldList.isNotEmpty) subTodoFieldList[0],
                    for (var subTodo in subTodos) subTodo,
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: TextButton.icon(
                        label: const Text('Todo'),
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 12),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        icon: Icon(
                          MdiIcons.plus,
                          size: 18,
                        ),
                        onPressed: () {
                          if (subTodoFieldList.isEmpty) {
                            setState(() => subTodoFieldList.add(subField));
                          }
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AddActionButtons(
        onCancel: () {
          Navigator.of(context).pop();
        },
        onAdd: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(snack(
            context,
            content: 'Success To Do',
            label: 'Undo',
            onPressed: () {},
          ));
        },
      ),
    );
  }
}
