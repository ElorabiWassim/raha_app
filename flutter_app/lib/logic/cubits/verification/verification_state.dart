import 'package:equatable/equatable.dart';

abstract class VerificationState extends Equatable {
  const VerificationState();

  @override
  List<Object> get props => [];
}

class VerificationInitial extends VerificationState {
  final bool idUploaded;
  final bool certUploaded;
  final bool photoUploaded;

  const VerificationInitial({
    this.idUploaded = false,
    this.certUploaded = false,
    this.photoUploaded = false,
  });

  @override
  List<Object> get props => [idUploaded, certUploaded, photoUploaded];

  VerificationInitial copyWith({
    bool? idUploaded,
    bool? certUploaded,
    bool? photoUploaded,
  }) {
    return VerificationInitial(
      idUploaded: idUploaded ?? this.idUploaded,
      certUploaded: certUploaded ?? this.certUploaded,
      photoUploaded: photoUploaded ?? this.photoUploaded,
    );
  }
}

class VerificationSubmitting extends VerificationState {}

class VerificationSuccess extends VerificationState {}

class VerificationFailure extends VerificationState {
  final String message;

  const VerificationFailure(this.message);

  @override
  List<Object> get props => [message];
}
