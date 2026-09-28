import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/otp_event.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/careers/domain/entities/career_entity.dart';
import '../../features/careers/presentation/screens/career_apply_screen.dart';
import '../../features/careers/presentation/screens/careers_screen.dart';
import '../../features/coupons/presentation/screens/coupons_screen.dart';
import '../../features/deals/presentation/screens/deals_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/legal/domain/entities/legal_document_type.dart';
import '../../features/legal/presentation/screens/legal_document_screen.dart';
import '../../features/locations/presentation/screens/locations_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/qr/presentation/screens/qr_screen.dart';
import '../../features/rewards/presentation/screens/rewards_screen.dart';
import '../../features/socials/presentation/screens/socials_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/weekly_ads/presentation/screens/weekly_ads_screen.dart';
import '../session/auth_session.dart';
import 'go_router_refresh_stream.dart';

/// Paths reachable without a token — everything else that needs auth
/// (profile, coupon wallet) is gated inside the screen itself so guests get
/// an inviting prompt instead of a router bounce (see GuestPrompt).
const _authOnlyRoutes = {'/welcome', '/register', '/login', '/otp'};

GoRouter buildAppRouter(AuthSession authSession) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authSession),
    redirect: (context, state) {
      final isAuthenticated = authSession.isAuthenticated;
      final isAuthOnlyRoute = _authOnlyRoutes.contains(state.matchedLocation);

      // Once logged in, don't let the user land back on the auth flow
      // (e.g. via a stale deep link or the back button).
      if (isAuthenticated && isAuthOnlyRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(initialPhone: state.extra as String?),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(initialPhone: state.extra as String?),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final args = state.extra;
          if (args is OtpScreenArgs) return OtpScreen(args: args);
          return OtpScreen(args: const OtpScreenArgs(phone: '', flow: OtpFlow.login));
        },
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/deals', builder: (context, state) => const DealsScreen()),
      GoRoute(path: '/socials', builder: (context, state) => const SocialsScreen()),
      GoRoute(path: '/qr', builder: (context, state) => const QrScreen()),
      GoRoute(path: '/weekly-ads', builder: (context, state) => const WeeklyAdsScreen()),
      GoRoute(path: '/coupons', builder: (context, state) => const CouponsScreen()),
      GoRoute(path: '/locations', builder: (context, state) => const LocationsScreen()),
      GoRoute(path: '/careers', builder: (context, state) => const CareersScreen()),
      GoRoute(path: '/rewards', builder: (context, state) => const RewardsScreen()),
      GoRoute(
        path: '/career-apply',
        builder: (context, state) => CareerApplyScreen(career: state.extra as CareerEntity),
      ),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const LegalDocumentScreen(
          title: 'Privacy Policy',
          type: LegalDocumentType.privacyPolicy,
        ),
      ),
      GoRoute(
        path: '/terms-of-service',
        builder: (context, state) => const LegalDocumentScreen(
          title: 'Terms of Service',
          type: LegalDocumentType.termsOfService,
        ),
      ),
      GoRoute(
        path: '/anti-spam-policy',
        builder: (context, state) => const LegalDocumentScreen(
          title: 'Anti-Spam Policy',
          type: LegalDocumentType.antiSpamPolicy,
        ),
      ),
    ],
  );
}
