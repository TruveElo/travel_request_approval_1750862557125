import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import './widgets/attendees_card_widget.dart';
import './widgets/business_justification_card_widget.dart';
import './widgets/cost_breakdown_card_widget.dart';
import './widgets/manager_action_buttons_widget.dart';
import './widgets/request_header_card_widget.dart';
import './widgets/timeline_card_widget.dart';

class TravelRequestDetailView extends StatefulWidget {
  const TravelRequestDetailView({super.key});

  @override
  State<TravelRequestDetailView> createState() =>
      _TravelRequestDetailViewState();
}

class _TravelRequestDetailViewState extends State<TravelRequestDetailView> {
  final TextEditingController _managerCommentController =
      TextEditingController();
  final bool _isManager =
      true; // Mock user role - in real app this would come from auth

  // Mock travel request data
  final Map<String, dynamic> travelRequestData = {
    "id": "TR-2024-001",
    "tripName": "Q4 Client Meeting",
    "origin": "New York",
    "destination": "San Francisco",
    "departureDate": "2024-02-15T09:00:00Z",
    "returnDate": "2024-02-17T18:00:00Z",
    "status": "Pending",
    "totalCost": 2850.00,
    "submittedDate": "2024-01-28T14:30:00Z",
    "submittedBy": "John Smith",
    "submittedByEmail": "john.smith@company.com",
    "manager": "Sarah Johnson",
    "businessJustification":
        """This trip is essential for finalizing the Q4 partnership agreement with TechCorp Inc. The meeting will cover contract negotiations, technical integration discussions, and strategic planning for 2024. Our presence is mandatory as we are the lead technical team responsible for the implementation. The client specifically requested an in-person meeting to address security concerns and demonstrate our platform capabilities. This deal represents 30% of our Q4 revenue target and requires executive-level engagement to close successfully.""",
    "expectedOutcomes":
        "Signed partnership agreement, technical requirements finalization, Q1 2024 project timeline confirmation",
    "attendees": [
      {
        "name": "John Smith",
        "role": "Technical Lead",
        "email": "john.smith@company.com"
      },
      {
        "name": "Mike Davis",
        "role": "Sales Director",
        "email": "mike.davis@company.com"
      },
      {
        "name": "Lisa Chen",
        "role": "Product Manager",
        "email": "lisa.chen@company.com"
      }
    ],
    "costBreakdown": {
      "transportation": 1200.00,
      "accommodation": 900.00,
      "meals": 450.00,
      "other": 300.00
    },
    "timeline": [
      {
        "date": "2024-01-28T14:30:00Z",
        "status": "Submitted",
        "comment": "Travel request submitted for approval",
        "actor": "John Smith"
      },
      {
        "date": "2024-01-28T15:45:00Z",
        "status": "Under Review",
        "comment": "Request forwarded to manager for approval",
        "actor": "System"
      }
    ],
    "managerComments": ""
  };

  @override
  void dispose() {
    _managerCommentController.dispose();
    super.dispose();
  }

  void _shareRequest() {
    HapticFeedback.lightImpact();
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request details shared successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _approveRequest() {
    HapticFeedback.mediumImpact();
    _showActionDialog(
      title: 'Approve Request',
      content: 'Are you sure you want to approve this travel request?',
      confirmText: 'Approve',
      confirmColor: AppTheme.approvedColor,
      onConfirm: () {
        setState(() {
          travelRequestData['status'] = 'Approved';
          (travelRequestData['timeline'] as List).add({
            "date": DateTime.now().toIso8601String(),
            "status": "Approved",
            "comment": _managerCommentController.text.isNotEmpty
                ? _managerCommentController.text
                : "Request approved",
            "actor": travelRequestData['manager']
          });
        });
        _managerCommentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Travel request approved successfully'),
            backgroundColor: AppTheme.approvedColor,
          ),
        );
      },
    );
  }

  void _denyRequest() {
    HapticFeedback.mediumImpact();
    _showActionDialog(
      title: 'Deny Request',
      content: 'Are you sure you want to deny this travel request?',
      confirmText: 'Deny',
      confirmColor: AppTheme.rejectedColor,
      onConfirm: () {
        if (_managerCommentController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please provide a reason for denial'),
              backgroundColor: AppTheme.rejectedColor,
            ),
          );
          return;
        }
        setState(() {
          travelRequestData['status'] = 'Denied';
          (travelRequestData['timeline'] as List).add({
            "date": DateTime.now().toIso8601String(),
            "status": "Denied",
            "comment": _managerCommentController.text,
            "actor": travelRequestData['manager']
          });
        });
        _managerCommentController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Travel request denied'),
            backgroundColor: AppTheme.rejectedColor,
          ),
        );
      },
    );
  }

  void _showActionDialog({
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String status = travelRequestData['status'] as String;
    final bool isPending = status.toLowerCase() == 'pending';
    final bool showManagerActions = _isManager && isPending;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Request Details'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareRequest,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RequestHeaderCardWidget(
                    requestData: travelRequestData,
                  ),
                  SizedBox(height: 16),
                  BusinessJustificationCardWidget(
                    justification:
                        travelRequestData['businessJustification'] as String,
                    expectedOutcomes:
                        travelRequestData['expectedOutcomes'] as String,
                  ),
                  SizedBox(height: 16),
                  AttendeesCardWidget(
                    attendees: travelRequestData['attendees']
                        as List<Map<String, dynamic>>,
                  ),
                  SizedBox(height: 16),
                  CostBreakdownCardWidget(
                    costBreakdown: travelRequestData['costBreakdown']
                        as Map<String, dynamic>,
                    totalCost: travelRequestData['totalCost'] as double,
                  ),
                  SizedBox(height: 16),
                  TimelineCardWidget(
                    timeline: travelRequestData['timeline']
                        as List<Map<String, dynamic>>,
                  ),
                  if (showManagerActions) ...[
                    SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manager Comments',
                              style: AppTheme.lightTheme.textTheme.titleMedium,
                            ),
                            SizedBox(height: 12),
                            TextField(
                              controller: _managerCommentController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText:
                                    'Add your comments (optional for approval, required for denial)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: showManagerActions ? 100 : 24),
                ],
              ),
            ),
          ),
          if (showManagerActions)
            ManagerActionButtonsWidget(
              onApprove: _approveRequest,
              onDeny: _denyRequest,
            ),
        ],
      ),
    );
  }
}
