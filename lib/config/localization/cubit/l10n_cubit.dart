import '../l10n/l10n.dart';
import '../../../core/services/local/storage_keys.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/local/cache_consumer.dart';
import 'l10n_states.dart';

class L10nCubit extends Cubit<L10nStates> {
  final CacheConsumer _cacheConsumer;

  L10nCubit(this._cacheConsumer) : super(L10nInitialState());

  Locale? appLocale;

  void initLocale() {
    dynamic storedLocale = _cacheConsumer.get(StorageKeys.appLocale);
    appLocale = storedLocale != null ? Locale(storedLocale.toString()) : null;
  }

  Future<void> setAppLocale(bool isArabic) async {
    if (isArabic) {
      appLocale = L10n.supportedLocales[1];
      await _cacheConsumer.save(StorageKeys.appLocale, "ar");
    } else {
      appLocale = L10n.supportedLocales[0];
      await _cacheConsumer.save(StorageKeys.appLocale, "en");
    }
    emit(L10nSetLangState());
  }
}
