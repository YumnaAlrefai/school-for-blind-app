import 'package:flutter/material.dart';
import 'app_colors.dart';

class TabItem<T> {
  final String label;
  final T value;

  const TabItem({required this.label, required this.value});
}

class GenericTabs<T> extends StatelessWidget {
  final List<TabItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final double spacing;
  final bool expandTabs; 

  const GenericTabs({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.spacing = 5,
    this.expandTabs = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.rtl,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          expandTabs ? Expanded(child: _chip(items[i])) : _chip(items[i]),
          if (i != items.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }

  Widget _chip(TabItem<T> item) {
    final bool isSelected = item.value == selectedValue;
    return GestureDetector(
      onTap: () => onChanged(item.value),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 33, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accentGreen : AppColors.overlay24,
            width: 1,
          ),
        ),
        child: Text(
          item.label,
          style: TextStyle(
            color: isSelected ? AppColors.bgDark : AppColors.overlay70,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}