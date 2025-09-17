import 'package:flutter/material.dart';
import 'package:product_listing_app/core/constants/app_colors.dart';
import 'package:product_listing_app/features/widgets/app_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_listing_app/core/di/injection_container.dart';
import 'package:product_listing_app/features/home/presentation/bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => sl<ProfileBloc>()..add(const ProfileRequested()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                scrolledUnderElevation: 0.0,
                floating: true,
                pinned: true,
                snap: false,
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarHeight: 70,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  child: Row(
                    children: [
                      AppText.light(
                        'My Profile',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  final bool loading =
                      state is ProfileLoading || state is ProfileInitial;
                  final String name = state is ProfileLoaded
                      ? state.profile.name
                      : '...';
                  final String phone = state is ProfileLoaded
                      ? state.profile.phone
                      : '...';
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.light(
                            'Name',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : AppText.heading(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                          const SizedBox(height: 24),
                          AppText.light(
                            'Phone',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : AppText.heading(
                                  phone,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
