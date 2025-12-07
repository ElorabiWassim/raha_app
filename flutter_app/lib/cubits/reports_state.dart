import 'package:equatable/equatable.dart';
import '../data/models/report.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<Report> reports;
  final String? activeFilter;

  const ReportsLoaded(this.reports, {this.activeFilter});

  @override
  List<Object?> get props => [reports, activeFilter];
}

class ReportDetailsLoaded extends ReportsState {
  final Report report;

  const ReportDetailsLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportStatusUpdating extends ReportsState {}

class ReportStatusUpdated extends ReportsState {
  final String message;

  const ReportStatusUpdated(this.message);

  @override
  List<Object?> get props => [message];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
