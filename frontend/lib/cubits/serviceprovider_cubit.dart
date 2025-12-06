import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/serviceprovider_data.dart';

// States
abstract class ServiceProviderState {}

class ServiceProviderInitial extends ServiceProviderState {}

class ServiceProviderLoaded extends ServiceProviderState {
  final ServiceProvider provider;
  
  ServiceProviderLoaded(this.provider);
}

class ServiceProviderUpdating extends ServiceProviderState {}

class ServiceProviderUpdated extends ServiceProviderState {
  final ServiceProvider provider;
  final String message;
  
  ServiceProviderUpdated(this.provider, this.message);
}

class ServiceProviderError extends ServiceProviderState {
  final String message;
  
  ServiceProviderError(this.message);
}


class ServiceProviderCubit extends Cubit<ServiceProviderState> {
  ServiceProvider? _provider;
  
  ServiceProviderCubit() : super(ServiceProviderInitial());
  
  void initializeProvider(ServiceProvider provider) {
    _provider = provider;
    emit(ServiceProviderLoaded(provider));
  }
  
  void updateProfile({
    String? name,
    String? profession,
    String? location,
    String? experience,
  }) {
    if (_provider == null) return;
    
    emit(ServiceProviderUpdating());
    
    try {
      if (name != null) _provider!.name = name;
      if (profession != null) _provider!.profession = profession;
      if (location != null) _provider!.location = location;
      if (experience != null) _provider!.experience = experience;
      
      emit(ServiceProviderUpdated(_provider!, 'Profile updated successfully'));
      
      Future.delayed(Duration(milliseconds: 500), () {
        emit(ServiceProviderLoaded(_provider!));
      });
    } catch (e) {
      emit(ServiceProviderError('Failed to update profile: $e'));
      if (_provider != null) {
        emit(ServiceProviderLoaded(_provider!));
      }
    }
  }
  
  void addService(Service service) {
    if (_provider == null) return;
    
    emit(ServiceProviderUpdating());
    
    try {
      _provider!.services.add(service);
      emit(ServiceProviderUpdated(_provider!, 'Service added successfully'));
      
      Future.delayed(Duration(milliseconds: 500), () {
        emit(ServiceProviderLoaded(_provider!));
      });
    } catch (e) {
      emit(ServiceProviderError('Failed to add service: $e'));
      if (_provider != null) {
        emit(ServiceProviderLoaded(_provider!));
      }
    }
  }
  
  void updateService(int index, Service updatedService) {
    if (_provider == null || index >= _provider!.services.length) return;
    
    emit(ServiceProviderUpdating());
    
    try {
      _provider!.services[index] = updatedService;
      emit(ServiceProviderUpdated(_provider!, 'Service updated successfully'));
      
      Future.delayed(Duration(milliseconds: 500), () {
        emit(ServiceProviderLoaded(_provider!));
      });
    } catch (e) {
      emit(ServiceProviderError('Failed to update service: $e'));
      if (_provider != null) {
        emit(ServiceProviderLoaded(_provider!));
      }
    }
  }
  
  void deleteService(int index) {
    if (_provider == null || index >= _provider!.services.length) return;
    
    emit(ServiceProviderUpdating());
    
    try {
      _provider!.services.removeAt(index);
      emit(ServiceProviderUpdated(_provider!, 'Service deleted successfully'));
      
      Future.delayed(Duration(milliseconds: 500), () {
        emit(ServiceProviderLoaded(_provider!));
      });
    } catch (e) {
      emit(ServiceProviderError('Failed to delete service: $e'));
      if (_provider != null) {
        emit(ServiceProviderLoaded(_provider!));
      }
    }
  }
  
  void toggleServiceStatus(int index) {
    if (_provider == null || index >= _provider!.services.length) return;
    
    emit(ServiceProviderUpdating());
    
    try {
      _provider!.services[index].isActive = !_provider!.services[index].isActive;
      emit(ServiceProviderUpdated(_provider!, 'Service status updated'));
      
      Future.delayed(Duration(milliseconds: 500), () {
        emit(ServiceProviderLoaded(_provider!));
      });
    } catch (e) {
      emit(ServiceProviderError('Failed to toggle service status: $e'));
      if (_provider != null) {
        emit(ServiceProviderLoaded(_provider!));
      }
    }
  }
  
  ServiceProvider? get provider => _provider;
}