import 'package:global_trust_hub/models/enums.dart';

/// Journey milestone in the user's path
class JourneyMilestone {
  final String id;
  final String title;
  final String description;
  final int order;
  final MilestoneStatus status;
  final DateTime? completedAt;
  final List<String>? tips;
  final String? countrySpecificNote;

  const JourneyMilestone({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    required this.status,
    this.completedAt,
    this.tips,
    this.countrySpecificNote,
  });

  bool get isComplete => status == MilestoneStatus.completed;
  bool get isInProgress => status == MilestoneStatus.inProgress;

  factory JourneyMilestone.fromJson(Map<String, dynamic> json) {
    return JourneyMilestone(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      order: json['order'] as int,
      status: MilestoneStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => MilestoneStatus.notStarted,
      ),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      tips: (json['tips'] as List<dynamic>?)?.map((e) => e as String).toList(),
      countrySpecificNote: json['country_specific_note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'status': status.name,
      'completed_at': completedAt?.toIso8601String(),
      'tips': tips,
      'country_specific_note': countrySpecificNote,
    };
  }
}

/// Journey template for different paths (study abroad, job search, etc.)
class Journey {
  final String id;
  final String title;
  final String description;
  final String? targetCountry;
  final List<JourneyMilestone> milestones;
  final DateTime startedAt;
  final DateTime? completedAt;

  const Journey({
    required this.id,
    required this.title,
    required this.description,
    this.targetCountry,
    required this.milestones,
    required this.startedAt,
    this.completedAt,
  });

  double get progressPercentage {
    if (milestones.isEmpty) return 0;
    final completed = milestones.where((m) => m.isComplete).length;
    return (completed / milestones.length) * 100;
  }

  JourneyMilestone? get currentMilestone {
    return milestones.firstWhere(
      (m) => m.status == MilestoneStatus.inProgress,
      orElse: () => milestones.firstWhere(
        (m) => m.status == MilestoneStatus.notStarted,
        orElse: () => milestones.last,
      ),
    );
  }

  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetCountry: json['target_country'] as String?,
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => JourneyMilestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_country': targetCountry,
      'milestones': milestones.map((m) => m.toJson()).toList(),
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

/// Pre-defined journey templates
class JourneyTemplates {
  static Journey studyAbroadTemplate(String country) {
    return Journey(
      id: 'study-abroad-$country',
      title: 'Study in $country',
      description: 'Your complete guide to studying in $country',
      targetCountry: country,
      milestones: [
        const JourneyMilestone(
          id: 'research',
          title: 'Application', // Matches screenshot "Application"
          description: 'Research universities, programs, and requirements',
          order: 1,
          status: MilestoneStatus.completed,
          tips: [
            'Check university rankings',
            'Compare tuition fees',
            'Review admission requirements',
          ],
        ),
        const JourneyMilestone(
          id: 'test-prep',
          title: 'Visa Approved', // Matches screenshot
          description: 'Prepare for IELTS/TOEFL and other required tests',
          order: 2,
          status: MilestoneStatus.completed,
          tips: [
            'Book test dates early',
            'Practice with official materials',
            'Aim for scores above minimum requirements',
          ],
        ),
        const JourneyMilestone(
          id: 'application',
          title: 'Travel', // Matches screenshot
          description: 'Apply to your chosen universities',
          order: 3,
          status: MilestoneStatus.completed,
          tips: [
            'Submit before deadlines',
            'Have documents verified',
            'Write compelling personal statements',
          ],
        ),
        const JourneyMilestone(
          id: 'admission',
          title: 'Accommodation', // Matches screenshot
          description: 'Receive and accept admission offers',
          order: 4,
          status: MilestoneStatus.inProgress, 
        ),
        const JourneyMilestone(
          id: 'visa',
          title: 'Job Secured', // Matches screenshot
          description: 'Apply for student visa',
          order: 5,
          status: MilestoneStatus.notStarted,
          tips: [
            'Gather all required documents',
            'Show proof of funds',
            'Book biometrics appointment',
          ],
        ),
        const JourneyMilestone(
          id: 'travel',
          title: 'Departure',
          description: 'Book flights and prepare for departure',
          order: 6,
          status: MilestoneStatus.notStarted,
        ),
        const JourneyMilestone(
          id: 'arrival',
          title: 'Arrival',
          description: 'Arrive and settle into your new home',
          order: 7,
          status: MilestoneStatus.notStarted,
        ),
      ],
      startedAt: DateTime.now(),
    );
  }
}
