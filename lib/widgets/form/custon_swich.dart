import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Function(bool value) onChanged;
  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: 50,
        height: 35,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                width: 50,
                height: 25,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  color: value ? Colors.lightGreen : Colors.grey,
                ),
              ),
            ),
            AnimatedPositioned(
              left: value ? 18 : 0,
              duration: const Duration(milliseconds: 100),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: value ? Colors.pink : Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
