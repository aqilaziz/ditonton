import 'package:flutter_bloc/flutter_bloc.dart';

mixin LegacyCubitListener<S> on Cubit<S> {
  final _listeners = <void Function()>[];

  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  @override
  void onChange(Change<S> change) {
    super.onChange(change);
    for (final listener in List.of(_listeners)) {
      listener();
    }
  }
}
