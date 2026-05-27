# CLAUDE.md

Guidance for working in this repository.

## Project

**Nepal IPO Auto-Apply App** — a Flutter mobile app that automatically applies for IPOs on
**MeroShare** (Nepal's official CDSC IPO platform: `https://meroshare.cdsc.com.np/api/v2`)
across multiple user accounts with no manual interaction. Users store MeroShare credentials
(encrypted on-device). When an IPO opens, the app logs into every enabled account and submits
an application; users get push notifications on IPO open and allotment results.

## Commands

```bash
flutter pub get                       # install deps
dart run build_runner build --delete-conflicting-outputs   # regenerate *.g.dart (Hive + JSON)
dart run build_runner watch --delete-conflicting-outputs   # regen on save
flutter analyze                       # static analysis (must be clean)
flutter test                          # all tests
flutter test test/unit/...            # a single test file
flutter run                           # run on connected device/emulator
```

Run `build_runner` after editing any Hive model or `json_serializable` model.

## Architecture — Clean Architecture + Riverpod

Strict layering. **UI never touches the data layer directly.**

```
presentation (screens, widgets, Riverpod providers)
      ↓ depends on
domain (entities, repository interfaces, usecases)   ← pure Dart, no Flutter/Dio/Hive
      ↑ implemented by
data (models, datasources, repository impls)
```

- `lib/core/` — cross-cutting infra: constants, errors, theme, network (Dio), storage
  (Hive + secure storage + prefs), services (notifications, background, biometric,
  auto-apply), router (GoRouter), `di/providers.dart` (top-level Riverpod registrations), utils.
- `lib/shared/` — `enums/`, `widgets/` (only if used in 3+ features), `mixins/`.
- `lib/features/<feature>/{data,domain,presentation}/` — one folder per feature:
  `auth`, `accounts`, `ipo`, `results`, `dashboard`, `history`, `settings`.

## Hard rules

1. **Riverpod only** for state — no `setState`, BLoC, GetX, or get_it. Providers are
   top-level `final` (declared at file scope, never inside a class).
2. **`Either<Failure, T>`** (dartz) is the return type of every repository method. The
   presentation layer must handle both `Left` and `Right`.
3. **No business logic in widgets** — it lives in usecases or services.
4. **Features never import each other's _presentation_ layer.** Share UI via
   `lib/shared/` and `lib/core/`. Narrow exception: cross-cutting **domain**
   orchestration may compose other features' domain contracts — e.g.
   `ipo/.../bulk_apply_ipo_usecase.dart` uses `auth` + `accounts` domain, and
   `core/services/auto_apply_service.dart` and the dashboard aggregate across
   features. Never reach into another feature's `data/` or `presentation/`
   internals for business logic.
5. **No hardcoded strings** — use `lib/core/constants/`.
6. **GoRouter for all navigation** — no direct `Navigator.push`. Route names in
   `route_names.dart`.
7. **No `print()`** — use the `logger` wrapper in `lib/core/utils/logger.dart`.
8. **Background tasks run in a separate isolate** (`workmanager`): dependencies must be
   re-initialized manually inside `callbackDispatcher`.
9. **Hive type IDs are fixed:** accounts = 0, ipoApplications = 1, ipoListings = 2.
   Never reuse or reorder.

## Security (non-negotiable)

- Passwords/tokens live **only** in `flutter_secure_storage` (Android Keystore / iOS Keychain).
  Keys: password = `pwd_{accountId}`, token = `token_{accountId}`. Never in Hive, logs, or `.env`.
- **Never log passwords or tokens.** Never `print` credentials.
- Credentials are sent **only** to `meroshare.cdsc.com.np`. The optional backend stores FCM
  tokens for push notifications and **never** receives credentials.
- App-level biometric / PIN lock via `local_auth`.

## MeroShare API (base `https://meroshare.cdsc.com.np/api/v2`)

| Action | Method | Endpoint |
|---|---|---|
| Login | POST | `/auth/loginWithClientId/{dpId}` (body: clientId, username, password) |
| List open IPOs | GET | `/meroShare/applicable/` |
| Apply | POST | `/share/apply/` (companyShareId, crnNumber, customerId, demat, quantity) |
| Check applied | GET | `/myPurchase/myShare/` |
| Result | GET | `/report/{companyShareId}/` |
| DP list | GET | `/meroShare/capital/` |
| Bank list | GET | `/bankRequest/` |

Auth: JWT Bearer. Login returns `{ "token": "..." }`; attach as `Authorization: Bearer {token}`.

## Auto-apply flow

Background task (every ~2h) → fetch open IPOs → for each open IPO, for each account with
`autoApplyEnabled` → login → check already applied → if not, POST apply (qty=10) → persist
`ApplicationEntity` to Hive → local notification. Errors persist with `status=error` + message.

## Conventions

- `Either<Failure, T>` everywhere in repositories; map `DioException` → `Failure` in
  `core/errors/error_handler.dart`.
- Models (`data/`) extend/convert to entities (`domain/`); entities use `equatable`.
- User-facing strings in sentence case.
- Generated files (`*.g.dart`) are committed but never hand-edited.

## Notes / known deviations

- Codegen for Riverpod (`riverpod_generator`) is **not** used — providers are written
  manually. Only Hive + JSON use `build_runner`.
- Firebase requires platform config (`google-services.json` / `GoogleService-Info.plist`)
  to run on-device; code compiles and analyzes without it, but FCM is inert until configured.
- The Python FastAPI backend described in the design doc is optional and not yet scaffolded.
