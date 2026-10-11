
import 'package:flutter/material.dart';
import 'package:tikdone_app/core/values/strings.dart';

class NoTodoHere extends StatelessWidget {
  const NoTodoHere({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            PersianStrings.noTaskHere,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      );
  }
}