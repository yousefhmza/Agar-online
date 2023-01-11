import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:agar_online/modules/help_center/cubits/help_center_states.dart';
import 'package:agar_online/modules/help_center/models/body/help_center_message_body.dart';
import 'package:agar_online/modules/help_center/repositories/help_center_repository.dart';

class HelpCenterCubit extends Cubit<HelpCenterStates> {
  final HelpCenterRepository _helpCenterRepository;

  HelpCenterCubit(this._helpCenterRepository) : super(HelpCenterInitialState());

  HelpCenterMessageBody helpCenterMessageBody = HelpCenterMessageBody();

  Future<void> sendHelpCenterMessage() async {
    emit(SendHelpCenterMessageLoadingState());
    final result = await _helpCenterRepository.sendHelpCenterMessage(helpCenterMessageBody);
    result.fold(
      (failure) => emit(SendHelpCenterMessageFailureState(failure)),
      (message) => emit(SendHelpCenterMessageSuccessState(message)),
    );
  }
}
