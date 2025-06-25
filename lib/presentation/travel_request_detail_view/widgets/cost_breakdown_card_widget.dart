import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class CostBreakdownCardWidget extends StatelessWidget {
  final Map<String, dynamic> costBreakdown;
  final double totalCost;

  const CostBreakdownCardWidget({
    super.key,
    required this.costBreakdown,
    required this.totalCost,
  });

  void _showCostDetails(BuildContext context, String category, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${category.toUpperCase()} Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estimated Cost: \$${amount.toStringAsFixed(2)}',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              SizedBox(height: 12),
              Text(
                _getCategoryDescription(category),
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  String _getCategoryDescription(String category) {
    switch (category.toLowerCase()) {
      case 'transportation':
        return 'Includes flights, airport transfers, local transportation, and parking fees.';
      case 'accommodation':
        return 'Hotel booking for the duration of the trip including taxes and fees.';
      case 'meals':
        return 'Daily meal allowance covering breakfast, lunch, dinner, and incidentals.';
      case 'other':
        return 'Miscellaneous expenses including conference fees, materials, and other business-related costs.';
      default:
        return 'Additional expenses related to the business trip.';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'transportation':
        return Icons.flight;
      case 'accommodation':
        return Icons.hotel;
      case 'meals':
        return Icons.restaurant;
      case 'other':
        return Icons.more_horiz;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationLevel1,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'account_balance_wallet',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Cost Breakdown',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: costBreakdown.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = costBreakdown.entries.elementAt(index);
                final String category = entry.key;
                final double amount = entry.value as double;
                final double percentage = (amount / totalCost) * 100;

                return GestureDetector(
                  onLongPress: () =>
                      _showCostDetails(context, category, amount),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: _getCategoryIcon(category)
                                    .codePoint
                                    .toString(),
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.replaceAll('_', ' ').toUpperCase(),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '${percentage.toStringAsFixed(1)}% of total',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '\$${amount.toStringAsFixed(2)}',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.outline
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                          minHeight: 4,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calculate',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Total Estimated Cost',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '\$${totalCost.toStringAsFixed(2)}',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
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
