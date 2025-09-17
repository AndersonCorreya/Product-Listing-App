// Example usage of the FloatingBottomNavBar and MainNavigationPage
// 
// To use the floating bottom navigation in your app, you can either:
//
// 1. Use the MainNavigationPage directly as your main screen:
//    ```dart
//    import 'package:product_listing_app/features/home/presentation/pages/main_navigation_page.dart';
//    
//    // In your main.dart or after authentication:
//    home: const MainNavigationPage(),
//    ```
//
// 2. Use the FloatingBottomNavBar widget in your own custom navigation:
//    ```dart
//    import 'package:product_listing_app/features/widgets/floating_bottom_nav_bar.dart';
//    
//    class MyCustomNavigation extends StatefulWidget {
//      @override
//      _MyCustomNavigationState createState() => _MyCustomNavigationState();
//    }
//    
//    class _MyCustomNavigationState extends State<MyCustomNavigation> {
//      int _selectedIndex = 0;
//      
//      final List<Widget> _pages = [
//        HomePage(),
//        WishlistPage(),
//        ProfilePage(),
//      ];
//      
//      @override
//      Widget build(BuildContext context) {
//        return Scaffold(
//          body: IndexedStack(
//            index: _selectedIndex,
//            children: _pages,
//          ),
//          floatingActionButton: FloatingBottomNavBar(
//            selectedIndex: _selectedIndex,
//            onItemTapped: (index) {
//              setState(() {
//                _selectedIndex = index;
//              });
//            },
//          ),
//          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//        );
//      }
//    }
//    ```
//
// The FloatingBottomNavBar includes:
// - Home tab with home_outlined/home icons
// - Wishlist tab with favorite_outline/favorite icons  
// - Profile tab with person_outline/person icons
// - Smooth animations and transitions
// - Customizable purple theme color (#6366F1)
// - Floating design with shadow effects
//
// The MainNavigationPage automatically manages the three pages:
// - HomePage: Product listing with search and carousel
// - WishlistPage: Saved items grid
// - ProfilePage: User profile with settings options
