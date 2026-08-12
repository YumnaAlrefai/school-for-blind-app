import 'package:flutter/material.dart';
import 'app_colors.dart';

/// عنصر تبويب واحد: نص ظاهر + قيمة مرتبطة به (أي نوع T)
class TabItem<T> {
  final String label;
  final T value;

  const TabItem({required this.label, required this.value});
}

/// ============================================================
/// GenericTabs<T> — صف تبويبات عام يصلح لأي عدد ولأي نوع بيانات:
/// - 3 تبويبات في واجهة التقارير (ReportPeriod)
/// - 2 تبويبين في واجهة العلامات (مثلًا GradesPeriod أو حتى String)
///
/// الاستخدام:
///   GenericTabs<ReportPeriod>(
///     items: [
///       TabItem(label: 'اليومية', value: ReportPeriod.daily),
///       TabItem(label: 'الشهرية', value: ReportPeriod.monthly),
///       TabItem(label: 'السنوية', value: ReportPeriod.yearly),
///     ],
///     selectedValue: _selectedPeriod,
///     onChanged: (value) => setState(() => _selectedPeriod = value),
///   )
/// ============================================================
class GenericTabs<T> extends StatelessWidget {
  final List<TabItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onChanged;
  final double spacing;
  final bool expandTabs; // true = كل تبويب يتمدد ليملأ العرض بالتساوي

  const GenericTabs({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.spacing = 5,
    this.expandTabs = false, // القيمة الافتراضية: بلا تمدد (كما كانت)
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
            color: isSelected ? AppColors.accentGreen : Colors.white24,
            width: 1,
          ),
        ),
        child: Text(
          item.label,
          style: TextStyle(
            color: isSelected ? AppColors.bgDark : Colors.white70,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}