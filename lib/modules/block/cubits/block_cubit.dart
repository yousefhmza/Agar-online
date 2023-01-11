import 'package:agar_online/modules/block/cubits/block_states.dart';
import 'package:agar_online/modules/block/repositories/block_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlockCubit extends Cubit<BlockStates> {
  final BlockRepository blockRepository;

  BlockCubit(this.blockRepository) : super(BlockInitialState());

  List<int> blockedUsersIds = [];

  Future<void> getBlockList() async {
    emit(GetBlockListLoadingState());
    final result = await blockRepository.getBlockList();
    result.fold(
      (failure) => emit(GetBlockListFailureState(failure)),
      (blockedUsersIds) {
        this.blockedUsersIds = blockedUsersIds;
        emit(GetBlockListSuccessState());
      },
    );
  }

  Future<void> blockUser(int userId) async {
    emit(SetBlockLoadingState());
    final result = await blockRepository.blockUser(userId);
    result.fold(
      (failure) => emit(SetBlockFailureState(failure)),
      (message) => emit(SetBlockSuccessState(message)),
    );
  }

  Future<void> unblockUser(int userId) async {
    emit(SetBlockLoadingState());
    final result = await blockRepository.unblockUser(userId);
    result.fold(
      (failure) => emit(SetBlockFailureState(failure)),
      (message) => emit(SetBlockSuccessState(message)),
    );
  }
}
