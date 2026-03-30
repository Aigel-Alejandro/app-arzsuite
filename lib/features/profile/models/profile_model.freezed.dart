// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return _ProfileModel.fromJson(json);
}

/// @nodoc
mixin _$ProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get entityid => throw _privateConstructorUsedError;
  String get fullname => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get rfc => throw _privateConstructorUsedError;
  String? get curp => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  String? get birthDate => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_picture')
  String? get profilePicture => throw _privateConstructorUsedError;
  @JsonKey(name: 'patrimonial_condition_id')
  int? get patrimonialConditionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_edit_sensitive_data')
  bool get canEditSensitiveData => throw _privateConstructorUsedError;
  @JsonKey(name: 'personal_address')
  Map<String, dynamic>? get personalAddress =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'fiscal_data')
  Map<String, dynamic>? get fiscalData => throw _privateConstructorUsedError;
  ProfileSettingsModel get settings => throw _privateConstructorUsedError;
  @JsonKey(name: 'associated_members')
  List<SubMemberModel> get associatedMembers =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'legal_beneficiaries')
  List<Map<String, dynamic>> get legalBeneficiaries =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'vehicles')
  List<Map<String, dynamic>> get vehicles => throw _privateConstructorUsedError;

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
    ProfileModel value,
    $Res Function(ProfileModel) then,
  ) = _$ProfileModelCopyWithImpl<$Res, ProfileModel>;
  @useResult
  $Res call({
    String id,
    String entityid,
    String fullname,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    String? phone,
    String? rfc,
    String? curp,
    String? address,
    @JsonKey(name: 'birth_date') String? birthDate,
    int? age,
    @JsonKey(name: 'profile_picture') String? profilePicture,
    @JsonKey(name: 'patrimonial_condition_id') int? patrimonialConditionId,
    @JsonKey(name: 'can_edit_sensitive_data') bool canEditSensitiveData,
    @JsonKey(name: 'personal_address') Map<String, dynamic>? personalAddress,
    @JsonKey(name: 'fiscal_data') Map<String, dynamic>? fiscalData,
    ProfileSettingsModel settings,
    @JsonKey(name: 'associated_members') List<SubMemberModel> associatedMembers,
    @JsonKey(name: 'legal_beneficiaries')
    List<Map<String, dynamic>> legalBeneficiaries,
    @JsonKey(name: 'vehicles') List<Map<String, dynamic>> vehicles,
  });

  $ProfileSettingsModelCopyWith<$Res> get settings;
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res, $Val extends ProfileModel>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityid = null,
    Object? fullname = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? rfc = freezed,
    Object? curp = freezed,
    Object? address = freezed,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? profilePicture = freezed,
    Object? patrimonialConditionId = freezed,
    Object? canEditSensitiveData = null,
    Object? personalAddress = freezed,
    Object? fiscalData = freezed,
    Object? settings = null,
    Object? associatedMembers = null,
    Object? legalBeneficiaries = null,
    Object? vehicles = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            entityid: null == entityid
                ? _value.entityid
                : entityid // ignore: cast_nullable_to_non_nullable
                      as String,
            fullname: null == fullname
                ? _value.fullname
                : fullname // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            rfc: freezed == rfc
                ? _value.rfc
                : rfc // ignore: cast_nullable_to_non_nullable
                      as String?,
            curp: freezed == curp
                ? _value.curp
                : curp // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String?,
            birthDate: freezed == birthDate
                ? _value.birthDate
                : birthDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            profilePicture: freezed == profilePicture
                ? _value.profilePicture
                : profilePicture // ignore: cast_nullable_to_non_nullable
                      as String?,
            patrimonialConditionId: freezed == patrimonialConditionId
                ? _value.patrimonialConditionId
                : patrimonialConditionId // ignore: cast_nullable_to_non_nullable
                      as int?,
            canEditSensitiveData: null == canEditSensitiveData
                ? _value.canEditSensitiveData
                : canEditSensitiveData // ignore: cast_nullable_to_non_nullable
                      as bool,
            personalAddress: freezed == personalAddress
                ? _value.personalAddress
                : personalAddress // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            fiscalData: freezed == fiscalData
                ? _value.fiscalData
                : fiscalData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            settings: null == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as ProfileSettingsModel,
            associatedMembers: null == associatedMembers
                ? _value.associatedMembers
                : associatedMembers // ignore: cast_nullable_to_non_nullable
                      as List<SubMemberModel>,
            legalBeneficiaries: null == legalBeneficiaries
                ? _value.legalBeneficiaries
                : legalBeneficiaries // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            vehicles: null == vehicles
                ? _value.vehicles
                : vehicles // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
          )
          as $Val,
    );
  }

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileSettingsModelCopyWith<$Res> get settings {
    return $ProfileSettingsModelCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileModelImplCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$$ProfileModelImplCopyWith(
    _$ProfileModelImpl value,
    $Res Function(_$ProfileModelImpl) then,
  ) = __$$ProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String entityid,
    String fullname,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? email,
    String? phone,
    String? rfc,
    String? curp,
    String? address,
    @JsonKey(name: 'birth_date') String? birthDate,
    int? age,
    @JsonKey(name: 'profile_picture') String? profilePicture,
    @JsonKey(name: 'patrimonial_condition_id') int? patrimonialConditionId,
    @JsonKey(name: 'can_edit_sensitive_data') bool canEditSensitiveData,
    @JsonKey(name: 'personal_address') Map<String, dynamic>? personalAddress,
    @JsonKey(name: 'fiscal_data') Map<String, dynamic>? fiscalData,
    ProfileSettingsModel settings,
    @JsonKey(name: 'associated_members') List<SubMemberModel> associatedMembers,
    @JsonKey(name: 'legal_beneficiaries')
    List<Map<String, dynamic>> legalBeneficiaries,
    @JsonKey(name: 'vehicles') List<Map<String, dynamic>> vehicles,
  });

  @override
  $ProfileSettingsModelCopyWith<$Res> get settings;
}

/// @nodoc
class __$$ProfileModelImplCopyWithImpl<$Res>
    extends _$ProfileModelCopyWithImpl<$Res, _$ProfileModelImpl>
    implements _$$ProfileModelImplCopyWith<$Res> {
  __$$ProfileModelImplCopyWithImpl(
    _$ProfileModelImpl _value,
    $Res Function(_$ProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityid = null,
    Object? fullname = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? rfc = freezed,
    Object? curp = freezed,
    Object? address = freezed,
    Object? birthDate = freezed,
    Object? age = freezed,
    Object? profilePicture = freezed,
    Object? patrimonialConditionId = freezed,
    Object? canEditSensitiveData = null,
    Object? personalAddress = freezed,
    Object? fiscalData = freezed,
    Object? settings = null,
    Object? associatedMembers = null,
    Object? legalBeneficiaries = null,
    Object? vehicles = null,
  }) {
    return _then(
      _$ProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        entityid: null == entityid
            ? _value.entityid
            : entityid // ignore: cast_nullable_to_non_nullable
                  as String,
        fullname: null == fullname
            ? _value.fullname
            : fullname // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        rfc: freezed == rfc
            ? _value.rfc
            : rfc // ignore: cast_nullable_to_non_nullable
                  as String?,
        curp: freezed == curp
            ? _value.curp
            : curp // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String?,
        birthDate: freezed == birthDate
            ? _value.birthDate
            : birthDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        profilePicture: freezed == profilePicture
            ? _value.profilePicture
            : profilePicture // ignore: cast_nullable_to_non_nullable
                  as String?,
        patrimonialConditionId: freezed == patrimonialConditionId
            ? _value.patrimonialConditionId
            : patrimonialConditionId // ignore: cast_nullable_to_non_nullable
                  as int?,
        canEditSensitiveData: null == canEditSensitiveData
            ? _value.canEditSensitiveData
            : canEditSensitiveData // ignore: cast_nullable_to_non_nullable
                  as bool,
        personalAddress: freezed == personalAddress
            ? _value._personalAddress
            : personalAddress // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        fiscalData: freezed == fiscalData
            ? _value._fiscalData
            : fiscalData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        settings: null == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as ProfileSettingsModel,
        associatedMembers: null == associatedMembers
            ? _value._associatedMembers
            : associatedMembers // ignore: cast_nullable_to_non_nullable
                  as List<SubMemberModel>,
        legalBeneficiaries: null == legalBeneficiaries
            ? _value._legalBeneficiaries
            : legalBeneficiaries // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        vehicles: null == vehicles
            ? _value._vehicles
            : vehicles // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileModelImpl implements _ProfileModel {
  const _$ProfileModelImpl({
    required this.id,
    required this.entityid,
    required this.fullname,
    @JsonKey(name: 'first_name') this.firstName,
    @JsonKey(name: 'last_name') this.lastName,
    this.email,
    this.phone,
    this.rfc,
    this.curp,
    this.address,
    @JsonKey(name: 'birth_date') this.birthDate,
    this.age,
    @JsonKey(name: 'profile_picture') this.profilePicture,
    @JsonKey(name: 'patrimonial_condition_id') this.patrimonialConditionId,
    @JsonKey(name: 'can_edit_sensitive_data') this.canEditSensitiveData = false,
    @JsonKey(name: 'personal_address')
    final Map<String, dynamic>? personalAddress,
    @JsonKey(name: 'fiscal_data') final Map<String, dynamic>? fiscalData,
    required this.settings,
    @JsonKey(name: 'associated_members')
    final List<SubMemberModel> associatedMembers = const [],
    @JsonKey(name: 'legal_beneficiaries')
    final List<Map<String, dynamic>> legalBeneficiaries = const [],
    @JsonKey(name: 'vehicles')
    final List<Map<String, dynamic>> vehicles = const [],
  }) : _personalAddress = personalAddress,
       _fiscalData = fiscalData,
       _associatedMembers = associatedMembers,
       _legalBeneficiaries = legalBeneficiaries,
       _vehicles = vehicles;

  factory _$ProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String entityid;
  @override
  final String fullname;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? rfc;
  @override
  final String? curp;
  @override
  final String? address;
  @override
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @override
  final int? age;
  @override
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  @override
  @JsonKey(name: 'patrimonial_condition_id')
  final int? patrimonialConditionId;
  @override
  @JsonKey(name: 'can_edit_sensitive_data')
  final bool canEditSensitiveData;
  final Map<String, dynamic>? _personalAddress;
  @override
  @JsonKey(name: 'personal_address')
  Map<String, dynamic>? get personalAddress {
    final value = _personalAddress;
    if (value == null) return null;
    if (_personalAddress is EqualUnmodifiableMapView) return _personalAddress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _fiscalData;
  @override
  @JsonKey(name: 'fiscal_data')
  Map<String, dynamic>? get fiscalData {
    final value = _fiscalData;
    if (value == null) return null;
    if (_fiscalData is EqualUnmodifiableMapView) return _fiscalData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final ProfileSettingsModel settings;
  final List<SubMemberModel> _associatedMembers;
  @override
  @JsonKey(name: 'associated_members')
  List<SubMemberModel> get associatedMembers {
    if (_associatedMembers is EqualUnmodifiableListView)
      return _associatedMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_associatedMembers);
  }

  final List<Map<String, dynamic>> _legalBeneficiaries;
  @override
  @JsonKey(name: 'legal_beneficiaries')
  List<Map<String, dynamic>> get legalBeneficiaries {
    if (_legalBeneficiaries is EqualUnmodifiableListView)
      return _legalBeneficiaries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_legalBeneficiaries);
  }

  final List<Map<String, dynamic>> _vehicles;
  @override
  @JsonKey(name: 'vehicles')
  List<Map<String, dynamic>> get vehicles {
    if (_vehicles is EqualUnmodifiableListView) return _vehicles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vehicles);
  }

  @override
  String toString() {
    return 'ProfileModel(id: $id, entityid: $entityid, fullname: $fullname, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, rfc: $rfc, curp: $curp, address: $address, birthDate: $birthDate, age: $age, profilePicture: $profilePicture, patrimonialConditionId: $patrimonialConditionId, canEditSensitiveData: $canEditSensitiveData, personalAddress: $personalAddress, fiscalData: $fiscalData, settings: $settings, associatedMembers: $associatedMembers, legalBeneficiaries: $legalBeneficiaries, vehicles: $vehicles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityid, entityid) ||
                other.entityid == entityid) &&
            (identical(other.fullname, fullname) ||
                other.fullname == fullname) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.rfc, rfc) || other.rfc == rfc) &&
            (identical(other.curp, curp) || other.curp == curp) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.patrimonialConditionId, patrimonialConditionId) ||
                other.patrimonialConditionId == patrimonialConditionId) &&
            (identical(other.canEditSensitiveData, canEditSensitiveData) ||
                other.canEditSensitiveData == canEditSensitiveData) &&
            const DeepCollectionEquality().equals(
              other._personalAddress,
              _personalAddress,
            ) &&
            const DeepCollectionEquality().equals(
              other._fiscalData,
              _fiscalData,
            ) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            const DeepCollectionEquality().equals(
              other._associatedMembers,
              _associatedMembers,
            ) &&
            const DeepCollectionEquality().equals(
              other._legalBeneficiaries,
              _legalBeneficiaries,
            ) &&
            const DeepCollectionEquality().equals(other._vehicles, _vehicles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    entityid,
    fullname,
    firstName,
    lastName,
    email,
    phone,
    rfc,
    curp,
    address,
    birthDate,
    age,
    profilePicture,
    patrimonialConditionId,
    canEditSensitiveData,
    const DeepCollectionEquality().hash(_personalAddress),
    const DeepCollectionEquality().hash(_fiscalData),
    settings,
    const DeepCollectionEquality().hash(_associatedMembers),
    const DeepCollectionEquality().hash(_legalBeneficiaries),
    const DeepCollectionEquality().hash(_vehicles),
  ]);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      __$$ProfileModelImplCopyWithImpl<_$ProfileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileModelImplToJson(this);
  }
}

abstract class _ProfileModel implements ProfileModel {
  const factory _ProfileModel({
    required final String id,
    required final String entityid,
    required final String fullname,
    @JsonKey(name: 'first_name') final String? firstName,
    @JsonKey(name: 'last_name') final String? lastName,
    final String? email,
    final String? phone,
    final String? rfc,
    final String? curp,
    final String? address,
    @JsonKey(name: 'birth_date') final String? birthDate,
    final int? age,
    @JsonKey(name: 'profile_picture') final String? profilePicture,
    @JsonKey(name: 'patrimonial_condition_id')
    final int? patrimonialConditionId,
    @JsonKey(name: 'can_edit_sensitive_data') final bool canEditSensitiveData,
    @JsonKey(name: 'personal_address')
    final Map<String, dynamic>? personalAddress,
    @JsonKey(name: 'fiscal_data') final Map<String, dynamic>? fiscalData,
    required final ProfileSettingsModel settings,
    @JsonKey(name: 'associated_members')
    final List<SubMemberModel> associatedMembers,
    @JsonKey(name: 'legal_beneficiaries')
    final List<Map<String, dynamic>> legalBeneficiaries,
    @JsonKey(name: 'vehicles') final List<Map<String, dynamic>> vehicles,
  }) = _$ProfileModelImpl;

  factory _ProfileModel.fromJson(Map<String, dynamic> json) =
      _$ProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get entityid;
  @override
  String get fullname;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get rfc;
  @override
  String? get curp;
  @override
  String? get address;
  @override
  @JsonKey(name: 'birth_date')
  String? get birthDate;
  @override
  int? get age;
  @override
  @JsonKey(name: 'profile_picture')
  String? get profilePicture;
  @override
  @JsonKey(name: 'patrimonial_condition_id')
  int? get patrimonialConditionId;
  @override
  @JsonKey(name: 'can_edit_sensitive_data')
  bool get canEditSensitiveData;
  @override
  @JsonKey(name: 'personal_address')
  Map<String, dynamic>? get personalAddress;
  @override
  @JsonKey(name: 'fiscal_data')
  Map<String, dynamic>? get fiscalData;
  @override
  ProfileSettingsModel get settings;
  @override
  @JsonKey(name: 'associated_members')
  List<SubMemberModel> get associatedMembers;
  @override
  @JsonKey(name: 'legal_beneficiaries')
  List<Map<String, dynamic>> get legalBeneficiaries;
  @override
  @JsonKey(name: 'vehicles')
  List<Map<String, dynamic>> get vehicles;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
