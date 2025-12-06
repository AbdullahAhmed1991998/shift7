import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

sealed class AppState extends Equatable {
  final Locale locale;
  const AppState({required this.locale});

  @override
  List<Object> get props => [locale];

  AppState copyWith({Locale? locale}) {
    return AppInitial(locale: locale ?? this.locale);
  }
}

final class AppInitial extends AppState {
  const AppInitial({required super.locale});
}
