// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'window_hotkey_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$WindowHotKeyStateTearOff {
  const _$WindowHotKeyStateTearOff();

  _WindowHotKeyState call({String hotKey = ""}) {
    return _WindowHotKeyState(
      hotKey: hotKey,
    );
  }
}

/// @nodoc
const $WindowHotKeyState = _$WindowHotKeyStateTearOff();

/// @nodoc
mixin _$WindowHotKeyState {
  String get hotKey => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WindowHotKeyStateCopyWith<WindowHotKeyState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WindowHotKeyStateCopyWith<$Res> {
  factory $WindowHotKeyStateCopyWith(
          WindowHotKeyState value, $Res Function(WindowHotKeyState) then) =
      _$WindowHotKeyStateCopyWithImpl<$Res>;
  $Res call({String hotKey});
}

/// @nodoc
class _$WindowHotKeyStateCopyWithImpl<$Res>
    implements $WindowHotKeyStateCopyWith<$Res> {
  _$WindowHotKeyStateCopyWithImpl(this._value, this._then);

  final WindowHotKeyState _value;
  // ignore: unused_field
  final $Res Function(WindowHotKeyState) _then;

  @override
  $Res call({
    Object? hotKey = freezed,
  }) {
    return _then(_value.copyWith(
      hotKey: hotKey == freezed
          ? _value.hotKey
          : hotKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$WindowHotKeyStateCopyWith<$Res>
    implements $WindowHotKeyStateCopyWith<$Res> {
  factory _$WindowHotKeyStateCopyWith(
          _WindowHotKeyState value, $Res Function(_WindowHotKeyState) then) =
      __$WindowHotKeyStateCopyWithImpl<$Res>;
  @override
  $Res call({String hotKey});
}

/// @nodoc
class __$WindowHotKeyStateCopyWithImpl<$Res>
    extends _$WindowHotKeyStateCopyWithImpl<$Res>
    implements _$WindowHotKeyStateCopyWith<$Res> {
  __$WindowHotKeyStateCopyWithImpl(
      _WindowHotKeyState _value, $Res Function(_WindowHotKeyState) _then)
      : super(_value, (v) => _then(v as _WindowHotKeyState));

  @override
  _WindowHotKeyState get _value => super._value as _WindowHotKeyState;

  @override
  $Res call({
    Object? hotKey = freezed,
  }) {
    return _then(_WindowHotKeyState(
      hotKey: hotKey == freezed
          ? _value.hotKey
          : hotKey // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_WindowHotKeyState implements _WindowHotKeyState {
  _$_WindowHotKeyState({this.hotKey = ""});

  @JsonKey(defaultValue: "")
  @override
  final String hotKey;

  @override
  String toString() {
    return 'WindowHotKeyState(hotKey: $hotKey)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _WindowHotKeyState &&
            (identical(other.hotKey, hotKey) ||
                const DeepCollectionEquality().equals(other.hotKey, hotKey)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(hotKey);

  @JsonKey(ignore: true)
  @override
  _$WindowHotKeyStateCopyWith<_WindowHotKeyState> get copyWith =>
      __$WindowHotKeyStateCopyWithImpl<_WindowHotKeyState>(this, _$identity);
}

abstract class _WindowHotKeyState implements WindowHotKeyState {
  factory _WindowHotKeyState({String hotKey}) = _$_WindowHotKeyState;

  @override
  String get hotKey => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$WindowHotKeyStateCopyWith<_WindowHotKeyState> get copyWith =>
      throw _privateConstructorUsedError;
}
