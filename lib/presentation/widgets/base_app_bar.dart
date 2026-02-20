import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/theme/app_text_styles.dart';

/// A reusable AppBar widget with consistent styling and behavior
/// Reduces duplication across screens
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onLeadingPressed;
  final bool centerTitle;
  final bool pinned;
  final double elevation;
  final Widget? flexibleSpace;
  final double? expandedHeight;

  const BaseAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.onLeadingPressed,
    this.centerTitle = false,
    this.pinned = true,
    this.elevation = 0,
    this.flexibleSpace,
    this.expandedHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        expandedHeight ?? (subtitle != null ? 80 : 56),
      );

  @override
  Widget build(BuildContext context) {
    final isSliver = flexibleSpace != null || expandedHeight != null;

    if (isSliver) {
      return SliverAppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.9),
        pinned: pinned,
        elevation: elevation,
        scrolledUnderElevation: 0,
        expandedHeight: expandedHeight,
        flexibleSpace: flexibleSpace,
        leading: leading ??
            (onLeadingPressed != null
                ? IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: onLeadingPressed,
                  )
                : null),
        title: _buildTitle(context),
        actions: actions,
        centerTitle: centerTitle,
      );
    }

    return AppBar(
      backgroundColor: AppColors.background.withValues(alpha: 0.9),
      elevation: elevation,
      leading: leading ??
          (onLeadingPressed != null
              ? IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: onLeadingPressed,
                )
              : null),
      title: _buildTitle(context),
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (title == null && subtitle == null) return null;

    return Column(
      crossAxisAlignment:
          centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(
            title!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ],
    );
  }
}

/// A simple AppBar extension for Home screen with market status
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appName;
  final String marketStatus;
  final String currentTime;
  final Color marketStatusColor;
  final VoidCallback? onNotificationTap;
  final Widget? logo;

  const HomeAppBar({
    super.key,
    required this.appName,
    required this.marketStatus,
    required this.currentTime,
    required this.marketStatusColor,
    this.onNotificationTap,
    this.logo,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.background.withValues(alpha: 0.9),
      floating: true,
      pinned: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: logo != null
          ? Container(
              margin: const EdgeInsets.only(left: AppSizes.p20),
              child: Hero(
                tag: 'app_logo_hero',
                child: logo!,
              ),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            children: [
              Text(
                marketStatus,
                style: AppTextStyles.marketStatusOpen.copyWith(
                  color: marketStatusColor,
                ),
              ),
              const SizedBox(width: AppSizes.p8),
              Text(
                '• $currentTime',
                style: AppTextStyles.marketTime.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSizes.p16),
          child: CircleAvatar(
            backgroundColor: AppColors.surfaceLight,
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: AppSizes.iconMd,
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.warn,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
