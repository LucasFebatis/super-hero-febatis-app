import 'package:flutter/material.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet(
      {Key? key,
      required this.onChange,
      required this.genderMap,
      required this.genderSet,
      required this.alignmentMap,
      required this.alignmentSet})
      : super(key: key);

  final Function(String?, bool) onChange;
  final Map<String?, bool> genderMap;
  final List<String?> genderSet;
  final Map<String?, bool> alignmentMap;
  final List<String?> alignmentSet;

  @override
  _SortBottomSheetState createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Gender",
              style: TextStyle(fontSize: 24),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < widget.genderMap.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 8.0),
                      child: FilterChip(
                        onSelected: (value) {
                          widget.onChange(widget.genderSet[i], value);
                          setState(() {
                            widget.genderMap[widget.genderSet[i]] = value;
                          });
                        },
                        selected:
                            widget.genderMap[widget.genderSet[i]] ?? false,
                        label: Text(
                          widget.genderSet[i] ?? "Não especificado",
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
              "Alignment",
              style: TextStyle(fontSize: 24),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < widget.alignmentMap.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 8.0),
                      child: FilterChip(
                        onSelected: (value) {
                          widget.onChange(widget.alignmentSet[i], value);
                          setState(() {
                            widget.alignmentMap[widget.alignmentSet[i]] = value;
                          });
                        },
                        selected: widget.alignmentMap[widget.alignmentSet[i]] ??
                            false,
                        label: Text(
                          widget.alignmentSet[i] ?? "Não especificado",
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
