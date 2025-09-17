import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:qanon/firebase_options.dart';
import 'package:qanon/providers/auth_provider.dart';
import 'package:qanon/providers/auth_provider_interface.dart';
import 'package:qanon/theme/app_theme.dart';
import 'package:qanon/screens/bottom_nav_screen.dart';
import 'package:qanon/screens/legal_contract_screen.dart';
import 'package:qanon/screens/login_screen.dart';
import 'package:qanon/screens/signup_screen.dart';
import 'package:qanon/screens/profile_screen.dart';
import 'package:qanon/screens/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const QanonApp());
}

class QanonApp extends StatelessWidget {
  const QanonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProviderInterface>(
      create: (context) {
        final provider = AuthProvider();
        provider.initialize();
        return provider;
      },
      child: Consumer<AuthProviderInterface>(
        builder: (context, auth, _) => MaterialApp(
          title: 'قانون - المستشار القانوني الأردني',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: const SplashScreen(),
          routes: {
            '/contracts': (_) => _buildProtectedRoute(auth, const LegalContractScreen()),
            '/login': (_) => const LoginScreen(),
            '/signup': (_) => const SignUpScreen(),
            '/home': (_) => _buildProtectedRoute(auth, const BottomNavScreen()),
            '/profile': (_) => _buildProtectedRoute(auth, const ProfileScreen()),
          },
        ),
      ),
    );
  }

  static Widget _buildProtectedRoute(AuthProviderInterface auth, Widget screen) {
    if (!auth.isAuthenticated) {
      return const LoginScreen();
    }
    return screen;
  }
}
