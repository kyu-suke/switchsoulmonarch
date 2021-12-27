// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'mode_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ModeStateTearOff {
  const _$ModeStateTearOff();

  _ModeState call({String mode = "preference", bool canHide = false}) {
    return _ModeState(
      mode: mode,
      canHide: canHide,
    );
  }
}

/// @nodoc
const $ModeState = _$ModeStateTearOff();

/// @nodoc
mixin _$ModeState {
  String get mode => throw _privateConstructorUsedError;
  bool get canHide => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ModeStateCopyWith<ModeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModeStateCopyWith<$Res> {
  factory $ModeStateCopyWith(ModeState value, $Res Function(ModeState) then) =
      _$ModeStateCopyWithImpl<$Res>;
  $Res call({String mode, bool canHide});
}

/// @nodoc
class _$ModeStateCopyWithImpl<$Res> implements $ModeStateCopyWith<$Res> {
  _$ModeStateCopyWithImpl(this._value, this._then);

  final ModeState _value;
  // ignore: unused_field
  final $Res Function(ModeState) _then;

  @override
  $Res call({
    Object? mode = freezed,
    Object? canHide = freezed,
  }) {
    return _then(_value.copyWith(
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      canHide: canHide == freezed
          ? _value.canHide
          : canHide // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$ModeStateCopyWith<$Res> implements $ModeStateCopyWith<$Res> {
  factory _$ModeStateCopyWith(
          _ModeState value, $Res Function(_ModeState) then) =
      __$ModeStateCopyWithImpl<$Res>;
  @override
  $Res call({String mode, bool canHide});
}

/// @nodoc
class __$ModeStateCopyWithImpl<$Res> extends _$ModeStateCopyWithImpl<$Res>
    implements _$ModeStateCopyWith<$Res> {
  __$ModeStateCopyWithImpl(_ModeState _value, $Res Function(_ModeState) _then)
      : super(_value, (v) => _then(v as _ModeState));

  @override
  _ModeState get _value => super._value as _ModeState;

  @override
  $Res call({
    Object? mode = freezed,
    Object? canHide = freezed,
  }) {
    return _then(_ModeState(
      mode: mode == freezed
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as String,
      canHide: canHide == freezed
          ? _value.canHide
          : canHide // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ModeState implements _ModeState {
  _$_ModeState({this.mode = "preference", this.canHide = false});

  @JsonKey()
  @override
  final String mode;
  @JsonKey()
  @override
  final bool canHide;

  @override
  String toString() {
    return 'ModeState(mode: $mode, canHide: $canHide)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ModeState &&
            const DeepCollectionEquality().equals(other.mode, mode) &&
            const DeepCollectionEquality().equals(other.canHide, canHide));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(mode),
      const DeepCollectionEquality().hash(canHide));

  @JsonKey(ignore: true)
  @override
  _$ModeStateCopyWith<_ModeState> get copyWith =>
      __$ModeStateCopyWithImpl<_ModeState>(this, _$identity);
}

abstract class _ModeState implements ModeState {
  factory _ModeState({String mode, bool canHide}) = _$_ModeState;

  @override
  String get mode;
  @override
  bool get canHide;
  @override
  @JsonKey(ignore: true)
  _$ModeStateCopyWith<_ModeState> get copyWith =>
      throw _privateConstructorUsedError;
}
