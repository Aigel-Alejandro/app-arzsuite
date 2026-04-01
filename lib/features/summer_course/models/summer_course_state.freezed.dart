// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'summer_course_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SummerCourseState _$SummerCourseStateFromJson(Map<String, dynamic> json) {
  return _SummerCourseState.fromJson(json);
}

/// @nodoc
mixin _$SummerCourseState {
  int get currentStep => throw _privateConstructorUsedError;
  Member? get selectedTitular => throw _privateConstructorUsedError;
  List<Member> get beneficiariesList =>
      throw _privateConstructorUsedError; // Options for current titular
  List<RegistrationParticipant> get selectedParticipants =>
      throw _privateConstructorUsedError; // From beneficiaries + guests
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get salesOrderId =>
      throw _privateConstructorUsedError; // ID generated at the end
  String? get masterToken =>
      throw _privateConstructorUsedError; // Master Netkey for the whole registration
  List<dynamic>? get pickUpTokens =>
      throw _privateConstructorUsedError; // Tokens_acceso para recoger a los niños
  Map<String, dynamic>? get activeRegistration =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get courseCosts =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get intensiveActivities =>
      throw _privateConstructorUsedError; // Terms & Conditions
  bool get termsAccepted => throw _privateConstructorUsedError;
  bool get termsRequired => throw _privateConstructorUsedError;
  String? get termsContent => throw _privateConstructorUsedError;
  String? get termsVersion => throw _privateConstructorUsedError;
  int? get termsId => throw _privateConstructorUsedError;

  /// Serializes this SummerCourseState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SummerCourseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SummerCourseStateCopyWith<SummerCourseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummerCourseStateCopyWith<$Res> {
  factory $SummerCourseStateCopyWith(
    SummerCourseState value,
    $Res Function(SummerCourseState) then,
  ) = _$SummerCourseStateCopyWithImpl<$Res, SummerCourseState>;
  @useResult
  $Res call({
    int currentStep,
    Member? selectedTitular,
    List<Member> beneficiariesList,
    List<RegistrationParticipant> selectedParticipants,
    bool isLoading,
    String? errorMessage,
    String? salesOrderId,
    String? masterToken,
    List<dynamic>? pickUpTokens,
    Map<String, dynamic>? activeRegistration,
    List<Map<String, dynamic>> courseCosts,
    List<Map<String, dynamic>> intensiveActivities,
    bool termsAccepted,
    bool termsRequired,
    String? termsContent,
    String? termsVersion,
    int? termsId,
  });

  $MemberCopyWith<$Res>? get selectedTitular;
}

/// @nodoc
class _$SummerCourseStateCopyWithImpl<$Res, $Val extends SummerCourseState>
    implements $SummerCourseStateCopyWith<$Res> {
  _$SummerCourseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SummerCourseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? selectedTitular = freezed,
    Object? beneficiariesList = null,
    Object? selectedParticipants = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? salesOrderId = freezed,
    Object? masterToken = freezed,
    Object? pickUpTokens = freezed,
    Object? activeRegistration = freezed,
    Object? courseCosts = null,
    Object? intensiveActivities = null,
    Object? termsAccepted = null,
    Object? termsRequired = null,
    Object? termsContent = freezed,
    Object? termsVersion = freezed,
    Object? termsId = freezed,
  }) {
    return _then(
      _value.copyWith(
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            selectedTitular: freezed == selectedTitular
                ? _value.selectedTitular
                : selectedTitular // ignore: cast_nullable_to_non_nullable
                      as Member?,
            beneficiariesList: null == beneficiariesList
                ? _value.beneficiariesList
                : beneficiariesList // ignore: cast_nullable_to_non_nullable
                      as List<Member>,
            selectedParticipants: null == selectedParticipants
                ? _value.selectedParticipants
                : selectedParticipants // ignore: cast_nullable_to_non_nullable
                      as List<RegistrationParticipant>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            salesOrderId: freezed == salesOrderId
                ? _value.salesOrderId
                : salesOrderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            masterToken: freezed == masterToken
                ? _value.masterToken
                : masterToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            pickUpTokens: freezed == pickUpTokens
                ? _value.pickUpTokens
                : pickUpTokens // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>?,
            activeRegistration: freezed == activeRegistration
                ? _value.activeRegistration
                : activeRegistration // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            courseCosts: null == courseCosts
                ? _value.courseCosts
                : courseCosts // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            intensiveActivities: null == intensiveActivities
                ? _value.intensiveActivities
                : intensiveActivities // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            termsAccepted: null == termsAccepted
                ? _value.termsAccepted
                : termsAccepted // ignore: cast_nullable_to_non_nullable
                      as bool,
            termsRequired: null == termsRequired
                ? _value.termsRequired
                : termsRequired // ignore: cast_nullable_to_non_nullable
                      as bool,
            termsContent: freezed == termsContent
                ? _value.termsContent
                : termsContent // ignore: cast_nullable_to_non_nullable
                      as String?,
            termsVersion: freezed == termsVersion
                ? _value.termsVersion
                : termsVersion // ignore: cast_nullable_to_non_nullable
                      as String?,
            termsId: freezed == termsId
                ? _value.termsId
                : termsId // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }

  /// Create a copy of SummerCourseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemberCopyWith<$Res>? get selectedTitular {
    if (_value.selectedTitular == null) {
      return null;
    }

    return $MemberCopyWith<$Res>(_value.selectedTitular!, (value) {
      return _then(_value.copyWith(selectedTitular: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SummerCourseStateImplCopyWith<$Res>
    implements $SummerCourseStateCopyWith<$Res> {
  factory _$$SummerCourseStateImplCopyWith(
    _$SummerCourseStateImpl value,
    $Res Function(_$SummerCourseStateImpl) then,
  ) = __$$SummerCourseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int currentStep,
    Member? selectedTitular,
    List<Member> beneficiariesList,
    List<RegistrationParticipant> selectedParticipants,
    bool isLoading,
    String? errorMessage,
    String? salesOrderId,
    String? masterToken,
    List<dynamic>? pickUpTokens,
    Map<String, dynamic>? activeRegistration,
    List<Map<String, dynamic>> courseCosts,
    List<Map<String, dynamic>> intensiveActivities,
    bool termsAccepted,
    bool termsRequired,
    String? termsContent,
    String? termsVersion,
    int? termsId,
  });

  @override
  $MemberCopyWith<$Res>? get selectedTitular;
}

/// @nodoc
class __$$SummerCourseStateImplCopyWithImpl<$Res>
    extends _$SummerCourseStateCopyWithImpl<$Res, _$SummerCourseStateImpl>
    implements _$$SummerCourseStateImplCopyWith<$Res> {
  __$$SummerCourseStateImplCopyWithImpl(
    _$SummerCourseStateImpl _value,
    $Res Function(_$SummerCourseStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SummerCourseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? selectedTitular = freezed,
    Object? beneficiariesList = null,
    Object? selectedParticipants = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? salesOrderId = freezed,
    Object? masterToken = freezed,
    Object? pickUpTokens = freezed,
    Object? activeRegistration = freezed,
    Object? courseCosts = null,
    Object? intensiveActivities = null,
    Object? termsAccepted = null,
    Object? termsRequired = null,
    Object? termsContent = freezed,
    Object? termsVersion = freezed,
    Object? termsId = freezed,
  }) {
    return _then(
      _$SummerCourseStateImpl(
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        selectedTitular: freezed == selectedTitular
            ? _value.selectedTitular
            : selectedTitular // ignore: cast_nullable_to_non_nullable
                  as Member?,
        beneficiariesList: null == beneficiariesList
            ? _value._beneficiariesList
            : beneficiariesList // ignore: cast_nullable_to_non_nullable
                  as List<Member>,
        selectedParticipants: null == selectedParticipants
            ? _value._selectedParticipants
            : selectedParticipants // ignore: cast_nullable_to_non_nullable
                  as List<RegistrationParticipant>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        salesOrderId: freezed == salesOrderId
            ? _value.salesOrderId
            : salesOrderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        masterToken: freezed == masterToken
            ? _value.masterToken
            : masterToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        pickUpTokens: freezed == pickUpTokens
            ? _value._pickUpTokens
            : pickUpTokens // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>?,
        activeRegistration: freezed == activeRegistration
            ? _value._activeRegistration
            : activeRegistration // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        courseCosts: null == courseCosts
            ? _value._courseCosts
            : courseCosts // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        intensiveActivities: null == intensiveActivities
            ? _value._intensiveActivities
            : intensiveActivities // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        termsAccepted: null == termsAccepted
            ? _value.termsAccepted
            : termsAccepted // ignore: cast_nullable_to_non_nullable
                  as bool,
        termsRequired: null == termsRequired
            ? _value.termsRequired
            : termsRequired // ignore: cast_nullable_to_non_nullable
                  as bool,
        termsContent: freezed == termsContent
            ? _value.termsContent
            : termsContent // ignore: cast_nullable_to_non_nullable
                  as String?,
        termsVersion: freezed == termsVersion
            ? _value.termsVersion
            : termsVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
        termsId: freezed == termsId
            ? _value.termsId
            : termsId // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SummerCourseStateImpl extends _SummerCourseState {
  const _$SummerCourseStateImpl({
    this.currentStep = 0,
    this.selectedTitular,
    final List<Member> beneficiariesList = const [],
    final List<RegistrationParticipant> selectedParticipants = const [],
    this.isLoading = false,
    this.errorMessage,
    this.salesOrderId,
    this.masterToken,
    final List<dynamic>? pickUpTokens,
    final Map<String, dynamic>? activeRegistration,
    final List<Map<String, dynamic>> courseCosts = const [],
    final List<Map<String, dynamic>> intensiveActivities = const [],
    this.termsAccepted = false,
    this.termsRequired = false,
    this.termsContent,
    this.termsVersion,
    this.termsId,
  }) : _beneficiariesList = beneficiariesList,
       _selectedParticipants = selectedParticipants,
       _pickUpTokens = pickUpTokens,
       _activeRegistration = activeRegistration,
       _courseCosts = courseCosts,
       _intensiveActivities = intensiveActivities,
       super._();

  factory _$SummerCourseStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummerCourseStateImplFromJson(json);

  @override
  @JsonKey()
  final int currentStep;
  @override
  final Member? selectedTitular;
  final List<Member> _beneficiariesList;
  @override
  @JsonKey()
  List<Member> get beneficiariesList {
    if (_beneficiariesList is EqualUnmodifiableListView)
      return _beneficiariesList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_beneficiariesList);
  }

  // Options for current titular
  final List<RegistrationParticipant> _selectedParticipants;
  // Options for current titular
  @override
  @JsonKey()
  List<RegistrationParticipant> get selectedParticipants {
    if (_selectedParticipants is EqualUnmodifiableListView)
      return _selectedParticipants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedParticipants);
  }

  // From beneficiaries + guests
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final String? salesOrderId;
  // ID generated at the end
  @override
  final String? masterToken;
  // Master Netkey for the whole registration
  final List<dynamic>? _pickUpTokens;
  // Master Netkey for the whole registration
  @override
  List<dynamic>? get pickUpTokens {
    final value = _pickUpTokens;
    if (value == null) return null;
    if (_pickUpTokens is EqualUnmodifiableListView) return _pickUpTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  // Tokens_acceso para recoger a los niños
  final Map<String, dynamic>? _activeRegistration;
  // Tokens_acceso para recoger a los niños
  @override
  Map<String, dynamic>? get activeRegistration {
    final value = _activeRegistration;
    if (value == null) return null;
    if (_activeRegistration is EqualUnmodifiableMapView)
      return _activeRegistration;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Map<String, dynamic>> _courseCosts;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get courseCosts {
    if (_courseCosts is EqualUnmodifiableListView) return _courseCosts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_courseCosts);
  }

  final List<Map<String, dynamic>> _intensiveActivities;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get intensiveActivities {
    if (_intensiveActivities is EqualUnmodifiableListView)
      return _intensiveActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_intensiveActivities);
  }

  // Terms & Conditions
  @override
  @JsonKey()
  final bool termsAccepted;
  @override
  @JsonKey()
  final bool termsRequired;
  @override
  final String? termsContent;
  @override
  final String? termsVersion;
  @override
  final int? termsId;

  @override
  String toString() {
    return 'SummerCourseState(currentStep: $currentStep, selectedTitular: $selectedTitular, beneficiariesList: $beneficiariesList, selectedParticipants: $selectedParticipants, isLoading: $isLoading, errorMessage: $errorMessage, salesOrderId: $salesOrderId, masterToken: $masterToken, pickUpTokens: $pickUpTokens, activeRegistration: $activeRegistration, courseCosts: $courseCosts, intensiveActivities: $intensiveActivities, termsAccepted: $termsAccepted, termsRequired: $termsRequired, termsContent: $termsContent, termsVersion: $termsVersion, termsId: $termsId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummerCourseStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.selectedTitular, selectedTitular) ||
                other.selectedTitular == selectedTitular) &&
            const DeepCollectionEquality().equals(
              other._beneficiariesList,
              _beneficiariesList,
            ) &&
            const DeepCollectionEquality().equals(
              other._selectedParticipants,
              _selectedParticipants,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.salesOrderId, salesOrderId) ||
                other.salesOrderId == salesOrderId) &&
            (identical(other.masterToken, masterToken) ||
                other.masterToken == masterToken) &&
            const DeepCollectionEquality().equals(
              other._pickUpTokens,
              _pickUpTokens,
            ) &&
            const DeepCollectionEquality().equals(
              other._activeRegistration,
              _activeRegistration,
            ) &&
            const DeepCollectionEquality().equals(
              other._courseCosts,
              _courseCosts,
            ) &&
            const DeepCollectionEquality().equals(
              other._intensiveActivities,
              _intensiveActivities,
            ) &&
            (identical(other.termsAccepted, termsAccepted) ||
                other.termsAccepted == termsAccepted) &&
            (identical(other.termsRequired, termsRequired) ||
                other.termsRequired == termsRequired) &&
            (identical(other.termsContent, termsContent) ||
                other.termsContent == termsContent) &&
            (identical(other.termsVersion, termsVersion) ||
                other.termsVersion == termsVersion) &&
            (identical(other.termsId, termsId) || other.termsId == termsId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentStep,
    selectedTitular,
    const DeepCollectionEquality().hash(_beneficiariesList),
    const DeepCollectionEquality().hash(_selectedParticipants),
    isLoading,
    errorMessage,
    salesOrderId,
    masterToken,
    const DeepCollectionEquality().hash(_pickUpTokens),
    const DeepCollectionEquality().hash(_activeRegistration),
    const DeepCollectionEquality().hash(_courseCosts),
    const DeepCollectionEquality().hash(_intensiveActivities),
    termsAccepted,
    termsRequired,
    termsContent,
    termsVersion,
    termsId,
  );

  /// Create a copy of SummerCourseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SummerCourseStateImplCopyWith<_$SummerCourseStateImpl> get copyWith =>
      __$$SummerCourseStateImplCopyWithImpl<_$SummerCourseStateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SummerCourseStateImplToJson(this);
  }
}

abstract class _SummerCourseState extends SummerCourseState {
  const factory _SummerCourseState({
    final int currentStep,
    final Member? selectedTitular,
    final List<Member> beneficiariesList,
    final List<RegistrationParticipant> selectedParticipants,
    final bool isLoading,
    final String? errorMessage,
    final String? salesOrderId,
    final String? masterToken,
    final List<dynamic>? pickUpTokens,
    final Map<String, dynamic>? activeRegistration,
    final List<Map<String, dynamic>> courseCosts,
    final List<Map<String, dynamic>> intensiveActivities,
    final bool termsAccepted,
    final bool termsRequired,
    final String? termsContent,
    final String? termsVersion,
    final int? termsId,
  }) = _$SummerCourseStateImpl;
  const _SummerCourseState._() : super._();

  factory _SummerCourseState.fromJson(Map<String, dynamic> json) =
      _$SummerCourseStateImpl.fromJson;

  @override
  int get currentStep;
  @override
  Member? get selectedTitular;
  @override
  List<Member> get beneficiariesList; // Options for current titular
  @override
  List<RegistrationParticipant> get selectedParticipants; // From beneficiaries + guests
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  String? get salesOrderId; // ID generated at the end
  @override
  String? get masterToken; // Master Netkey for the whole registration
  @override
  List<dynamic>? get pickUpTokens; // Tokens_acceso para recoger a los niños
  @override
  Map<String, dynamic>? get activeRegistration;
  @override
  List<Map<String, dynamic>> get courseCosts;
  @override
  List<Map<String, dynamic>> get intensiveActivities; // Terms & Conditions
  @override
  bool get termsAccepted;
  @override
  bool get termsRequired;
  @override
  String? get termsContent;
  @override
  String? get termsVersion;
  @override
  int? get termsId;

  /// Create a copy of SummerCourseState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SummerCourseStateImplCopyWith<_$SummerCourseStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
