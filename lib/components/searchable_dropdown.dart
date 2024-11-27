import 'package:flutter/material.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? initialSelection;
  final String Function(T)
      labelBuilder; // Function to build label from the model
  final Function(T?) onChanged;
  final String? label;

  const SearchableDropdown({
    super.key,
    required this.items,
    this.initialSelection,
    required this.onChanged,
    required this.labelBuilder,
    this.label,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate<T>(
            items: widget.items,
            labelBuilder: widget.labelBuilder,
            onItemSelected: (selectedItem) {
              setState(() {
                _selectedValue = selectedItem;
              });
              widget.onChanged(selectedItem);
            },
          ),
        );
      },
      child: AbsorbPointer(
        child: DropdownButtonFormField<T>(
          isExpanded: true,
          value: widget.items.contains(_selectedValue) ? _selectedValue : null,
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: widget.label ?? 'Select an option',
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.3),
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
            widget.onChanged(value);
          },
          items: widget.items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                widget.labelBuilder(item),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Custom Search Delegate remains the same

// class SearchableDropdown<T> extends StatefulWidget {
//   final List<T> items;
//   final T? initialSelection;
//   final String Function(T)
//       labelBuilder; // Function to build label from the model
//   final Function(T?) onChanged;
//   final String? label;

//   const SearchableDropdown({
//     super.key,
//     required this.items,
//     this.initialSelection,
//     required this.onChanged,
//     required this.labelBuilder, // Label builder for dynamic models
//     this.label,
//   });

//   @override
//   State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
// }

// class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
//   T? _selectedValue;

//   @override
//   void initState() {
//     super.initState();
//     _selectedValue = widget.initialSelection;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         showSearch(
//           context: context,
//           delegate: CustomSearchDelegate<T>(
//             items: widget.items,
//             labelBuilder: widget.labelBuilder,
//             onItemSelected: (selectedItem) {
//               setState(() {
//                 _selectedValue = selectedItem;
//               });
//               widget.onChanged(selectedItem);
//             },
//           ),
//         );
//       },
//       child: AbsorbPointer(
//         child: DropdownButtonFormField<T>(
//           value: widget.items.contains(_selectedValue) ? _selectedValue : null,
//           style: TextStyle(
//             color: Colors.black.withOpacity(0.8),
//             fontSize: 16,
//           ),
//           decoration: InputDecoration(
//             labelText: widget.label ?? 'Select an option',
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: Colors.grey.withOpacity(0.5),
//               ),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(
//                 color: Colors.grey.withOpacity(0.3),
//               ),
//             ),
//           ),
//           onChanged: (value) {
//             setState(() {
//               _selectedValue = value;
//             });
//             widget.onChanged(value);
//           },
//           items: widget.items.map((item) {
//             return DropdownMenuItem<T>(
//               value: item,
//               child: Text(widget.labelBuilder(item)),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }

class CustomSearchDelegate<T> extends SearchDelegate<T?> {
  final List<T> items;
  final String Function(T) labelBuilder;
  final Function(T?) onItemSelected;

  CustomSearchDelegate({
    required this.items,
    required this.labelBuilder,
    required this.onItemSelected,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Allow null since T is nullable (T?)
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = items.where((item) {
      final label = labelBuilder(item).toLowerCase();
      final matches = label.contains(query.toLowerCase());
      return matches;
    }).toList();
    return ListView(
      children: results.map((result) {
        return ListTile(
          title: Text(labelBuilder(result)),
          onTap: () {
            onItemSelected(result);
            close(context, result); // Return the selected result
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This can be used to provide suggestions as you type
    return buildResults(context);
  }
}
