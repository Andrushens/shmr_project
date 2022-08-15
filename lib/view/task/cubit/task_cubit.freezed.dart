// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'task_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TaskState {
  Task? get task => throw _privateConstructorUsedError;
  int? get deadline => throw _privateConstructorUsedError;
  Importance get importance => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  bool get isEditingComplete => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskStateCopyWith<TaskState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStateCopyWith<$Res> {
  factory $TaskStateCopyWith(TaskState value, $Res Function(TaskState) then) =
      _$TaskStateCopyWithImpl<$Res>;
  $Res call(
      {Task? task,
      int? deadline,
      Importance importance,
      String text,
      bool isEditingComplete});

  $TaskCopyWith<$Res>? get task;
}

/// @nodoc
class _$TaskStateCopyWithImpl<$Res> implements $TaskStateCopyWith<$Res> {
  _$TaskStateCopyWithImpl(this._value, this._then);

  final TaskState _value;
  // ignore: unused_field
  final $Res Function(TaskState) _then;

  @override
  $Res call({
    Object? task = freezed,
    Object? deadline = freezed,
    Object? importance = freezed,
    Object? text = freezed,
    Object? isEditingComplete = freezed,
  }) {
    return _then(_value.copyWith(
      task: task == freezed
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task?,
      deadline: deadline == freezed
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as int?,
      importance: importance == freezed
          ? _value.importance
          : importance // ignore: cast_nullable_to_non_nullable
              as Importance,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isEditingComplete: isEditingComplete == freezed
          ? _value.isEditingComplete
          : isEditingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $TaskCopyWith<$Res>? get task {
    if (_value.task == null) {
      return null;
    }

    return $TaskCopyWith<$Res>(_value.task!, (value) {
      return _then(_value.copyWith(task: value));
    });
  }
}

/// @nodoc
abstract class _$$_TaskStateCopyWith<$Res> implements $TaskStateCopyWith<$Res> {
  factory _$$_TaskStateCopyWith(
          _$_TaskState value, $Res Function(_$_TaskState) then) =
      __$$_TaskStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {Task? task,
      int? deadline,
      Importance importance,
      String text,
      bool isEditingComplete});

  @override
  $TaskCopyWith<$Res>? get task;
}

/// @nodoc
class __$$_TaskStateCopyWithImpl<$Res> extends _$TaskStateCopyWithImpl<$Res>
    implements _$$_TaskStateCopyWith<$Res> {
  __$$_TaskStateCopyWithImpl(
      _$_TaskState _value, $Res Function(_$_TaskState) _then)
      : super(_value, (v) => _then(v as _$_TaskState));

  @override
  _$_TaskState get _value => super._value as _$_TaskState;

  @override
  $Res call({
    Object? task = freezed,
    Object? deadline = freezed,
    Object? importance = freezed,
    Object? text = freezed,
    Object? isEditingComplete = freezed,
  }) {
    return _then(_$_TaskState(
      task: task == freezed
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as Task?,
      deadline: deadline == freezed
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as int?,
      importance: importance == freezed
          ? _value.importance
          : importance // ignore: cast_nullable_to_non_nullable
              as Importance,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isEditingComplete: isEditingComplete == freezed
          ? _value.isEditingComplete
          : isEditingComplete // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_TaskState implements _TaskState {
  const _$_TaskState(
      {required this.task,
      required this.deadline,
      required this.importance,
      required this.text,
      this.isEditingComplete = false});

  @override
  final Task? task;
  @override
  final int? deadline;
  @override
  final Importance importance;
  @override
  final String text;
  @override
  @JsonKey()
  final bool isEditingComplete;

  @override
  String toString() {
    return 'TaskState(task: $task, deadline: $deadline, importance: $importance, text: $text, isEditingComplete: $isEditingComplete)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TaskState &&
            const DeepCollectionEquality().equals(other.task, task) &&
            const DeepCollectionEquality().equals(other.deadline, deadline) &&
            const DeepCollectionEquality()
                .equals(other.importance, importance) &&
            const DeepCollectionEquality().equals(other.text, text) &&
            const DeepCollectionEquality()
                .equals(other.isEditingComplete, isEditingComplete));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(task),
      const DeepCollectionEquality().hash(deadline),
      const DeepCollectionEquality().hash(importance),
      const DeepCollectionEquality().hash(text),
      const DeepCollectionEquality().hash(isEditingComplete));

  @JsonKey(ignore: true)
  @override
  _$$_TaskStateCopyWith<_$_TaskState> get copyWith =>
      __$$_TaskStateCopyWithImpl<_$_TaskState>(this, _$identity);
}

abstract class _TaskState implements TaskState {
  const factory _TaskState(
      {required final Task? task,
      required final int? deadline,
      required final Importance importance,
      required final String text,
      final bool isEditingComplete}) = _$_TaskState;

  @override
  Task? get task;
  @override
  int? get deadline;
  @override
  Importance get importance;
  @override
  String get text;
  @override
  bool get isEditingComplete;
  @override
  @JsonKey(ignore: true)
  _$$_TaskStateCopyWith<_$_TaskState> get copyWith =>
      throw _privateConstructorUsedError;
}
