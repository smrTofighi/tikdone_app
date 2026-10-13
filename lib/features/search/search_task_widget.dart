import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../../core/values/dimens.dart';

class SearchTaskWidget extends StatelessWidget {
  const SearchTaskWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        width: AppDimens.infinity,
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    FluentIcons.vehicle_car_24_regular,
                    size: 26,
                    color: Colors.red,
                  ),
                  const Text(
                    'خودرو',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              const VerticalDivider(
                color: Colors.red,
                thickness: 2,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'تعمیر ماشین',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  Row(
                    children: [
                      Icon(
                        FluentIcons.calendar_16_regular,
                        size: 14,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      const Text(
                        '1401/01/01',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      const SizedBox(
                        width: 24.0,
                      ),
                      Icon(
                        FluentIcons.clock_16_regular,
                        size: 14,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      const Text(
                        '10:30',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
