import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    Key? key,
    required this.onChange,
    required this.optionsSet,
    required this.optionsMap,
    required this.title,
  }) : super(key: key);

  final Function(String?, bool) onChange;
  final List<String?> optionsSet;
  final Map<String?, bool> optionsMap;
  final String title;

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 24),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < widget.optionsMap.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 8.0),
                      child: FilterChip(
                        onSelected: (value) {
                          widget.onChange(widget.optionsSet[i], value);
                          setState(() {
                            widget.optionsMap[widget.optionsSet[i]] = value;
                          });
                        },
                        selected:
                            widget.optionsMap[widget.optionsSet[i]] ?? false,
                        label: Text(
                          widget.optionsSet[i] ?? "Não especificado",
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
