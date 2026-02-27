import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../shared/providers/api_client.dart';

enum TimerStatus { idle, running, paused, completed }

class TimerState {
  final TimerStatus status;
  final Duration remaining;
  final Duration totalDuration;
  final DateTime? startedAt;

  TimerState({
    required this.status,
    required this.remaining,
    required this.totalDuration,
    this.startedAt,
  });

  factory TimerState.initial() {
    return TimerState(
      status: TimerStatus.idle,
      remaining: const Duration(minutes: 25),
      totalDuration: const Duration(minutes: 25),
    );
  }

  TimerState copyWith({
    TimerStatus? status,
    Duration? remaining,
    Duration? totalDuration,
    DateTime? startedAt,
  }) {
    return TimerState(
      status: status ?? this.status,
      remaining: remaining ?? this.remaining,
      totalDuration: totalDuration ?? this.totalDuration,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

class PomodoroTimerNotifier extends Notifier<TimerState> {
  Timer? _ticker;

  @override
  TimerState build() {
    ref.onDispose(() {
      _ticker?.cancel();
      WakelockPlus.disable();
    });
    return TimerState.initial();
  }

  void start() {
    WakelockPlus.enable();
    state = state.copyWith(
      status: TimerStatus.running,
      startedAt: DateTime.now(),
    );
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  void _tick() {
    if (state.startedAt == null) return;

    final elapsed = DateTime.now().difference(state.startedAt!);
    final remaining = state.totalDuration - elapsed;

    if (remaining <= Duration.zero) {
      _onComplete();
    } else {
      state = state.copyWith(remaining: remaining);
    }
  }

  void pause() {
    _ticker?.cancel();
    WakelockPlus.disable();
    state = state.copyWith(
      status: TimerStatus.paused,
      totalDuration: state.remaining,
      startedAt: null,
    );
  }

  void reset() {
    _ticker?.cancel();
    WakelockPlus.disable();
    state = TimerState.initial();
  }

  Future<void> _onComplete() async {
    _ticker?.cancel();
    WakelockPlus.disable();
    state = state.copyWith(
      status: TimerStatus.completed,
      remaining: Duration.zero,
    );

    try {
      final dio = ref.read(dioProvider);
      await dio.post(
        '/sessions/',
        data: {
          'duration_seconds': state.totalDuration.inSeconds,
          'started_at':
              state.startedAt?.toUtc().toIso8601String() ??
              DateTime.now().toUtc().toIso8601String(),
          'ended_at': DateTime.now().toUtc().toIso8601String(),
          'session_type': 'work',
        },
      );
    } catch (e) {
      // Ignored
    }
  }
}

final timerProvider = NotifierProvider<PomodoroTimerNotifier, TimerState>(() {
  return PomodoroTimerNotifier();
});
