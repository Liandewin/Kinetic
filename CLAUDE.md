# Kinetic — Claude Code Guide

Kinetic is a Flutter mobile app: a Strava-like running and workout tracker.

## Stack

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart SDK >=3.3.0) |
| State management | Riverpod (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`) |
| Navigation | `go_router` |
| Backend | Supabase (`supabase_flutter`) |
| Auth | Email/password + Google Sign-In + Sign in with Apple |
| Fonts | `google_fonts` — Inter (UI text) and Lexend (stats/display numbers) |
| Code gen | `build_runner` + `riverpod_generator` |

## Project Structure

```
lib/
  main.dart                        # App entry — loads .env, inits Supabase, wraps in ProviderScope
  app.dart                         # KineticApp — MaterialApp.router consuming routerProvider
  core/
    constants/
      app_colors.dart              # AppColors — all colour tokens
      app_text_styles.dart         # AppTextStyles — named text style constants
    theme/
      app_theme.dart               # AppTheme.light — Material 3 theme
    router/
      app_router.dart              # routerProvider, AppRoutes constants, auth redirect guard
    supabase/
      supabase_client.dart         # supabaseClientProvider, authStateProvider, currentUserProvider
  features/
    auth/
      data/repositories/           # AuthRepository — wraps Supabase auth + Google/Apple sign-in
      presentation/
        providers/                 # authRepositoryProvider, AuthNotifier, authNotifierProvider
        screens/                   # LoginScreen, SignupScreen (outside ShellRoute — no bottom nav)
        widgets/                   # Shared auth form widgets
    home/
      presentation/screens/        # HomeScreen — community feed
    workout/
      presentation/screens/        # StartWorkoutScreen — live clock, START button, bento stats
    achievements/
      presentation/screens/        # AchievementsScreen — daily goal, earned rewards, milestones
    profile/
      presentation/screens/        # ProfileScreen — hero, stats row, goals, settings links
  shared/
    widgets/
      main_shell.dart              # MainShell + _KineticBottomNav — wraps all ShellRoute screens
```

## Architecture Conventions

- **Feature-first folders**: each feature owns `data/`, `domain/`, and `presentation/` sub-folders.
- **Riverpod**: use code-gen providers (`@riverpod` annotation + `build_runner`) for new providers. Legacy `StateNotifierProvider` exists in auth — prefer `AsyncNotifierProvider` for new work.
- **Repository pattern**: data access lives in `data/repositories/`. Providers depend on repository providers, not on Supabase directly.
- **Navigation**: all routes defined in `app_router.dart`. Use `AppRoutes` constants — never hardcode path strings. Auth screens sit outside the `ShellRoute`; all main tabs sit inside it (no transition: `NoTransitionPage`).
- **Auth guard**: the GoRouter `redirect` callback in `routerProvider` enforces auth. It re-evaluates whenever `authStateProvider` emits.

## UI Conventions

### App bar (frosted)
Every main tab screen uses a `_FrostedAppBar` positioned absolutely over a `Stack`. The pattern:
- `BackdropFilter` blur (sigmaX/Y 6), `Color(0xCCF9F9F9)` background, height `64 + topPadding`.
- "KINETIC" wordmark: `GoogleFonts.inter`, `fontSize: 20`, `FontWeight.w900`, `letterSpacing: 4.0`, `color: Colors.black`.
- Scroll content starts with `SliverToBoxAdapter(child: SizedBox(height: 80))` to clear the bar.

### Bottom nav
Frosted, rounded top (`BorderRadius.vertical(top: Radius.circular(32))`), `BackdropFilter` blur 12. Active tab: filled green circle (`AppColors.primary`), black icon. Inactive: transparent, `Color(0xFF6B7280)` icon.

### Typography
- **Headings / section titles**: `GoogleFonts.lexend`, bold–black weights.
- **UI labels / body / captions**: `GoogleFonts.inter`.
- **Stats and large numeric displays**: `GoogleFonts.lexend`, heavy weight.
- Refer to `AppTextStyles` for named styles; inline styles are acceptable for one-off deviations.

### Colours
Always use `AppColors` tokens — never raw hex in widget code. Key tokens:
- `AppColors.primary` — Kinetic Green `#00E639`
- `AppColors.backgroundLight` — `#F9F9F9`
- `AppColors.textPrimary` — `#1A1C1C`
- `AppColors.textSecondary` — `#777777`
- `AppColors.cardWhite` / `AppColors.cardGray` / `AppColors.cardMapBg`

### Cards
Border radius `12`. Shadow: `BoxShadow(color: AppColors.shadowColor.withOpacity(0.04), blurRadius: 32, offset: Offset(0, 24), spreadRadius: -12)`. White or `cardGray` background.

### Progress bars
`ClipRRect(borderRadius: BorderRadius.circular(9999))` wrapping a `LinearProgressIndicator`. Height 2px (subtle) or 4px (prominent).

## Environment

Secrets live in `.env` (gitignored). Loaded via `flutter_dotenv` before `Supabase.initialize`.

Required keys:
```
SUPABASE_URL=
SUPABASE_ANON_KEY=
```

## Running the App

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs   # regenerate Riverpod code
flutter run
```

## Code Generation

Run after adding or modifying `@riverpod` annotated providers:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or watch mode during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```
