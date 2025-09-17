// empty_contracts_view.dart
import 'package:flutter/material.dart';
import 'package:qanon/models/contract_type.dart';
import 'package:qanon/theme/app_theme.dart';

class EmptyContractsView extends StatelessWidget {
  final ContractType? selectedType;

  const EmptyContractsView({
    super.key,
    this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: AppColors.secondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Text(
              selectedType == null
                  ? 'لا توجد عقود متوفرة حالياً'
                  : 'لا توجد عقود من نوع ${selectedType!.arabicName}',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}