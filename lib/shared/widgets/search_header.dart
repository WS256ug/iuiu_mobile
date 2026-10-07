import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_top_bar.dart';

/// Combines a page title with consistent search and optional filter controls.
class SearchHeader extends StatelessWidget {
  const SearchHeader({
    super.key,
    required this.title,
    required this.hintText,
    required this.onChanged,
    this.onFilter,
    this.showBackButton = false,
    this.showMoreButton = false,
    this.alignTitleToLeading = false,
  });

  final String title;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilter;
  final bool showBackButton;
  final bool showMoreButton;
  final bool alignTitleToLeading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(
          title: title,
          showBackButton: showBackButton,
          showMoreButton: showMoreButton,
          alignTitleToLeading: alignTitleToLeading,
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: onFilter,
                  borderRadius: BorderRadius.circular(14),
                  child: const SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
