import 'package:equatable/equatable.dart';

abstract class SendOfferState extends Equatable {
  const SendOfferState();

  @override
  List<Object?> get props => [];
}

class SendOfferInitial extends SendOfferState {}

class SendOfferLoading extends SendOfferState {}

class SendOfferSuccess extends SendOfferState {
  final String message;

  const SendOfferSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class SendOfferError extends SendOfferState {
  final String message;

  const SendOfferError(this.message);

  @override
  List<Object?> get props => [message];
}
