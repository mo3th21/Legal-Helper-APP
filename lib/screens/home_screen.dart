import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qanon/screens/chat_screen.dart';
import 'package:qanon/screens/legal_contract_screen.dart';
// ...existing imports...
import 'package:qanon/theme/app_theme.dart';
import 'package:qanon/widgets/network_status_widget.dart';
import 'package:qanon/widgets/action_button.dart';
import 'package:qanon/widgets/category_card.dart';

class _BannerIcon extends StatefulWidget {
  const _BannerIcon();

  @override
  State<_BannerIcon> createState() => _BannerIconState();
}

class _BannerIconState extends State<_BannerIcon> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.92);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {},
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 90),
            child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.textWhite.withAlpha((0.12 * 255).round()),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.gavel,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  

  @override
  Widget build(BuildContext context) {
  final Widget homeContent = Container(
      color: const Color(0xFFEEEEEE), // slightly darker neutral background
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NetworkStatusWidget(),
            const SizedBox(height: 18),

            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withAlpha((0.9 * 255).round())],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
                child: Row(
                  children: [
                    _BannerIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحباً بك في قانون',
                            style: GoogleFonts.cairo(
                              color: AppColors.textWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'مستشارك القانوني الشخصي. اختر تخصصاً أو ابدأ استشارة.',
                            style: GoogleFonts.cairo(
                              color: AppColors.textWhite.withAlpha((0.9 * 255).round()),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ),

            const SizedBox(height: 22),

            
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    title: 'استشارة سريعة',
                    icon: Icons.chat_bubble_outline,
                    gradient: LinearGradient(
                      colors: [AppColors.accent, AppColors.accent.withAlpha((0.85 * 255).round())],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    destination: const ChatScreen(category: 'عام'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ActionButton(
                    title: 'العقود الجاهزة',
                    icon: Icons.description_outlined,
                    gradient: LinearGradient(
                      colors: [AppColors.success, AppColors.success.withAlpha((0.85 * 255).round())],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    destination: const LegalContractScreen(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            
            Padding(
              padding: const EdgeInsets.only(bottom: 12, right: 4, left: 4),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary, AppColors.primary.withAlpha((0.8 * 255).round())],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'التخصصات القانونية',
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),

            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.88,
              children: [
                CategoryCard(
                  title: 'القانون المدني',
                  icon: Icons.gavel,
                  description: 'عقود، ملكية، تعويضات',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen(category: 'القانون المدني')),
                  ),
                ),
                CategoryCard(
                  title: 'قانون الأسرة',
                  icon: Icons.family_restroom,
                  description: 'زواج، طلاق، حضانة',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen(category: 'قانون الأسرة')),
                  ),
                ),
                CategoryCard(
                  title: 'القانون التجاري',
                  icon: Icons.business,
                  description: 'شركات، عقود تجارية',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen(category: 'القانون التجاري')),
                  ),
                ),
                CategoryCard(
                  title: 'قانون العمل',
                  icon: Icons.work,
                  description: 'توظيف، حقوق العمال',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen(category: 'قانون العمل')),
                  ),
                ),
                CategoryCard(
                  title: 'القانون الجزائي',
                  icon: Icons.policy,
                  description: 'جنح، جنايات، مخالفات',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen(category: 'القانون الجزائي')),
                  ),
                ),
                CategoryCard(
                  title: 'الملكية الفكرية',
                  icon: Icons.copyright,
                  description: 'براءات، علامات تجارية',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen(category: 'الملكية الفكرية')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  String appBarTitle = 'المستشار القانوني الأردني';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: homeContent,
      extendBody: true,
    );
  }
}
