import 'package:flutter/material.dart';

/// Full colour palette. Use these instead of inline `Color(...)` values.
class AppColors {
  AppColors._();

  // Brand.
  static const Color primary = Color(0xFF0F6E56); // MeroShare green
  static const Color primaryLight = Color(0xFFE1F5EE);
  static const Color secondary = Color(0xFF534AB7); // Purple accent
  static const Color error = Color(0xFF993C1D);

  // Status.
  static const Color allotted = Color(0xFF27AE60); // Green — got shares
  static const Color notAllotted = Color(0xFFE74C3C); // Red — not allotted
  static const Color pending = Color(0xFFF39C12); // Amber — waiting
  static const Color applied = Color(0xFF534AB7); // Purple — submitted
  static const Color skipped = Color(0xFF7F8C8D); // Grey — skipped

  // Neutrals — light.
  static const Color lightBackground = Color(0xFFF7F9F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Neutrals — dark.
  static const Color darkBackground = Color(0xFF121615);
  static const Color darkSurface = Color(0xFF1C2422);
  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF2D3733);

  static const Color white = Color(0xFFFFFFFF);
}
