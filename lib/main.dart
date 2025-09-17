import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/di/injection_container.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:product_listing_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:product_listing_app/features/home/presentation/pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authBloc = sl<AuthBloc>();
        // Check auth status on app start
        authBloc.add(const CheckAuthStatusEvent());
        return authBloc;
      },
      child: MaterialApp(
        title: 'Product Listing App',
        theme: ThemeData(fontFamily: 'Oxygen'),
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
