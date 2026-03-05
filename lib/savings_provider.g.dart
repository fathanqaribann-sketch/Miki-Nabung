// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavingsTarget _$SavingsTargetFromJson(Map<String, dynamic> json) =>
    SavingsTarget(
      id: json['id'] as String,
      title: json['title'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      targetDate: DateTime.parse(json['targetDate'] as String),
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SavingsTargetToJson(SavingsTarget instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'totalAmount': instance.totalAmount,
      'targetDate': instance.targetDate.toIso8601String(),
      'currentAmount': instance.currentAmount,
    };
