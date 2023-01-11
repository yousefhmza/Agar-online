import 'package:agar_online/core/services/error/failure.dart';

abstract class BlockStates {}

class BlockInitialState extends BlockStates {}

class GetBlockListLoadingState extends BlockStates {}

class GetBlockListFailureState extends BlockStates {
  final Failure failure;

  GetBlockListFailureState(this.failure);
}

class GetBlockListSuccessState extends BlockStates {}

class SetBlockLoadingState extends BlockStates {}

class SetBlockFailureState extends BlockStates {
  final Failure failure;

  SetBlockFailureState(this.failure);
}

class SetBlockSuccessState extends BlockStates {
  final String message;

  SetBlockSuccessState(this.message);
}
