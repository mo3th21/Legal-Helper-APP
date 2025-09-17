// contract_filter_dropdown.dart
import 'package:flutter/material.dart';
import 'package:qanon/models/contract_type.dart';
import 'package:qanon/theme/app_theme.dart';

class ContractFilterDropdown extends StatelessWidget {
  final ContractType? selectedType;
  final ValueChanged<ContractType?> onChanged;

  const ContractFilterDropdown({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => _showFilterBottomSheet(context),
        child: _buildFilterButton(),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة الفلتر
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              selectedType != null 
                ? _getContractIcon(selectedType!)
                : Icons.filter_list_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // النص
          Expanded(
            child: Text(
              selectedType?.arabicName ?? 'جميع أنواع العقود',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          
          // أيقونة السهم
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6, // أقصى ارتفاع 60%
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // مؤشر السحب
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // العنوان
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'اختر نوع العقد',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),

            // الفاصل
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: AppColors.divider,
            ),

            // قائمة الخيارات
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // خيار "جميع العقود"
                  _buildBottomSheetItem(
                    context: context,
                    icon: Icons.select_all_rounded,
                    label: 'جميع أنواع العقود',
                    isSelected: selectedType == null,
                    onTap: () {
                      Navigator.pop(context);
                      onChanged(null);
                    },
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // باقي الخيارات
                  ...ContractType.values.map((type) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildBottomSheetItem(
                      context: context,
                      icon: _getContractIcon(type),
                      label: type.arabicName,
                      isSelected: selectedType == type,
                      onTap: () {
                        Navigator.pop(context);
                        onChanged(type);
                      },
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getContractIcon(ContractType type) {
    switch (type) {
      case ContractType.rental:
        return Icons.home_work_rounded;
      case ContractType.sale:
        return Icons.shopping_cart_rounded;
      case ContractType.services:
        return Icons.handshake_rounded;
      case ContractType.employment:
        return Icons.work_rounded;
      default:
        return Icons.description_outlined;
    }
  }

  Widget _buildBottomSheetItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.3) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // أيقونة النوع
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? AppColors.primary 
                    : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                    ? AppColors.surface 
                    : AppColors.primary,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // النص
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textDark,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              
              // علامة الاختيار
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: AppColors.surface,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}