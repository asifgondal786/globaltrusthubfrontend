import 'package:flutter/material.dart';
import 'package:global_trust_hub/services/journey_service.dart';

enum JourneyStatus {
  initial,
  loading,
  loaded,
  error,
}

class JourneyProvider extends ChangeNotifier {
  final JourneyService _journeyService = JourneyService();

  JourneyStatus _status = JourneyStatus.initial;
  String? _errorMessage;
  JourneyProgress? _journeyProgress;
  List<Map<String, dynamic>> _steps = [];
  int _currentStepIndex = 0;
  double _overallProgress = 0.0;

  // Getters
  JourneyStatus get status => _status;
  bool get isLoading => _status == JourneyStatus.loading;
  String? get errorMessage => _errorMessage;
  JourneyProgress? get journeyProgress => _journeyProgress;
  List<Map<String, dynamic>> get steps => _steps;
  int get currentStepIndex => _currentStepIndex;
  double get overallProgress => _overallProgress;

  int get completedStepsCount => _steps.where((s) => s['completed'] == true).length;
  int get totalStepsCount => _steps.length;
  
  String get journeyName => _journeyProgress?.journeyName ?? 'Your Journey';

  /// Load journey progress for current user
  Future<void> loadJourneyProgress() async {
    _status = JourneyStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _journeyService.getMyProgress();
      
      _journeyProgress = response;
      _currentStepIndex = response.currentMilestone;
      _overallProgress = response.progressPercentage / 100.0;
      
      // Convert milestones to steps format
      _steps = response.milestones.map((m) => {
        'id': m.id.toString(),
        'name': m.name,
        'description': m.description,
        'completed': m.isCompleted,
        'icon': m.icon ?? 'check_circle',
      }).toList();
      
      _status = JourneyStatus.loaded;
    } catch (e) {
      // Load mock data on error
      _loadMockJourney();
      _status = JourneyStatus.loaded;
    }
    notifyListeners();
  }

  void _loadMockJourney() {
    _steps = [
      {'id': 'step_1', 'name': 'Research & Planning', 'description': 'Research universities and programs', 'completed': true, 'icon': 'school'},
      {'id': 'step_2', 'name': 'Prepare Documents', 'description': 'Gather required documents', 'completed': true, 'icon': 'description'},
      {'id': 'step_3', 'name': 'Apply to Universities', 'description': 'Submit applications', 'completed': false, 'icon': 'send'},
      {'id': 'step_4', 'name': 'Visa Application', 'description': 'Apply for student visa', 'completed': false, 'icon': 'flight'},
      {'id': 'step_5', 'name': 'Pre-Departure', 'description': 'Prepare for your journey', 'completed': false, 'icon': 'luggage'},
      {'id': 'step_6', 'name': 'Arrival & Settlement', 'description': 'Settle in your new country', 'completed': false, 'icon': 'home'},
    ];
    
    _currentStepIndex = 2;
    _overallProgress = 0.33;
  }

  /// Mark a step as completed
  Future<void> completeStep(String stepId) async {
    final stepIndex = _steps.indexWhere((s) => s['id'] == stepId);
    if (stepIndex != -1) {
      _steps[stepIndex]['completed'] = true;
      
      // Update progress
      _overallProgress = completedStepsCount / totalStepsCount;
      
      // Move to next step if current is completed
      if (stepIndex == _currentStepIndex && _currentStepIndex < _steps.length - 1) {
        _currentStepIndex++;
      }
      
      notifyListeners();
      
      // Try to sync with backend
      try {
        final milestoneId = int.tryParse(stepId.replaceAll('step_', '')) ?? 0;
        await _journeyService.completeMilestone(milestoneId);
      } catch (_) {
        // Silent fail for offline
      }
    }
  }

  /// Get current step
  Map<String, dynamic>? get currentStep {
    if (_currentStepIndex >= 0 && _currentStepIndex < _steps.length) {
      return _steps[_currentStepIndex];
    }
    return null;
  }

  /// Get next step
  Map<String, dynamic>? get nextStep {
    if (_currentStepIndex + 1 < _steps.length) {
      return _steps[_currentStepIndex + 1];
    }
    return null;
  }

  /// Reset journey progress
  void reset() {
    _journeyProgress = null;
    _steps = [];
    _currentStepIndex = 0;
    _overallProgress = 0.0;
    _status = JourneyStatus.initial;
    notifyListeners();
  }
}
