import 'package:flutter/material.dart';

class AppColors {
  static const cream = Color(0xFFFBF7F2);
  static const ink = Color(0xFF2B2420);
  static const inkMuted = Color(0xFF8A7F72);
  static const line = Color(0xFFE8DFD3);
  static const basil = Color(0xFF3F6E52);
  static const basilTint = Color(0xFFE4ECE6);
  static const tomato = Color(0xFFC1443C);
}

const headlineFont = 'serif';

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.basil,
      primary: AppColors.basil,
      surface: AppColors.cream,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontFamily: headlineFont,
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontFamily: headlineFont,
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontFamily: headlineFont,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      bodyLarge: TextStyle(fontSize: 15.5, color: AppColors.ink, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.ink),
      bodySmall: TextStyle(fontSize: 13, color: AppColors.inkMuted),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      titleTextStyle: TextStyle(
        fontFamily: headlineFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(26),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: AppColors.inkMuted),
    ),
  );
}

// Ek round icon-button jaisa circle — AppBar actions aur floating buttons ke liye
class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final Color background;
  final VoidCallback onTap;

  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.background = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: iconColor ?? AppColors.ink),
        ),
      ),
    );
  }
}

// Recipe list rows ke liye consistent, card-less row
class RecipeRow extends StatelessWidget {
  final String name;
  final String thumbnail;
  final VoidCallback onTap;
  final Widget? trailing;

  const RecipeRow({
    super.key,
    required this.name,
    required this.thumbnail,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                thumbnail,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}