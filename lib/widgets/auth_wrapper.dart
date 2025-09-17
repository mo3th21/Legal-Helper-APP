import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider_interface.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize auth provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProviderInterface>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderInterface>(
      builder: (context, authProvider, child) {
        // Show loading spinner while initializing
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B5E20)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جاري التحميل...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show appropriate screen based on auth state
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }


}
