// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'apps_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AppsStateTearOff {
  const _$AppsStateTearOff();

  _AppsState call({Map<String, ShortcutApp>? apps = null}) {
    return _AppsState(
      apps: apps,
    );
  }
}

/// @nodoc
const $AppsState = _$AppsStateTearOff();

/// @nodoc
mixin _$AppsState {
  Map<String, ShortcutApp>? get apps => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppsStateCopyWith<AppsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppsStateCopyWith<$Res> {
  factory $AppsStateCopyWith(AppsState value, $Res Function(AppsState) then) =
      _$AppsStateCopyWithImpl<$Res>;
  $Res call({Map<String, ShortcutApp>? apps});
}

/// @nodoc
class _$AppsStateCopyWithImpl<$Res> implements $AppsStateCopyWith<$Res> {
  _$AppsStateCopyWithImpl(this._value, this._then);

  final AppsState _value;
  // ignore: unused_field
  final $Res Function(AppsState) _then;

  @override
  $Res call({
    Object? apps = freezed,
  }) {
    return _then(_value.copyWith(
      apps: apps == freezed
          ? _value.apps
          : apps // ignore: cast_nullable_to_non_nullable
              as Map<String, ShortcutApp>?,
    ));
  }
}

/// @nodoc
abstract class _$AppsStateCopyWith<$Res> implements $AppsStateCopyWith<$Res> {
  factory _$AppsStateCopyWith(
          _AppsState value, $Res Function(_AppsState) then) =
      __$AppsStateCopyWithImpl<$Res>;
  @override
  $Res call({Map<String, ShortcutApp>? apps});
}

/// @nodoc
class __$AppsStateCopyWithImpl<$Res> extends _$AppsStateCopyWithImpl<$Res>
    implements _$AppsStateCopyWith<$Res> {
  __$AppsStateCopyWithImpl(_AppsState _value, $Res Function(_AppsState) _then)
      : super(_value, (v) => _then(v as _AppsState));

  @override
  _AppsState get _value => super._value as _AppsState;

  @override
  $Res call({
    Object? apps = freezed,
  }) {
    return _then(_AppsState(
      apps: apps == freezed
          ? _value.apps
          : apps // ignore: cast_nullable_to_non_nullable
              as Map<String, ShortcutApp>?,
    ));
  }
}

/// @nodoc

class _$_AppsState implements _AppsState {
  _$_AppsState({this.apps = null});

  @JsonKey(defaultValue: null)
  @override
  final Map<String, ShortcutApp>? apps;

  @override
  String toString() {
    return 'AppsState(apps: $apps)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AppsState &&
            (identical(other.apps, apps) ||
                const DeepCollectionEquality().equals(other.apps, apps)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(apps);

  @JsonKey(ignore: true)
  @override
  _$AppsStateCopyWith<_AppsState> get copyWith =>
      __$AppsStateCopyWithImpl<_AppsState>(this, _$identity);
}

abstract class _AppsState implements AppsState {
  factory _AppsState({Map<String, ShortcutApp>? apps}) = _$_AppsState;

  @override
  Map<String, ShortcutApp>? get apps => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AppsStateCopyWith<_AppsState> get copyWith =>
      throw _privateConstructorUsedError;
}
