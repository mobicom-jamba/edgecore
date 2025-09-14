// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_prefs.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserPrefsCollection on Isar {
  IsarCollection<UserPrefs> get userPrefs => this.collection();
}

const UserPrefsSchema = CollectionSchema(
  name: r'UserPrefs',
  id: -38711120304771490,
  properties: {
    r'bedtimeHour': PropertySchema(
      id: 0,
      name: r'bedtimeHour',
      type: IsarType.long,
    ),
    r'bedtimeMinute': PropertySchema(
      id: 1,
      name: r'bedtimeMinute',
      type: IsarType.long,
    ),
    r'buddyName': PropertySchema(
      id: 2,
      name: r'buddyName',
      type: IsarType.string,
    ),
    r'buddyPhone': PropertySchema(
      id: 3,
      name: r'buddyPhone',
      type: IsarType.string,
    ),
    r'chronotype': PropertySchema(
      id: 4,
      name: r'chronotype',
      type: IsarType.string,
    ),
    r'hasCompletedOnboarding': PropertySchema(
      id: 5,
      name: r'hasCompletedOnboarding',
      type: IsarType.bool,
    ),
    r'highContrast': PropertySchema(
      id: 6,
      name: r'highContrast',
      type: IsarType.bool,
    ),
    r'lofiSoundEnabled': PropertySchema(
      id: 7,
      name: r'lofiSoundEnabled',
      type: IsarType.bool,
    ),
    r'notificationsEnabled': PropertySchema(
      id: 8,
      name: r'notificationsEnabled',
      type: IsarType.bool,
    ),
    r'reduceMotion': PropertySchema(
      id: 9,
      name: r'reduceMotion',
      type: IsarType.bool,
    ),
    r'selectedRituals': PropertySchema(
      id: 10,
      name: r'selectedRituals',
      type: IsarType.stringList,
    ),
    r'timezone': PropertySchema(
      id: 11,
      name: r'timezone',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'wakeTimeHour': PropertySchema(
      id: 13,
      name: r'wakeTimeHour',
      type: IsarType.long,
    ),
    r'wakeTimeMinute': PropertySchema(
      id: 14,
      name: r'wakeTimeMinute',
      type: IsarType.long,
    )
  },
  estimateSize: _userPrefsEstimateSize,
  serialize: _userPrefsSerialize,
  deserialize: _userPrefsDeserialize,
  deserializeProp: _userPrefsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userPrefsGetId,
  getLinks: _userPrefsGetLinks,
  attach: _userPrefsAttach,
  version: '3.1.0+1',
);

int _userPrefsEstimateSize(
  UserPrefs object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.buddyName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.buddyPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.chronotype;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.selectedRituals.length * 3;
  {
    for (var i = 0; i < object.selectedRituals.length; i++) {
      final value = object.selectedRituals[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.timezone.length * 3;
  return bytesCount;
}

void _userPrefsSerialize(
  UserPrefs object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.bedtimeHour);
  writer.writeLong(offsets[1], object.bedtimeMinute);
  writer.writeString(offsets[2], object.buddyName);
  writer.writeString(offsets[3], object.buddyPhone);
  writer.writeString(offsets[4], object.chronotype);
  writer.writeBool(offsets[5], object.hasCompletedOnboarding);
  writer.writeBool(offsets[6], object.highContrast);
  writer.writeBool(offsets[7], object.lofiSoundEnabled);
  writer.writeBool(offsets[8], object.notificationsEnabled);
  writer.writeBool(offsets[9], object.reduceMotion);
  writer.writeStringList(offsets[10], object.selectedRituals);
  writer.writeString(offsets[11], object.timezone);
  writer.writeDateTime(offsets[12], object.updatedAt);
  writer.writeLong(offsets[13], object.wakeTimeHour);
  writer.writeLong(offsets[14], object.wakeTimeMinute);
}

UserPrefs _userPrefsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserPrefs();
  object.bedtimeHour = reader.readLong(offsets[0]);
  object.bedtimeMinute = reader.readLong(offsets[1]);
  object.buddyName = reader.readStringOrNull(offsets[2]);
  object.buddyPhone = reader.readStringOrNull(offsets[3]);
  object.chronotype = reader.readStringOrNull(offsets[4]);
  object.hasCompletedOnboarding = reader.readBool(offsets[5]);
  object.highContrast = reader.readBool(offsets[6]);
  object.id = id;
  object.lofiSoundEnabled = reader.readBool(offsets[7]);
  object.notificationsEnabled = reader.readBool(offsets[8]);
  object.reduceMotion = reader.readBool(offsets[9]);
  object.selectedRituals = reader.readStringList(offsets[10]) ?? [];
  object.timezone = reader.readString(offsets[11]);
  object.updatedAt = reader.readDateTime(offsets[12]);
  object.wakeTimeHour = reader.readLong(offsets[13]);
  object.wakeTimeMinute = reader.readLong(offsets[14]);
  return object;
}

P _userPrefsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readStringList(offset) ?? []) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTime(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userPrefsGetId(UserPrefs object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userPrefsGetLinks(UserPrefs object) {
  return [];
}

void _userPrefsAttach(IsarCollection<dynamic> col, Id id, UserPrefs object) {
  object.id = id;
}

extension UserPrefsQueryWhereSort
    on QueryBuilder<UserPrefs, UserPrefs, QWhere> {
  QueryBuilder<UserPrefs, UserPrefs, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserPrefsQueryWhere
    on QueryBuilder<UserPrefs, UserPrefs, QWhereClause> {
  QueryBuilder<UserPrefs, UserPrefs, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserPrefsQueryFilter
    on QueryBuilder<UserPrefs, UserPrefs, QFilterCondition> {
  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> bedtimeHourEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bedtimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      bedtimeHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bedtimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> bedtimeHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bedtimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> bedtimeHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bedtimeHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      bedtimeMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bedtimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      bedtimeMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bedtimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      bedtimeMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bedtimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      bedtimeMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bedtimeMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'buddyName',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      buddyNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'buddyName',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'buddyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      buddyNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'buddyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'buddyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'buddyName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'buddyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'buddyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'buddyName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'buddyName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'buddyName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      buddyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'buddyName',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'buddyPhone',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      buddyPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'buddyPhone',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyPhoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'buddyPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      buddyPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'buddyPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'buddyPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'buddyPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      buddyPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'buddyPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'buddyPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyPhoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'buddyPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> buddyPhoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'buddyPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      buddyPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'buddyPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      buddyPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'buddyPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> chronotypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chronotype',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      chronotypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chronotype',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> chronotypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      chronotypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> chronotypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> chronotypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chronotype',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      chronotypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> chronotypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> chronotypeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chronotype',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> chronotypeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chronotype',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      chronotypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chronotype',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      chronotypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chronotype',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      hasCompletedOnboardingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasCompletedOnboarding',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> highContrastEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highContrast',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      lofiSoundEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lofiSoundEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      notificationsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notificationsEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> reduceMotionEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reduceMotion',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedRituals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedRituals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedRituals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedRituals',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedRituals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedRituals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedRituals',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedRituals',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedRituals',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedRituals',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedRituals',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedRituals',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedRituals',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedRituals',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedRituals',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      selectedRitualsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'selectedRituals',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timezone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'timezone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'timezone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> timezoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timezone',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      timezoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'timezone',
        value: '',
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> wakeTimeHourEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      wakeTimeHourGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      wakeTimeHourLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeTimeHour',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition> wakeTimeHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeTimeHour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      wakeTimeMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      wakeTimeMinuteGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      wakeTimeMinuteLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeTimeMinute',
        value: value,
      ));
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterFilterCondition>
      wakeTimeMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeTimeMinute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension UserPrefsQueryObject
    on QueryBuilder<UserPrefs, UserPrefs, QFilterCondition> {}

extension UserPrefsQueryLinks
    on QueryBuilder<UserPrefs, UserPrefs, QFilterCondition> {}

extension UserPrefsQuerySortBy on QueryBuilder<UserPrefs, UserPrefs, QSortBy> {
  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByBedtimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeHour', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByBedtimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeHour', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByBedtimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeMinute', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByBedtimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeMinute', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByBuddyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buddyName', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByBuddyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buddyName', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByBuddyPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buddyPhone', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByBuddyPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buddyPhone', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByChronotype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chronotype', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByChronotypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chronotype', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      sortByHasCompletedOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedOnboarding', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      sortByHasCompletedOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedOnboarding', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByHighContrast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highContrast', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByHighContrastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highContrast', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByLofiSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lofiSoundEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      sortByLofiSoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lofiSoundEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      sortByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      sortByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByReduceMotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reduceMotion', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByReduceMotionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reduceMotion', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByWakeTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeHour', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByWakeTimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeHour', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByWakeTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeMinute', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> sortByWakeTimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeMinute', Sort.desc);
    });
  }
}

extension UserPrefsQuerySortThenBy
    on QueryBuilder<UserPrefs, UserPrefs, QSortThenBy> {
  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByBedtimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeHour', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByBedtimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeHour', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByBedtimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeMinute', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByBedtimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedtimeMinute', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByBuddyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buddyName', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByBuddyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buddyName', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByBuddyPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buddyPhone', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByBuddyPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buddyPhone', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByChronotype() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chronotype', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByChronotypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chronotype', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      thenByHasCompletedOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedOnboarding', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      thenByHasCompletedOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedOnboarding', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByHighContrast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highContrast', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByHighContrastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highContrast', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByLofiSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lofiSoundEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      thenByLofiSoundEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lofiSoundEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      thenByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy>
      thenByNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByReduceMotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reduceMotion', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByReduceMotionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reduceMotion', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timezone', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByWakeTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeHour', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByWakeTimeHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeHour', Sort.desc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByWakeTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeMinute', Sort.asc);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QAfterSortBy> thenByWakeTimeMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTimeMinute', Sort.desc);
    });
  }
}

extension UserPrefsQueryWhereDistinct
    on QueryBuilder<UserPrefs, UserPrefs, QDistinct> {
  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByBedtimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bedtimeHour');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByBedtimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bedtimeMinute');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByBuddyName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'buddyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByBuddyPhone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'buddyPhone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByChronotype(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chronotype', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct>
      distinctByHasCompletedOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasCompletedOnboarding');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByHighContrast() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highContrast');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByLofiSoundEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lofiSoundEnabled');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct>
      distinctByNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notificationsEnabled');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByReduceMotion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reduceMotion');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctBySelectedRituals() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedRituals');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByTimezone(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timezone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByWakeTimeHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeTimeHour');
    });
  }

  QueryBuilder<UserPrefs, UserPrefs, QDistinct> distinctByWakeTimeMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeTimeMinute');
    });
  }
}

extension UserPrefsQueryProperty
    on QueryBuilder<UserPrefs, UserPrefs, QQueryProperty> {
  QueryBuilder<UserPrefs, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserPrefs, int, QQueryOperations> bedtimeHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bedtimeHour');
    });
  }

  QueryBuilder<UserPrefs, int, QQueryOperations> bedtimeMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bedtimeMinute');
    });
  }

  QueryBuilder<UserPrefs, String?, QQueryOperations> buddyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'buddyName');
    });
  }

  QueryBuilder<UserPrefs, String?, QQueryOperations> buddyPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'buddyPhone');
    });
  }

  QueryBuilder<UserPrefs, String?, QQueryOperations> chronotypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chronotype');
    });
  }

  QueryBuilder<UserPrefs, bool, QQueryOperations>
      hasCompletedOnboardingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasCompletedOnboarding');
    });
  }

  QueryBuilder<UserPrefs, bool, QQueryOperations> highContrastProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highContrast');
    });
  }

  QueryBuilder<UserPrefs, bool, QQueryOperations> lofiSoundEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lofiSoundEnabled');
    });
  }

  QueryBuilder<UserPrefs, bool, QQueryOperations>
      notificationsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notificationsEnabled');
    });
  }

  QueryBuilder<UserPrefs, bool, QQueryOperations> reduceMotionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reduceMotion');
    });
  }

  QueryBuilder<UserPrefs, List<String>, QQueryOperations>
      selectedRitualsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedRituals');
    });
  }

  QueryBuilder<UserPrefs, String, QQueryOperations> timezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timezone');
    });
  }

  QueryBuilder<UserPrefs, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<UserPrefs, int, QQueryOperations> wakeTimeHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeTimeHour');
    });
  }

  QueryBuilder<UserPrefs, int, QQueryOperations> wakeTimeMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeTimeMinute');
    });
  }
}
