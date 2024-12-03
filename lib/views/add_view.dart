import 'package:finance_tracker/utils/categories/bloc.dart';
import 'package:finance_tracker/views/add_view/todo.dart';
import 'package:finance_tracker/views/add_view/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  int index = 1;

  @override
  Widget build(BuildContext context) {
    List<String> labels = ['To Do', 'Transaction'];
    Size screen = MediaQuery.of(context).size;
    return BlocProvider<CategoryBloc>(
        create: (context) => context.read<CategoryBloc>(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 60),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (i) {
                    return TextButton(
                        style: TextButton.styleFrom(
                            side: index == i
                                ? BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    width: 0)
                                : const BorderSide(
                                    width: 2,
                                    color: Colors.black,
                                    strokeAlign: BorderSide.strokeAlignInside),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            fixedSize:
                                Size((screen.width - 16) / 2, double.infinity),
                            foregroundColor: Colors.black,
                            backgroundColor: index == i
                                ? Theme.of(context).colorScheme.surface
                                : const Color(0xffcccccc),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            )),
                        onPressed: () {
                          setState(() => index = i);
                        },
                        child: Text(
                          labels[i],
                          style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: index == i ? Colors.black : Colors.grey),
                        ));
                  }),
                ),
              ),
            ),
          ),
          body: const [AddTodo(), AddTransaction()][index],
        ));
  }
}
