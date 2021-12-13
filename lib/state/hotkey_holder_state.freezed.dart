// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'hotkey_holder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$HotKeyHolderStateTearOff {
  const _$HotKeyHolderStateTearOff();

  _HotKeyHolderState call(
      {String? hotKeyName = null,
      KeyCombo? keyCombo = null,
      Function? event = null}) {
    return _HotKeyHolderState(
      hotKeyName: hotKeyName,
      keyCombo: keyCombo,
      event: event,
    );
  }
}

/// @nodoc
const $HotKeyHolderState = _$HotKeyHolderStateTearOff();

/// @nodoc
mixin _$HotKeyHolderState {
  String? get hotKeyName => throw _privateConstructorUsedError;
  KeyCombo? get keyCombo => throw _privateConstructorUsedError;
  Function? get event => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HotKeyHolderStateCopyWith<HotKeyHolderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HotKeyHolderStateCopyWith<$Res> {
  factory $HotKeyHolderStateCopyWith(
          HotKeyHolderState value, $Res Function(HotKeyHolderState) then) =
      _$HotKeyHolderStateCopyWithImpl<$Res>;
  $Res call({String? hotKeyName, KeyCombo? keyCombo, Function? event});
}

/// @nodoc
class _$HotKeyHolderStateCopyWithImpl<$Res>
    implements $HotKeyHolderStateCopyWith<$Res> {
  _$HotKeyHolderStateCopyWithImpl(this._value, this._then);

  final HotKeyHolderState _value;
  // ignore: unused_field
  final $Res Function(HotKeyHolderState) _then;

  @override
  $Res call({
    Object? hotKeyName = freezed,
    Object? keyCombo = freezed,
    Object? event = freezed,
  }) {
    return _then(_value.copyWith(
      hotKeyName: hotKeyName == freezed
          ? _value.hotKeyName
          : hotKeyName // ignore: cast_nullable_to_non_nullable
              as String?,
      keyCombo: keyCombo == freezed
          ? _value.keyCombo
          : keyCombo // ignore: cast_nullable_to_non_nullable
              as KeyCombo?,
      event: event == freezed
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Function?,
    ));
  }
}

/// @nodoc
abstract class _$HotKeyHolderStateCopyWith<$Res>
    implements $HotKeyHolderStateCopyWith<$Res> {
  factory _$HotKeyHolderStateCopyWith(
          _HotKeyHolderState value, $Res Function(_HotKeyHolderState) then) =
      __$HotKeyHolderStateCopyWithImpl<$Res>;
  @override
  $Res call({String? hotKeyName, KeyCombo? keyCombo, Function? event});
}

/// @nodoc
class __$HotKeyHolderStateCopyWithImpl<$Res>
    extends _$HotKeyHolderStateCopyWithImpl<$Res>
    implements _$HotKeyHolderStateCopyWith<$Res> {
  __$HotKeyHolderStateCopyWithImpl(
      _HotKeyHolderState _value, $Res Function(_HotKeyHolderState) _then)
      : super(_value, (v) => _then(v as _HotKeyHolderState));

  @override
  _HotKeyHolderState get _value => super._value as _HotKeyHolderState;

  @override
  $Res call({
    Object? hotKeyName = freezed,
    Object? keyCombo = freezed,
    Object? event = freezed,
  }) {
    return _then(_HotKeyHolderState(
      hotKeyName: hotKeyName == freezed
          ? _value.hotKeyName
          : hotKeyName // ignore: cast_nullable_to_non_nullable
              as String?,
      keyCombo: keyCombo == freezed
          ? _value.keyCombo
          : keyCombo // ignore: cast_nullable_to_non_nullable
              as KeyCombo?,
      event: event == freezed
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as Function?,
    ));
  }
}

/// @nodoc

class _$_HotKeyHolderState implements _HotKeyHolderState {
  _$_HotKeyHolderState(
      {this.hotKeyName = null, this.keyCombo = null, this.event = null});

  @JsonKey(defaultValue: null)
  @override
  final String? hotKeyName;
  @JsonKey(defaultValue: null)
  @override
  final KeyCombo? keyCombo;
  @JsonKey(defaultValue: null)
  @override
  final Function? event;

  @override
  String toString() {
    return 'HotKeyHolderState(hotKeyName: $hotKeyName, keyCombo: $keyCombo, event: $event)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _HotKeyHolderState &&
            (identical(other.hotKeyName, hotKeyName) ||
                const DeepCollectionEquality()
                    .equals(other.hotKeyName, hotKeyName)) &&
            (identical(other.keyCombo, keyCombo) ||
                const DeepCollectionEquality()
                    .equals(other.keyCombo, keyCombo)) &&
            (identical(other.event, event) ||
                const DeepCollectionEquality().equals(other.event, event)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(hotKeyName) ^
      const DeepCollectionEquality().hash(keyCombo) ^
      const DeepCollectionEquality().hash(event);

  @JsonKey(ignore: true)
  @override
  _$HotKeyHolderStateCopyWith<_HotKeyHolderState> get copyWith =>
      __$HotKeyHolderStateCopyWithImpl<_HotKeyHolderState>(this, _$identity);
}

abstract class _HotKeyHolderState implements HotKeyHolderState {
  factory _HotKeyHolderState(
      {String? hotKeyName,
      KeyCombo? keyCombo,
      Function? event}) = _$_HotKeyHolderState;

  @override
  String? get hotKeyName => throw _privateConstructorUsedError;
  @override
  KeyCombo? get keyCombo => throw _privateConstructorUsedError;
  @override
  Function? get event => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$HotKeyHolderStateCopyWith<_HotKeyHolderState> get copyWith =>
      throw _privateConstructorUsedError;
}
