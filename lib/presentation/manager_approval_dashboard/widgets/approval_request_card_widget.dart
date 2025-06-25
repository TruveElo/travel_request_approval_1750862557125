import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class ApprovalRequestCardWidget extends StatelessWidget {
  final Map<String, dynamic> request;
  final bool isMultiSelectMode;
  final bool isSelected;
  final VoidCallback onApprove;
  final VoidCallback onDeny;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onToggleSelection;

  const ApprovalRequestCardWidget({
    super.key,
    required this.request,
    required this.isMultiSelectMode,
    required this.isSelected,
    required this.onApprove,
    required this.onDeny,
    required this.onTap,
    required this.onLongPress,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUrgent = request['isUrgent'] ?? false;
    final DateTime departureDate = request['departureDate'];
    final String formattedDate =
        '${departureDate.day}/${departureDate.month}/${departureDate.year}';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(request['id']),
        background: _buildSwipeBackground(true),
        secondaryBackground: _buildSwipeBackground(false),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Swipe right - Approve
            HapticFeedback.lightImpact();
            onApprove();
            return false; // Don't dismiss the card
          } else {
            // Swipe left - Show deny options
            HapticFeedback.lightImpact();
            _showDenyOptions(context);
            return false; // Don't dismiss the card
          }
        },
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Card(
            elevation:
                isUrgent ? AppTheme.elevationLevel2 : AppTheme.elevationLevel1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              side: isUrgent
                  ? BorderSide(color: AppTheme.warningLight, width: 2)
                  : BorderSide.none,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.cardColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row with photo, name, and selection checkbox
                    Row(
                      children: [
                        if (isMultiSelectMode)
                          Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: onToggleSelection,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.outline,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? CustomIconWidget(
                                        iconName: 'check',
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        // Requestor photo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CustomImageWidget(
                            imageUrl: request['requestorPhoto'],
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        // Name and department
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request['requestorName'],
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                request['department'],
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Urgent badge
                        if (isUrgent)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.warningLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'URGENT',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Trip summary
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'flight_takeoff',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${request['tripSummary']} - ${request['tripName']}',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Departure date and cost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              formattedDate,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'attach_money',
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              size: 16,
                            ),
                            Text(
                              request['estimatedCost'],
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Business justification preview
                    Text(
                      request['businessJustification'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (!isMultiSelectMode) ...[
                      SizedBox(height: 16),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _showDenyOptions(context),
                              icon: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme.errorLight,
                                size: 16,
                              ),
                              label: Text(
                                'Deny',
                                style: TextStyle(color: AppTheme.errorLight),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppTheme.errorLight),
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onApprove,
                              icon: CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              ),
                              label: Text('Approve'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.approvedColor,
                                padding: EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(bool isApprove) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isApprove ? AppTheme.approvedColor : AppTheme.errorLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      alignment: isApprove ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isApprove ? 'check_circle' : 'cancel',
            color: Colors.white,
            size: 32,
          ),
          SizedBox(height: 4),
          Text(
            isApprove ? 'Approve' : 'Deny',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showDenyOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Deny Request',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Choose an action for ${request['requestorName']}\'s travel request',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onDeny();
              },
              icon: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 20,
              ),
              label: Text('Deny Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorLight,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showRequestMoreInfoDialog(context);
              },
              icon: CustomIconWidget(
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              label: Text('Request More Info'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestMoreInfoDialog(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request More Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a message to ${request['requestorName']} requesting additional information:',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Please provide more details about...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Information request sent to ${request['requestorName']}'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                ),
              );
            },
            child: Text('Send Request'),
          ),
        ],
      ),
    );
  }
}
