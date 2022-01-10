import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:switchsoulmonarch/database/apps_provider.dart';

part 'mode_state.freezed.dart';

@freezed
abstract class ModeState with _$ModeState {
  factory ModeState({
    @Default("preference") String mode,
    @Default(true) bool canHide,
  }) = _ModeState;
}

class ModeStateNotifier extends StateNotifier<ModeState> {
  ModeStateNotifier() : super(ModeState());

  final appsProvider = AppsProvider();

  String get mode => state.mode;

  bool get canHide => state.canHide;

  void setMode(String mode) {
    state = state.copyWith(mode: mode);
  }

  void setCanHide(bool canHide) {
    state = state.copyWith(canHide: canHide);
  }
}

final modeStateNotifier = StateNotifierProvider<ModeStateNotifier, ModeState>(
    (ref) => ModeStateNotifier());
