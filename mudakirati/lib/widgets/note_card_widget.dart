import 'package:flutter/material.dart';
import '../model/custom_datetime_converter.dart';
import '../model/note.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class NoteCardWidget extends StatelessWidget {
  NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
    required this.isSelected,
  }) : super(key: key);

  final Note note;
  final int index;
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    //get date from datetime
    final time = CustomDateTimeConverter().calculateDifference(note.createdAt!);

    return Stack(
      alignment: Alignment.center,
      children: [
        Card(
          color: color.withOpacity(isSelected ? 0.7 : 1),
          child: Container(
            constraints:
                const BoxConstraints(maxHeight: 200, minWidth: double.infinity),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 04),
                Flexible(
                  child: Text(
                    note.content!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: isSelected,
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: Icon(
              Icons.check,
              color: Colors.white,
              shadows: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2,
                  offset: Offset(3, 3),
                ),
              ],
              size: 30,
            ),
          ),
        )
      ],
    );
  }
}
