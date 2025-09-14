// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nudge_event.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNudgeEventCollection on Isar {
  IsarCollection<NudgeEvent> get nudgeEvents => this.collection();
}

const NudgeEventSchema = CollectionSchema(
  name: r'NudgeEvent',
  id: 2362166997978703443,
  properties: {
    r'notes': PropertySchema(
      id: 0,
      name: r'notes',
      type: IsarType.string,
    ),
    r'nudgeKindIndex': PropertySchema(
      id: 1,
      name: r'nudgeKindIndex',
      type: IsarType.long,
    ),
    r'ritualCompleted': PropertySchema(
      id: 2,
      name: r'ritualCompleted',
      type: IsarType.bool,
    ),
    r'timestamp': PropertySchema(
      id: 3,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _nudgeEventEstimateSize,
  serialize: _nudgeEventSerialize,
  deserialize: _nudgeEventDeserialize,
  deserializeProp: _nudgeEventDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _nudgeEventGetId,
  getLinks: _nudgeEventGetLinks,
  attach: _nudgeEventAttach,
  version: '3.1.0+1',
);

int _nudgeEventEstimateSize(
  NudgeEvent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _nudgeEventSerialize(
  NudgeEvent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.notes);
  writer.writeLong(offsets[1], object.nudgeKindIndex);
  writer.writeBool(offsets[2], object.ritualCompleted);
  writer.writeDateTime(offsets[3], object.timestamp);
}

NudgeEvent _nudgeEventDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NudgeEvent();
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[0]);
  object.nudgeKindIndex = reader.readLong(offsets[1]);
  object.ritualCompleted = reader.readBool(offsets[2]);
  object.timestamp = reader.readDateTime(offsets[3]);
  return object;
}

P _nudgeEventDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _nudgeEventGetId(NudgeEvent object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _nudgeEventGetLinks(NudgeEvent object) {
  return [];
}

void _nudgeEventAttach(IsarCollection<dynamic> col, Id id, NudgeEvent object) {
  object.id = id;
}

extension NudgeEventQueryWhereSort
    on QueryBuilder<NudgeEvent, NudgeEvent, QWhere> {
  QueryBuilder<NudgeEvent, NudgeEvent, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NudgeEventQueryWhere
    on QueryBuilder<NudgeEvent, NudgeEvent, QWhereClause> {
  QueryBuilder<NudgeEvent, NudgeEvent, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterWhereClause> idBetween(
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

extension NudgeEventQueryFilter
    on QueryBuilder<NudgeEvent, NudgeEvent, QFilterCondition> {
  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> idBetween(
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

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition>
      nudgeKindIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nudgeKindIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition>
      nudgeKindIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nudgeKindIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition>
      nudgeKindIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nudgeKindIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition>
      nudgeKindIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nudgeKindIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition>
      ritualCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ritualCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NudgeEventQueryObject
    on QueryBuilder<NudgeEvent, NudgeEvent, QFilterCondition> {}

extension NudgeEventQueryLinks
    on QueryBuilder<NudgeEvent, NudgeEvent, QFilterCondition> {}

extension NudgeEventQuerySortBy
    on QueryBuilder<NudgeEvent, NudgeEvent, QSortBy> {
  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> sortByNudgeKindIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nudgeKindIndex', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy>
      sortByNudgeKindIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nudgeKindIndex', Sort.desc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> sortByRitualCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ritualCompleted', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy>
      sortByRitualCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ritualCompleted', Sort.desc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension NudgeEventQuerySortThenBy
    on QueryBuilder<NudgeEvent, NudgeEvent, QSortThenBy> {
  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> thenByNudgeKindIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nudgeKindIndex', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy>
      thenByNudgeKindIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nudgeKindIndex', Sort.desc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> thenByRitualCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ritualCompleted', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy>
      thenByRitualCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ritualCompleted', Sort.desc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension NudgeEventQueryWhereDistinct
    on QueryBuilder<NudgeEvent, NudgeEvent, QDistinct> {
  QueryBuilder<NudgeEvent, NudgeEvent, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QDistinct> distinctByNudgeKindIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nudgeKindIndex');
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QDistinct> distinctByRitualCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ritualCompleted');
    });
  }

  QueryBuilder<NudgeEvent, NudgeEvent, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension NudgeEventQueryProperty
    on QueryBuilder<NudgeEvent, NudgeEvent, QQueryProperty> {
  QueryBuilder<NudgeEvent, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NudgeEvent, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<NudgeEvent, int, QQueryOperations> nudgeKindIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nudgeKindIndex');
    });
  }

  QueryBuilder<NudgeEvent, bool, QQueryOperations> ritualCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ritualCompleted');
    });
  }

  QueryBuilder<NudgeEvent, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
