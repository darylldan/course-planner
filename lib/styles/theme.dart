import "package:flutter/material.dart";

import 'package:flutter/material.dart';

@immutable
class SurfaceContainerTheme extends ThemeExtension<SurfaceContainerTheme> {
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;

  const SurfaceContainerTheme({
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  @override
  SurfaceContainerTheme copyWith({
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
  }) {
    return SurfaceContainerTheme(
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
    );
  }

  @override
  ThemeExtension<SurfaceContainerTheme> lerp(
      ThemeExtension<SurfaceContainerTheme>? other, double t) {
    if (other is! SurfaceContainerTheme) {
      return this;
    }
    return SurfaceContainerTheme(
      surfaceContainerLowest:
          Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh:
          Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(
          surfaceContainerHighest, other.surfaceContainerHighest, t)!,
    );
  }
}

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4287646273),
      surfaceTint: Color(4287646273),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4294957781),
      onPrimaryContainer: Color(4282059014),
      secondary: Color(4286666002),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4294958518),
      onSecondaryContainer: Color(4280948736),
      tertiary: Color(4279199361),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4290570751),
      onTertiaryContainer: Color(4278198057),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294965495),
      onBackground: Color(4280490264),
      surface: Color(4294965495),
      onSurface: Color(4280490264),
      surfaceVariant: Color(4294303194),
      onSurfaceVariant: Color(4283646785),
      outline: Color(4286935920),
      outlineVariant: Color(4292395710),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281937452),
      inverseOnSurface: Color(4294962666),
      inversePrimary: Color(4294948009),
      primaryFixed: Color(4294957781),
      onPrimaryFixed: Color(4282059014),
      primaryFixedDim: Color(4294948009),
      onPrimaryFixedVariant: Color(4285740076),
      secondaryFixed: Color(4294958518),
      onSecondaryFixed: Color(4280948736),
      secondaryFixedDim: Color(4294360176),
      onSecondaryFixedVariant: Color(4284759808),
      tertiaryFixed: Color(4290570751),
      onTertiaryFixed: Color(4278198057),
      tertiaryFixedDim: Color(4287287534),
      onTertiaryFixedVariant: Color(4278209891),
      surfaceDim: Color(4293449427),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294765287),
      surfaceContainerHigh: Color(4294436065),
      surfaceContainerHighest: Color(4294041308),
    );
  }

  ThemeData light() {
    final scheme = lightScheme(); // This returns a MaterialScheme
    return theme(scheme.toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4285411368),
      surfaceTint: Color(4287646273),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4289355862),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4284431104),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4288375591),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278208862),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4281499032),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294965495),
      onBackground: Color(4280490264),
      surface: Color(4294965495),
      onSurface: Color(4280490264),
      surfaceVariant: Color(4294303194),
      onSurfaceVariant: Color(4283383613),
      outline: Color(4285291353),
      outlineVariant: Color(4287198836),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281937452),
      inverseOnSurface: Color(4294962666),
      inversePrimary: Color(4294948009),
      primaryFixed: Color(4289355862),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4287449151),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4288375591),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4286468879),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4281499032),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278740094),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293449427),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294765287),
      surfaceContainerHigh: Color(4294436065),
      surfaceContainerHighest: Color(4294041308),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4282650635),
      surfaceTint: Color(4287646273),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4285411368),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281540096),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284431104),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278199858),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4278208862),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294965495),
      onBackground: Color(4280490264),
      surface: Color(4294965495),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4294303194),
      onSurfaceVariant: Color(4281213215),
      outline: Color(4283383613),
      outlineVariant: Color(4283383613),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281937452),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4294961123),
      primaryFixed: Color(4285411368),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4283570708),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284431104),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282459904),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4278208862),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278202688),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4293449427),
      surfaceBright: Color(4294965495),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294963438),
      surfaceContainer: Color(4294765287),
      surfaceContainerHigh: Color(4294436065),
      surfaceContainerHighest: Color(4294041308),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294948009),
      surfaceTint: Color(4294948009),
      onPrimary: Color(4283833879),
      primaryContainer: Color(4285740076),
      onPrimaryContainer: Color(4294957781),
      secondary: Color(4294360176),
      onSecondary: Color(4282788352),
      secondaryContainer: Color(4284759808),
      onSecondaryContainer: Color(4294958518),
      tertiary: Color(4287287534),
      onTertiary: Color(4278203717),
      tertiaryContainer: Color(4278209891),
      onTertiaryContainer: Color(4290570751),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279898384),
      onBackground: Color(4294041308),
      surface: Color(4279898384),
      onSurface: Color(4294041308),
      surfaceVariant: Color(4283646785),
      onSurfaceVariant: Color(4292395710),
      outline: Color(4288711817),
      outlineVariant: Color(4283646785),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294041308),
      inverseOnSurface: Color(4281937452),
      inversePrimary: Color(4287646273),
      primaryFixed: Color(4294957781),
      onPrimaryFixed: Color(4282059014),
      primaryFixedDim: Color(4294948009),
      onPrimaryFixedVariant: Color(4285740076),
      secondaryFixed: Color(4294958518),
      onSecondaryFixed: Color(4280948736),
      secondaryFixedDim: Color(4294360176),
      onSecondaryFixedVariant: Color(4284759808),
      tertiaryFixed: Color(4290570751),
      onTertiaryFixed: Color(4278198057),
      tertiaryFixedDim: Color(4287287534),
      onTertiaryFixedVariant: Color(4278209891),
      surfaceDim: Color(4279898384),
      surfaceBright: Color(4282529589),
      surfaceContainerLowest: Color(4279503883),
      surfaceContainerLow: Color(4280490264),
      surfaceContainer: Color(4280753436),
      surfaceContainerHigh: Color(4281477158),
      surfaceContainerHighest: Color(4282200625),
    );
  }

  ThemeData dark() {
    final scheme = darkScheme();
    return theme(
        scheme.toColorScheme()); // Convert MaterialScheme to ColorScheme
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294949552),
      surfaceTint: Color(4294948009),
      onPrimary: Color(4281533699),
      primaryContainer: Color(4291591024),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294688884),
      onSecondary: Color(4280488704),
      secondaryContainer: Color(4290414401),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4287550707),
      onTertiary: Color(4278196514),
      tertiaryContainer: Color(4283603382),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279898384),
      onBackground: Color(4294041308),
      surface: Color(4279898384),
      onSurface: Color(4294965752),
      surfaceVariant: Color(4283646785),
      onSurfaceVariant: Color(4292658882),
      outline: Color(4289961627),
      outlineVariant: Color(4287790972),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294041308),
      inverseOnSurface: Color(4281477158),
      inversePrimary: Color(4285805869),
      primaryFixed: Color(4294957781),
      onPrimaryFixed: Color(4281073921),
      primaryFixedDim: Color(4294948009),
      onPrimaryFixedVariant: Color(4284359709),
      secondaryFixed: Color(4294958518),
      onSecondaryFixed: Color(4280028672),
      secondaryFixedDim: Color(4294360176),
      onSecondaryFixedVariant: Color(4283314176),
      tertiaryFixed: Color(4290570751),
      onTertiaryFixed: Color(4278194971),
      tertiaryFixedDim: Color(4287287534),
      onTertiaryFixedVariant: Color(4278205261),
      surfaceDim: Color(4279898384),
      surfaceBright: Color(4282529589),
      surfaceContainerLowest: Color(4279503883),
      surfaceContainerLow: Color(4280490264),
      surfaceContainer: Color(4280753436),
      surfaceContainerHigh: Color(4281477158),
      surfaceContainerHighest: Color(4282200625),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294965752),
      surfaceTint: Color(4294948009),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4294949552),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294966007),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4294688884),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294376447),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4287550707),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279898384),
      onBackground: Color(4294041308),
      surface: Color(4279898384),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4283646785),
      onSurfaceVariant: Color(4294965752),
      outline: Color(4292658882),
      outlineVariant: Color(4292658882),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4294041308),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4283308050),
      primaryFixed: Color(4294959323),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4294949552),
      onPrimaryFixedVariant: Color(4281533699),
      secondaryFixed: Color(4294959810),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4294688884),
      onSecondaryFixedVariant: Color(4280488704),
      tertiaryFixed: Color(4291292671),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4287550707),
      onTertiaryFixedVariant: Color(4278196514),
      surfaceDim: Color(4279898384),
      surfaceBright: Color(4282529589),
      surfaceContainerLowest: Color(4279503883),
      surfaceContainerLow: Color(4280490264),
      surfaceContainer: Color(4280753436),
      surfaceContainerHigh: Color(4281477158),
      surfaceContainerHighest: Color(4282200625),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme, // Now correctly using ColorScheme
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
        extensions: [
          SurfaceContainerTheme(
            surfaceContainerLowest: lightScheme().surfaceContainerLowest,
            surfaceContainerLow: lightScheme().surfaceContainerLow,
            surfaceContainer: lightScheme().surfaceContainer,
            surfaceContainerHigh: lightScheme().surfaceContainerHigh,
            surfaceContainerHighest: lightScheme().surfaceContainerHighest,
          ),
        ],
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant, // Deprecated but kept for compatibility
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }

  // Getters for the surface container colors
  Color get surfaceContainerLowestColor => surfaceContainerLowest;
  Color get surfaceContainerLowColor => surfaceContainerLow;
  Color get surfaceContainerColor => surfaceContainer;
  Color get surfaceContainerHighColor => surfaceContainerHigh;
  Color get surfaceContainerHighestColor => surfaceContainerHighest;
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
