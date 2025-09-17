import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/di/injection_container.dart';
import 'package:product_listing_app/features/home/presentation/bloc/search_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/wishlist_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/product_bloc.dart';
import 'package:product_listing_app/features/home/presentation/bloc/banner_event.dart';
import 'package:product_listing_app/features/home/presentation/pages/home_page.dart';
import 'package:product_listing_app/features/home/presentation/pages/profile_page.dart';
import 'package:product_listing_app/features/home/presentation/pages/wishlist_page.dart';
import 'package:product_listing_app/features/widgets/floating_bottom_nav_bar.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const WishlistPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(create: (_) => sl<SearchBloc>()),
        BlocProvider<WishlistBloc>.value(value: sl<WishlistBloc>()),
        BlocProvider<BannerBloc>(
          create: (_) => sl<BannerBloc>()..add(const GetBannersEvent()),
        ),
        BlocProvider<ProductBloc>(
          create: (_) => sl<ProductBloc>()..add(const GetProductsEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: IndexedStack(index: _selectedIndex, children: _pages),
        floatingActionButton: FloatingBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
