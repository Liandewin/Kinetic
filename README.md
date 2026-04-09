# Kinetic

A Strava-like running and workout tracker built with Flutter. Kinetic lets users log workouts, track progress, earn achievements, and follow their fitness community — all backed by Supabase.

---

## Features

- **Live Workout Tracking** — Start a workout session with a real-time clock and live stat display (pace, distance, duration)
- **Community Feed** — Home screen showing activity from people you follow
- **Achievements** — Daily goals, earned rewards, and milestone tracking
- **Profile** — Personal stats, goals summary, and settings
- **Authentication** — Email/password, Google Sign-In, and Sign in with Apple
- **Auth Guard** — Automatic redirect to login for unauthenticated users; deep-link safe

---

## Tech Stack

| Layer | Choice |
|---|---|
| Framework | Flutter (Dart SDK >=3.3.0) |
| State management | Riverpod (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`) |
| Navigation | `go_router` |
| Backend | Supabase (`supabase_flutter`) |
| Auth | Email/password + Google Sign-In + Sign in with Apple |
| Fonts | `google_fonts` — Inter (UI text), Lexend (stats/display numbers) |
| Code gen | `build_runner` + `riverpod_generator` |

---

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
        screens/                   # LoginScreen, SignupScreen (outside ShellRoute)
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

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.3.0
- Dart SDK >= 3.3.0
- A [Supabase](https://supabase.com) project with authentication enabled
- (Optional) Google Sign-In and Apple Sign-In credentials configured in Supabase

### 1. Clone the repo

```bash
git clone https://github.com/your-org/kinetic.git
cd kinetic
```

### 2. Configure environment

Create a `.env` file in the project root (it is gitignored):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Generate Riverpod code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
flutter run
```

---

## Development

### Code generation

Riverpod uses `build_runner` for provider code generation. Run this after adding or modifying any `@riverpod`-annotated provider:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous generation during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Linting

The project uses `flutter_lints` and `riverpod_lint` via `custom_lint`. To run lint checks:

```bash
dart run custom_lint
```

### Testing

```bash
flutter test
```

---

## Architecture

### Feature-first structure

Each feature owns its own `data/`, `domain/`, and `presentation/` sub-folders. Cross-feature shared code lives in `shared/`.

### State management

- New providers use the `@riverpod` code-gen annotation with `AsyncNotifierProvider`.
- The auth feature uses a legacy `StateNotifierProvider` — prefer `AsyncNotifierProvider` for all new work.

### Data layer

All Supabase access is encapsulated in repository classes under `data/repositories/`. Providers depend on repository providers, never on the Supabase client directly.

### Navigation

Routes are defined in `app_router.dart` using `AppRoutes` string constants — never hardcode path strings. Auth screens (`LoginScreen`, `SignupScreen`) sit outside the `ShellRoute`. All main tab screens (`HomeScreen`, `StartWorkoutScreen`, `AchievementsScreen`, `ProfileScreen`) sit inside the `ShellRoute` with `NoTransitionPage`.

The GoRouter `redirect` callback enforces authentication and re-evaluates whenever `authStateProvider` emits a new state.

---

## Design System

### Colours

All colour values are defined as constants in `AppColors` and must be used in place of raw hex values in widget code.

| Token | Value | Usage |
|---|---|---|
| `AppColors.primary` | `#00E639` | Kinetic Green — CTAs, active states |
| `AppColors.backgroundLight` | `#F9F9F9` | Screen backgrounds |
| `AppColors.textPrimary` | `#1A1C1C` | Headings and body text |
| `AppColors.textSecondary` | `#777777` | Captions, labels |
| `AppColors.cardWhite` | `#FFFFFF` | Card backgrounds |
| `AppColors.cardGray` | `#EEEEEE` | Alternate card backgrounds |

### Typography

- **Headings / section titles**: `GoogleFonts.lexend`, bold–black weights
- **UI labels / body / captions**: `GoogleFonts.inter`
- **Stats and large numeric displays**: `GoogleFonts.lexend`, heavy weight

Named styles are available via `AppTextStyles`. Inline styles are acceptable for one-off deviations.

### Component patterns

**App bar (frosted)** — `BackdropFilter` blur (sigmaX/Y 6), `Color(0xCCF9F9F9)` background, height `64 + topPadding`. "KINETIC" wordmark uses Inter 900, fontSize 20, letterSpacing 4.0.

**Bottom nav** — Frosted, rounded top (`BorderRadius.vertical(top: Radius.circular(32))`), blur 12. Active tab: filled green circle with black icon. Inactive: transparent with `Color(0xFF6B7280)` icon.

**Cards** — Border radius 12. Shadow: `BoxShadow(color: ..., blurRadius: 32, offset: Offset(0, 24), spreadRadius: -12)`. White or `cardGray` background.

**Progress bars** — `ClipRRect(borderRadius: BorderRadius.circular(9999))` wrapping a `LinearProgressIndicator`. Height 2px (subtle) or 4px (prominent).

---

## Environment Variables

| Variable | Description |
|---|---|
| `SUPABASE_URL` | Your Supabase project URL |
| `SUPABASE_ANON_KEY` | Your Supabase anonymous/public API key |

Secrets are loaded via `flutter_dotenv` before `Supabase.initialize` is called in `main.dart`. The `.env` file is listed in `pubspec.yaml` as a Flutter asset and is gitignored.

---

## Contributing

1. Fork the repo and create a feature branch from `main`.
2. Follow the existing feature-first folder structure.
3. Use `@riverpod` code-gen for any new providers and run `build_runner` before committing.
4. Use `AppColors` and `AppTextStyles` — no raw hex or inline font declarations.
5. Open a pull request with a clear description of what changed and why.
