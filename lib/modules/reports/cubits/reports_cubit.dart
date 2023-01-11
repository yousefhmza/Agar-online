import 'package:agar_online/modules/reports/cubits/reports_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/body/report_ad_body.dart';
import '../repositories/reports_repository.dart';

class ReportsCubit extends Cubit<ReportsStates> {
  final ReportsRepository _reportsRepository;

  ReportsCubit(this._reportsRepository) : super(ReportsInitialState());

  Future<void> reportAd(ReportAdBody reportAdBody) async {
    emit(ReportLoadingState());
    final result = await _reportsRepository.reportAd(reportAdBody);
    result.fold(
      (failure) => emit(ReportFailureState(failure)),
      (message) => emit(ReportSuccessState(message)),
    );
  }

  Future<void> reportUser(int userId, String message) async {
    emit(ReportLoadingState());
    final result = await _reportsRepository.reportUser(userId, message);
    result.fold(
      (failure) => emit(ReportFailureState(failure)),
      (message) => emit(ReportSuccessState(message)),
    );
  }
}
