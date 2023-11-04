part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AppChangeBottomNavBarState extends AppState {}

class AppChangeBottomSheetBarState extends AppState {}

class AppCreatDataBaseState extends AppState {}

class AppGetDataBaseLoadingState extends AppState {}

class AppUpdateDataBaseState extends AppState {}

class AppDeletDataBaseState extends AppState {}

class AppDeletDataState extends AppState {}

class AppGetDataBaseState extends AppState {}

class AppInsertDataBaseState extends AppState {}
