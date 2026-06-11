# Ditonton

[![Flutter CI](https://github.com/aqilaziz/ditonton/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/aqilaziz/ditonton/actions/workflows/flutter-ci.yml)

Submission akhir kelas Menjadi Flutter Developer Expert.

## Fitur

- Movie: now playing, popular, top rated, detail, search, recommendation, watchlist.
- TV Series: popular, top rated, airing today, detail, search, recommendation, watchlist.
- Clean Architecture dengan pemisahan data, domain, dan presentation.
- State management menggunakan BLoC/Cubit dari `flutter_bloc`.
- SSL pinning untuk request API TMDB.
- Firebase Analytics dan Crashlytics monitoring dengan konfigurasi Android resmi.
- CI otomatis dengan GitHub Actions.

## Bukti Tambahan

- `screenshots/firebase-analytics-dashboard.png`: Firebase Analytics menampilkan active user.
- `screenshots/firebase-crashlytics-dashboard.png`: Firebase Crashlytics menampilkan crash data.
- `screenshots/github-actions-ci.png`: GitHub Actions berhasil menjalankan format, analyze, dan test.

## Verifikasi

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test --coverage
flutter build apk --debug
```
