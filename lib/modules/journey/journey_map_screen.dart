import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/typography.dart';
import 'package:global_trust_hub/modules/journey/milestone_tracker.dart';

class JourneyMapScreen extends StatelessWidget {
  const JourneyMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Journey')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Your Path to Success',
            style: AppTypography.h5,
          ),
          SizedBox(height: 24),
          MilestoneTracker(
            title: 'Profile Creation',
            isCompleted: true,
            date: 'Jan 20',
          ),
          MilestoneTracker(
            title: 'Document Verification',
            isCompleted: true,
            date: 'Jan 22',
          ),
          MilestoneTracker(
            title: 'University Application',
            isCompleted: false,
            isActive: true,
            date: 'In Progress',
          ),
          MilestoneTracker(
            title: 'Visa Application',
            isCompleted: false,
            date: 'Upcoming',
          ),
        ],
      ),
    );
  }
}
