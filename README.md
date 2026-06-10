# Ditonton

[![Flutter CI](https://github.com/aqilaziz/ditonton/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/aqilaziz/ditonton/actions/workflows/flutter-ci.yml)

Submission akhir kelas Menjadi Flutter Developer Expert.

## Fitur

- Movie: now playing, popular, top rated, detail, search, recommendation, watchlist.
- TV Series: popular, top rated, airing today, detail, search, recommendation, watchlist.
- Clean Architecture dengan pemisahan data, domain, dan presentation.
- State management menggunakan BLoC/Cubit dari `flutter_bloc`.
- SSL pinning untuk request API TMDB.
- Firebase Analytics dan Crashlytics monitoring.
- CI otomatis dengan GitHub Actions.

## Verifikasi

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
```
