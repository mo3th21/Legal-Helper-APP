import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // الألوان الرئيسية
  static const primary = Color(0xFF003366);      // أزرق داكن
  static const secondary = Color(0xFF007BFF);     // أزرق سماوي
  static const accent = Color.fromARGB(255, 184, 158, 10);        // ذهبي لامع
  static const background = Color(0xFFF5F5F5);    // أبيض مائل للرمادي

  // ألوان النصوص
  static const textDark = Color(0xFF333333);      // رمادي داكن للنصوص الرئيسية
  static const textLight = Color(0xFFB0BEC5);     // رمادي فاتح للنصوص الثانوية
  static const textWhite = Color(0xFFFFFFFF);     // أبيض للنصوص على الخلفيات الداكنة

  // ألوان إضافية
  static const surface = Color(0xFFFFFFFF);       // أبيض للبطاقات والأسطح
  static const divider = Color(0xFFB0BEC5);       // رمادي فاتح للفواصل
  static const error = Color(0xFFD32F2F);         // أحمر للأخطاء
  static const success = Color(0xFF388E3C);       // أخضر للنجاح
  static const warning = Color(0xFFFFA000);       // برتقالي للتحذيرات
  
  // درجات الظل
  static const shadow = Color(0x19000000);        // ظل شفاف أفتح
  static const overlay = Color(0x0A000000);       // طبقة شفافة للتأثيرات
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        
        // تخصيص الخطوط
        textTheme: TextTheme(
          displayLarge: GoogleFonts.cairo(
            color: AppColors.textDark,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: GoogleFonts.cairo(
            color: AppColors.textDark,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: GoogleFonts.cairo(
            color: AppColors.textDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: GoogleFonts.cairo(
            color: AppColors.textDark,
            fontSize: 18,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.cairo(
            color: AppColors.textLight,
            fontSize: 16,
            height: 1.5,
          ),
          bodySmall: GoogleFonts.cairo(
            color: AppColors.textLight,
            fontSize: 14,
            height: 1.5,
          ),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          elevation: 4,  // إضافة ظل للأعلى
          centerTitle: true,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
            minimumSize: const Size(double.infinity, 52),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 6, // زيادة الظل
            shadowColor: AppColors.shadow,
            textStyle: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            minimumSize: const Size(double.infinity, 52),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            textStyle: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.error),
          ),
          labelStyle: GoogleFonts.cairo(
            color: AppColors.textLight,
            fontSize: 16,
          ),
          hintStyle: GoogleFonts.cairo(
            color: AppColors.textLight,
            fontSize: 16,
          ),
        ),

        cardTheme: CardThemeData(
          color: AppColors.surface,
          surfaceTintColor: AppColors.surface,
          elevation: 4,  // زيادة الظل
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          titleTextStyle: GoogleFonts.cairo(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          subtitleTextStyle: GoogleFonts.cairo(
            color: AppColors.textLight,
            fontSize: 14,
          ),
        ),

        dividerTheme: DividerThemeData(
          color: AppColors.divider,
          space: 1,
          thickness: 1,
        ),

        scaffoldBackgroundColor: AppColors.background,
        shadowColor: AppColors.shadow,
      );
}
