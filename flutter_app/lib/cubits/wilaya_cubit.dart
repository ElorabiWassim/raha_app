import 'package:bloc/bloc.dart';
import '../database/DbHelper.dart';
import '../../data/models/Wilayas.dart';

class WilayaCubit extends Cubit<WilayaState> {
  WilayaCubit() : super(WilayaInitial());

  final dbHelper = DatabaseHelper();

  /// Load wilayas from the database
  Future<void> loadWilayas({required String locale}) async {
    try {
      emit(WilayaLoading());

      final data = await dbHelper.getWilayas();

      final wilayas = data.map((row) {
        return Wilaya(
          name: locale == 'ar' ? row['name_ar'] : row['name_fr'],
          serviceProvidersByCategory: {},
        );
      }).toList();

      emit(WilayaLoaded(wilayas));
    } catch (e) {
      emit(WilayaError('Failed to load wilayas: $e'));
    }
  }
}

abstract class WilayaState {}

class WilayaInitial extends WilayaState {}

class WilayaLoading extends WilayaState {}

class WilayaLoaded extends WilayaState {
  final List<Wilaya> wilayas;

  WilayaLoaded(this.wilayas);
}

class WilayaError extends WilayaState {
  final String message;

  WilayaError(this.message);
}
