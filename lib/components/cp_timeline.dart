import 'package:ev_homes/components/event_card.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimelineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final eventCard;

  const MyTimelineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.eventCard,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
          color: isPast ? const Color(0xFFFFB22C) : const Color(0xFFFFB22C)),
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: isPast
            ? const Color.fromARGB(255, 133, 0, 0)
            : const Color(0xFFFFB22C),
        iconStyle: IconStyle(
          iconData: Icons.done,
          color: isPast ? Colors.white : const Color(0xFFFFB22C),
        ),
      ),
      endChild: EventCard(
        isPast: isPast,
        child: eventCard,
      ),
    );
  }
}
