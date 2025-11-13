import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final TextDirection? direction;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final StrutStyle? strutStyle;
  final TextWidthBasis? widthBasis;
  final TextHeightBehavior? heightBehavior;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final bool usePoppins;

  const AppText(
      this.text, {
        super.key,
        this.style,
        this.align,
        this.direction,
        this.softWrap,
        this.overflow,
        this.maxLines,
        this.strutStyle,
        this.widthBasis,
        this.heightBehavior,
        this.color,
        this.size,
        this.weight,
        this.fontStyle,
        this.letterSpacing,
        this.wordSpacing,
        this.height,
        this.decoration,
        this.decorationColor,
        this.decorationStyle,
        this.decorationThickness,
        this.usePoppins = true,
      });

  const AppText.headingLarge(
      this.text, {
        super.key,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.usePoppins = true,
      })  : size = 32,
        weight = FontWeight.w700,
        height = 1.2,
        style = null,
        direction = null,
        softWrap = null,
        strutStyle = null,
        widthBasis = null,
        heightBehavior = null,
        fontStyle = null,
        letterSpacing = -0.5,
        wordSpacing = null,
        decoration = null,
        decorationColor = null,
        decorationStyle = null,
        decorationThickness = null;

  const AppText.headingMedium(
      this.text, {
        super.key,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.usePoppins = true,
      })  : size = 24,
        weight = FontWeight.w600,
        height = 1.3,
        style = null,
        direction = null,
        softWrap = null,
        strutStyle = null,
        widthBasis = null,
        heightBehavior = null,
        fontStyle = null,
        letterSpacing = -0.3,
        wordSpacing = null,
        decoration = null,
        decorationColor = null,
        decorationStyle = null,
        decorationThickness = null;

  const AppText.headingSmall(
      this.text, {
        super.key,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.usePoppins = true,
      })  : size = 20,
        weight = FontWeight.w600,
        height = 1.4,
        style = null,
        direction = null,
        softWrap = null,
        strutStyle = null,
        widthBasis = null,
        heightBehavior = null,
        fontStyle = null,
        letterSpacing = -0.2,
        wordSpacing = null,
        decoration = null,
        decorationColor = null,
        decorationStyle = null,
        decorationThickness = null;

  const AppText.bodyLarge(
      this.text, {
        super.key,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.weight,
        this.usePoppins = true,
      })  : size = 18,
        height = 1.5,
        style = null,
        direction = null,
        softWrap = null,
        strutStyle = null,
        widthBasis = null,
        heightBehavior = null,
        fontStyle = null,
        letterSpacing = 0,
        wordSpacing = null,
        decoration = null,
        decorationColor = null,
        decorationStyle = null,
        decorationThickness = null;

  const AppText.bodyMedium(
      this.text, {
        super.key,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.weight,
        this.usePoppins = true,
      })  : size = 16,
        height = 1.5,
        style = null,
        direction = null,
        softWrap = null,
        strutStyle = null,
        widthBasis = null,
        heightBehavior = null,
        fontStyle = null,
        letterSpacing = 0,
        wordSpacing = null,
        decoration = null,
        decorationColor = null,
        decorationStyle = null,
        decorationThickness = null;

  const AppText.bodySmall(
      this.text, {
        super.key,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.usePoppins = true,
      })  : size = 14,
        weight = FontWeight.w400,
        height = 1.4,
        style = null,
        direction = null,
        softWrap = null,
        strutStyle = null,
        widthBasis = null,
        heightBehavior = null,
        fontStyle = null,
        letterSpacing = 0,
        wordSpacing = null,
        decoration = null,
        decorationColor = null,
        decorationStyle = null,
        decorationThickness = null;

  const AppText.caption(
      this.text, {
        super.key,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.usePoppins = true,
      })  : size = 12,
        weight = FontWeight.w400,
        height = 1.3,
        style = null,
        direction = null,
        softWrap = null,
        strutStyle = null,
        widthBasis = null,
        heightBehavior = null,
        fontStyle = null,
        letterSpacing = 0,
        wordSpacing = null,
        decoration = null,
        decorationColor = null,
        decorationStyle = null,
        decorationThickness = null;

  const AppText.button(
      this.text, {
        super.key,
        this.color,
        this.align,
        this.maxLines,
        this.overflow,
        this.usePoppins = true,
      })  : size = 16,
        weight = FontWeight.w600,
        height = 1.0,
        style = null,
        direction = null,
        softWrap = null,
        strutStyle = null,
        widthBasis = null,
        heightBehavior = null,
        fontStyle = null,
        letterSpacing = 0.5,
        wordSpacing = null,
        decoration = null,
        decorationColor = null,
        decorationStyle = null,
        decorationThickness = null;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = usePoppins
        ? GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      color: color,
    )
        : TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      color: color,
    );

    final TextStyle effectiveStyle = style != null
        ? baseStyle.merge(style)
        : baseStyle;

    return Text(
      text,
      style: effectiveStyle,
      textAlign: align,
      textDirection: direction,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textWidthBasis: widthBasis,
      textHeightBehavior: heightBehavior,
    );
  }
}