// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class FormHolder extends StatelessWidget {
  final bool selected;
  final String? title;
  final Widget? titleWidget;
  final Function() onTap;
  final List<Widget> childrens;
  const FormHolder({
    super.key,
    required this.selected,
    this.title,
    required this.onTap,
    required this.childrens,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (selected == false) {
          onTap();
        }
      },
      highlightColor: Colors.grey.withOpacity(0.2),
      splashColor: Colors.grey.withOpacity(0.4),
      borderRadius: BorderRadius.circular(0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.6),
          ),
          borderRadius: BorderRadius.circular(17), // Border radius
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      // style: Theme.of(context).primaryTextTheme.bodyLarge,
                    ),
                  if (titleWidget != null) titleWidget!,
                  GestureDetector(
                    onTap: onTap,
                    child: Icon(selected
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined),
                  ),
                ],
              ),
            ),
            ...childrens,
          ],
        ),
      ),
    );
  }
}

class ShowAddtionalDetails extends StatelessWidget {
  final bool showDetails;
  const ShowAddtionalDetails({super.key, required this.showDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [if (showDetails) ...[]],
    );
  }
}

// class FormHolder extends StatelessWidget {
//   final bool selected;
//   final String? title;
//   final Widget? titleWidget;
//   final Function() onTap;
//   final List<Widget> childrens;
//   const FormHolder({
//     super.key,
//     required this.selected,
//     this.title,
//     required this.onTap,
//     required this.childrens,
//     this.titleWidget,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       highlightColor: Colors.grey.withOpacity(0.2),
//       splashColor: Colors.grey.withOpacity(0.4),
//       borderRadius: BorderRadius.circular(0),
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.grey.withOpacity(0.6),
//           ),
//           borderRadius: BorderRadius.circular(17), // Border radius
//         ),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 if (title != null)
//                   Text(
//                     title!,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                     // style: Theme.of(context).primaryTextTheme.bodyLarge,
//                   ),
//                 if (titleWidget != null) titleWidget!,
//                 Icon(selected
//                     ? Icons.keyboard_arrow_up_outlined
//                     : Icons.keyboard_arrow_down_outlined),
//               ],
//             ),
//             ...childrens,
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ShowAddtionalDetails extends StatelessWidget {
//   final bool showDetails;
//   const ShowAddtionalDetails({super.key, required this.showDetails});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [if (showDetails) ...[]],
//     );
//   }
// }