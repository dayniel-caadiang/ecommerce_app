import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/api_service.dart';
import 'services/cache_service.dart';
import 'cubits/product/product_cubit.dart';
import 'cubits/cart/cart_cubit.dart';
import 'cubits/theme/theme_cubit.dart';
import 'cubits/theme/theme_state.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final cacheService = CacheService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeCubit(cacheService: cacheService),
        ),
        BlocProvider(
          create: (_) => ProductCubit(
            apiService: apiService,
            cacheService: cacheService,
          ),
        ),
        BlocProvider(
          create: (_) => CartCubit(cacheService: cacheService),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'E-Commerce Shop',
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
