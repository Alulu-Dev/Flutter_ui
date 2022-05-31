import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:receipt_management/home/wallet/bloc/wallet_event.dart';
import 'package:receipt_management/home/wallet/bloc/wallet_state.dart';
import 'package:receipt_management/home/wallet/repository/wallet_repository.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository = WalletRepository();

  WalletBloc() : super(WalletUnloaded()) {
    on<WalletLoad>(_onWalletLoad);
    on<WalletUnload>(_onWalletUnLoad);
  }

  Future<void> _onWalletUnLoad(
      WalletEvent event, Emitter<WalletState> emit) async {
    emit(WalletUnloaded());
  }

  Future<void> _onWalletLoad(
      WalletEvent event, Emitter<WalletState> emit) async {
    try {
      final receipts = await walletRepository.userWalletRoute();
      emit(WalletLoaded(
        receipts: receipts,
      ));
    } catch (e) {
      if (e == Exception('Not Receipt Object')) {
        emit(WalletFailed(errorMsg: "No receipt Found"));
      }
      if (e == Exception('Receipt Load Failed')) {
        emit(WalletFailed(
            errorMsg:
                "No internet Connection, \nCheck your internet connection and try again!"));
      }
      emit(WalletFailed(errorMsg: "No receipt Found"));
    }
  }
}

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final WalletRepository receiptRepository = WalletRepository();

  ReceiptBloc() : super(ReceiptUnloaded()) {
    on<ReceiptLoad>(_onReceiptLoad);
    on<ReceiptUnload>(_onReceiptUnload);
  }
  Future<void> _onReceiptUnload(
      ReceiptUnload event, Emitter<ReceiptState> emit) async {
    emit(ReceiptUnloaded());
  }

  Future<void> _onReceiptLoad(
      ReceiptLoad event, Emitter<ReceiptState> emit) async {
    try {
      emit(ReceiptLoading());
      final receipt = await receiptRepository.receiptDetails(event.receiptID);
      emit(ReceiptLoaded(receipt: receipt));
    } catch (e) {
      emit(ReceiptFailed(errorMsg: "No receipt Found"));
    }
  }
}

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final WalletRepository requestRepository = WalletRepository();

  RequestBloc() : super(RequestInitial()) {
    on<ReceiptCheckStatus>(_onReceiptCheckStatus);
    on<ReceiptVerify>(_onReceiptVerify);
    on<RequestUnload>(_onRequestUnload);
  }

  Future<void> _onRequestUnload(
      RequestUnload event, Emitter<RequestState> emit) async {
    emit(RequestInitial());
  }

  Future<void> _onReceiptCheckStatus(
      ReceiptCheckStatus event, Emitter<RequestState> emit) async {
    try {
      final _status = await requestRepository
          .receiptVerificationStatusCheck(event.receiptId);
      if (_status == "Request unsent") {
        emit(RequestUnsent());
      } else if (_status == 'true') {
        emit(ReceiptVerified());
      } else if (_status == 'false') {
        emit(RequestSent());
      }
    } catch (e) {
      emit(RequestFailed(errorMsg: 'Request not Sent!'));
    }
  }

  Future<void> _onReceiptVerify(
      ReceiptVerify event, Emitter<RequestState> emit) async {
    try {
      await requestRepository.receiptVerificationRequest(event.receiptId);
      emit(RequestSent());
    } catch (e) {
      emit(RequestFailed(errorMsg: 'Request not Sent!'));
    }
  }
}
