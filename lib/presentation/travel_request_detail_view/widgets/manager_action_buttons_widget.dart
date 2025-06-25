import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class ManagerActionButtonsWidget extends StatelessWidget {
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  const ManagerActionButtonsWidget({
    super.key,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onDeny,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.rejectedColor,
                  size: 20,
                ),
                label: Text(
                  'Deny',
                  style: TextStyle(
                    color: AppTheme.rejectedColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: AppTheme.rejectedColor,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onApprove,
                icon: CustomIconWidget(
                  iconName: 'check',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Approve',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.approvedColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
