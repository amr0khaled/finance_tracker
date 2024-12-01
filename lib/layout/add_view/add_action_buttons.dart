import 'package:finance_tracker/components/snack_bar.dart';
import 'package:flutter/material.dart';

class AddActionButtons extends StatelessWidget {
  const AddActionButtons(
      {super.key, required this.onCancel, required this.onAdd});
  final VoidCallback onCancel;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      height: 80,
      child: Container(
        constraints: const BoxConstraints(maxWidth: (167 * 2) + 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(2, (i) {
            var labels = ['Cancel', "Add"];
            return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(167, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    backgroundColor: i == 0
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                    foregroundColor: i == 0
                        ? Theme.of(context).colorScheme.onErrorContainer
                        : Theme.of(context).colorScheme.primaryContainer),
                onPressed: i == 0 ? onCancel : onAdd,
                child: Text(
                  labels[i],
                  style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600),
                ));
          }),
        ),
      ),
    );
  }
}
