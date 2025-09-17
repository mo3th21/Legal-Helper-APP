import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider_interface.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderInterface>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('الملف الشخصي'),
            actions: [
             
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Avatar
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((0.1 * 255).round()),
                    child: _buildInitialsAvatar(user),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Profile Information Cards
                _buildInfoCard(
                  icon: Icons.person,
                  title: 'الاسم',
                  value: user?.displayNameOrEmail ?? '',
                ),
                
                _buildInfoCard(
                  icon: Icons.email,
                  title: 'البريد الإلكتروني',
                  value: user?.email ?? '',
                ),
                
                _buildInfoCard(
                  icon: Icons.phone,
                  title: 'رقم الهاتف',
                  value: user?.phoneNumber ?? 'غير محدد',
                ),
                
                _buildInfoCard(
                  icon: Icons.access_time,
                  title: 'تاريخ الانضمام',
                  value: _formatDate(user?.createdAt),
                ),
                
                _buildInfoCard(
                  icon: Icons.login,
                  title: 'آخر تسجيل دخول',
                  value: _formatDate(user?.updatedAt),
                ),
                

              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInitialsAvatar(user) {
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      List<String> nameParts = user.displayName!.split(' ');
      String initials;
      if (nameParts.length >= 2) {
        initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
      } else {
        initials = user.displayName![0].toUpperCase();
      }
      
      return Text(
        initials,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    } else if (user?.email != null && user!.email.isNotEmpty) {
      return Text(
        user.email[0].toUpperCase(),
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    } else {
      return const Text(
        'U',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسابيع';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months أشهر';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'منذ $years سنوات';
    }
  }



    
  
}
