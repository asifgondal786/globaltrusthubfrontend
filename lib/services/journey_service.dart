/// Journey API Service
/// Handles user journey progress tracking API calls
library journey_service;

import 'package:global_trust_hub/core/api/api_client.dart';
import 'package:global_trust_hub/core/api/api_config.dart';

class JourneyService {
  final ApiClient _api = ApiClient();

  /// Get user's current journey progress
  Future<JourneyProgress> getMyProgress() async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.journeyProgress,
    );
    return JourneyProgress.fromJson(response);
  }

  /// Get available journey templates
  Future<List<JourneyTemplate>> getTemplates() async {
    final response = await _api.get<Map<String, dynamic>>(
      ApiConfig.journeys,
    );
    final templates = response['journeys'] as List? ?? [];
    return templates.map((t) => JourneyTemplate.fromJson(t)).toList();
  }

  /// Mark milestone as complete
  Future<void> completeMilestone(int milestoneId) async {
    await _api.post(
      '${ApiConfig.journeys}/milestones/$milestoneId/complete',
    );
  }
}

// Response Models

class JourneyProgress {
  final String journeyId;
  final String journeyName;
  final int currentMilestone;
  final List<JourneyMilestone> milestones;
  final int progressPercentage;
  final NextAction? nextAction;

  JourneyProgress({
    required this.journeyId,
    required this.journeyName,
    required this.currentMilestone,
    required this.milestones,
    required this.progressPercentage,
    this.nextAction,
  });

  factory JourneyProgress.fromJson(Map<String, dynamic> json) {
    return JourneyProgress(
      journeyId: json['journey_id'] ?? '',
      journeyName: json['journey_name'] ?? '',
      currentMilestone: json['current_milestone'] ?? 0,
      milestones: (json['milestones'] as List? ?? [])
          .map((m) => JourneyMilestone.fromJson(m))
          .toList(),
      progressPercentage: json['progress_percentage'] ?? 0,
      nextAction: json['next_action'] != null
          ? NextAction.fromJson(json['next_action'])
          : null,
    );
  }
}

class JourneyMilestone {
  final int id;
  final String name;
  final String description;
  final String status; // completed, in_progress, pending
  final String? completedAt;
  final String? icon;

  JourneyMilestone({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    this.completedAt,
    this.icon,
  });

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';

  factory JourneyMilestone.fromJson(Map<String, dynamic> json) {
    return JourneyMilestone(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      completedAt: json['completed_at'],
      icon: json['icon'],
    );
  }
}

class NextAction {
  final String title;
  final String description;
  final String actionUrl;

  NextAction({
    required this.title,
    required this.description,
    required this.actionUrl,
  });

  factory NextAction.fromJson(Map<String, dynamic> json) {
    return NextAction(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      actionUrl: json['action_url'] ?? '',
    );
  }
}

class JourneyTemplate {
  final String id;
  final String name;
  final String description;
  final int milestonesCount;

  JourneyTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.milestonesCount,
  });

  factory JourneyTemplate.fromJson(Map<String, dynamic> json) {
    return JourneyTemplate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      milestonesCount: json['milestones_count'] ?? 0,
    );
  }
}
