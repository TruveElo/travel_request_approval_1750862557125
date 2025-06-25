import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class CostEstimatesSectionWidget extends StatelessWidget {
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onToggle;
  final double transportationCost;
  final double accommodationCost;
  final double mealsCost;
  final double otherCost;
  final double totalCost;
  final ValueChanged<double> onTransportationCostChanged;
  final ValueChanged<double> onAccommodationCostChanged;
  final ValueChanged<double> onMealsCostChanged;
  final ValueChanged<double> onOtherCostChanged;

  const CostEstimatesSectionWidget({
    super.key,
    required this.isExpanded,
    required this.isCompleted,
    required this.onToggle,
    required this.transportationCost,
    required this.accommodationCost,
    required this.mealsCost,
    required this.otherCost,
    required this.totalCost,
    required this.onTransportationCostChanged,
    required this.onAccommodationCostChanged,
    required this.onMealsCostChanged,
    required this.onOtherCostChanged,
  });

  Widget _buildCostField({
    required String label,
    required String iconName,
    required double value,
    required ValueChanged<double> onChanged,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value > 0 ? value.toStringAsFixed(2) : '',
          decoration: InputDecoration(
            hintText: hint ?? 'Enter amount',
            prefixIcon: Padding(
              padding: EdgeInsets.all(12),
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            prefixText: '\$ ',
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          onChanged: (value) {
            double parsedValue = double.tryParse(value) ?? 0.0;
            onChanged(parsedValue);
          },
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              double? parsedValue = double.tryParse(value);
              if (parsedValue == null || parsedValue < 0) {
                return 'Please enter a valid amount';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppTheme.elevationLevel1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: isCompleted ? 'check_circle' : 'radio_button_unchecked',
              color: isCompleted
                  ? AppTheme.successLight
                  : AppTheme.lightTheme.colorScheme.outline,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Cost Estimates',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (totalCost > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '\$${totalCost.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) => onToggle(),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated Costs',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),

                // Transportation Cost
                _buildCostField(
                  label: 'Transportation',
                  iconName: 'flight',
                  value: transportationCost,
                  onChanged: onTransportationCostChanged,
                  hint: 'Flights, trains, car rental...',
                ),
                SizedBox(height: 16),

                // Accommodation Cost
                _buildCostField(
                  label: 'Accommodation',
                  iconName: 'hotel',
                  value: accommodationCost,
                  onChanged: onAccommodationCostChanged,
                  hint: 'Hotels, lodging...',
                ),
                SizedBox(height: 16),

                // Meals Cost
                _buildCostField(
                  label: 'Meals & Incidentals',
                  iconName: 'restaurant',
                  value: mealsCost,
                  onChanged: onMealsCostChanged,
                  hint: 'Per diem, meals...',
                ),
                SizedBox(height: 16),

                // Other Cost
                _buildCostField(
                  label: 'Other Expenses',
                  iconName: 'receipt',
                  value: otherCost,
                  onChanged: onOtherCostChanged,
                  hint: 'Conference fees, materials...',
                ),
                SizedBox(height: 20),

                // Total Cost Summary
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Transportation',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${transportationCost.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Accommodation',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${accommodationCost.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Meals & Incidentals',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${mealsCost.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Other Expenses',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          Text(
                            '\$${otherCost.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 16,
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Estimated Cost',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          Text(
                            '\$${totalCost.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Cost Guidelines
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Cost Estimation Guidelines:',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Provide realistic estimates based on current market rates\n• Include all anticipated expenses for accurate budgeting\n• Consider seasonal pricing and booking timing\n• Receipts will be required for reimbursement',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
