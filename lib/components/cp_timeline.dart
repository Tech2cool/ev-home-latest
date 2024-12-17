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
          color: isPast
              ? Color.fromARGB(146, 134, 185, 176)
              : Color.fromARGB(146, 134, 185, 176)),
      indicatorStyle: IndicatorStyle(
        width: 30,
        color: isPast ? Color(0xFF042630) : Color.fromARGB(146, 134, 185, 176),
        iconStyle: IconStyle(
          iconData: Icons.done,
          color: isPast ? Colors.white : Color.fromARGB(146, 134, 185, 176),
        ),
      ),
      endChild: EventCard(
        isPast: isPast,
        child: eventCard,
      ),
    );
  }
}
