import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tv_series_model.dart';

class TvWatchlistLocalDataSource {
  TvWatchlistLocalDataSource(this.preferences);

  static const _key = 'watchlisted_tv_series';
  final SharedPreferences preferences;

  Future<List<TvSeriesModel>> getWatchlist() async {
    final stored = preferences.getStringList(_key) ?? const <String>[];
    return stored
        .map((item) =>
            TvSeriesModel.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<bool> contains(int id) async {
    final items = await getWatchlist();
    return items.any((item) => item.id == id);
  }

  Future<void> add(TvSeriesModel series) async {
    final items = await getWatchlist();
    if (items.any((item) => item.id == series.id)) return;
    items.add(series);
    await _save(items);
  }

  Future<void> remove(int id) async {
    final items = await getWatchlist();
    await _save(items.where((item) => item.id != id).toList());
  }

  Future<void> _save(List<TvSeriesModel> items) {
    return preferences.setStringList(
      _key,
      items.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }
}
