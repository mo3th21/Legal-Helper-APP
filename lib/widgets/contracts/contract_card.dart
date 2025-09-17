// contract_card.dart
import 'package:flutter/material.dart';
import 'package:qanon/models/contract_type.dart';
import 'package:qanon/models/legal_contract.dart';
import 'package:qanon/theme/app_theme.dart';

class ContractCard extends StatelessWidget {
  final LegalContract contract;
  final void Function(String?) onViewPressed;
  final void Function(String?) onDownloadPressed;

  const ContractCard({
    super.key,
    required this.contract,
    required this.onViewPressed,
    required this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.2),
            offset: const Offset(0, 10),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(textTheme),
          _buildBody(textTheme),
        ],
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeChip(textTheme),
          const SizedBox(height: 8),
          Text(
            contract.fileName,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(TextTheme textTheme) {
    return Transform.translate(
      offset: const Offset(-8, -8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                _getContractIcon(contract.contractType),
                color: AppColors.surface,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              contract.contractType.arabicName,
              style: textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
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

  Widget _buildBody(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (contract.description?.isNotEmpty ?? false) ...[
            Text(
              contract.description!,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color.fromARGB(255, 3, 3, 3),
                height: 1.6,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
          ],
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => onViewPressed(contract.downloadUrl),
        icon: const Icon(Icons.open_in_new),
        label: const Text('تحميل وعرض الملف'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}