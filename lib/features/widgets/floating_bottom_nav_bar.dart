import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';

class FloatingBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const FloatingBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  State<FloatingBottomNavBar> createState() => _FloatingBottomNavBarState();
}

class _FloatingBottomNavBarState extends State<FloatingBottomNavBar> {
  final List<NavItem> _navItems = [
    NavItem(
      icon: 'assets/icons/home_icon.svg',
      activeIcon: 'assets/icons/home_icon.svg',
      label: 'Home',
    ),
    NavItem(
      icon: 'assets/icons/empty_heart.svg',
      activeIcon: 'assets/icons/empty_heart.svg',
      label: 'WishList',
    ),
    NavItem(
      icon: 'assets/icons/profile_icon.svg',
      activeIcon: 'assets/icons/profile_icon.svg',
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(37), // 74/2 for circular radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          8.0,
        ), // Add padding so selected items don't touch borders
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < _navItems.length; i++) _buildNavItem(i),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = index == widget.selectedIndex;

    return GestureDetector(
      onTap: () {
        widget.onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            28,
          ), // Rounded corners for selected item
          color: isSelected ? AppColors.blue : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isSelected ? item.activeIcon : item.icon,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.grey[600]!,
                BlendMode.srcIn,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: isSelected ? 8 : 0,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem {
  final String icon;
  final String activeIcon;
  final String label;

  NavItem({required this.icon, required this.activeIcon, required this.label});
}
