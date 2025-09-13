import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/datasources/auth_remote_data_source.dart';
import 'package:marketplace/data/datasources/product_remote_data_source.dart';
import 'package:marketplace/data/datasources/user_local_data_source.dart';
import 'package:marketplace/data/repositories/auth_repository_impl.dart';
import 'package:marketplace/data/repositories/product_repository_impl.dart';
import 'package:marketplace/domain/repositories/auth_repository.dart';
import 'package:marketplace/domain/repositories/product_repository.dart';
import 'package:marketplace/domain/usecases/facebook_login.dart';
import 'package:marketplace/domain/usecases/get_auth_status.dart';
import 'package:marketplace/domain/usecases/get_products.dart';
import 'package:marketplace/domain/usecases/google_login.dart';
import 'package:marketplace/domain/usecases/line_login.dart';
import 'package:marketplace/domain/usecases/logout.dart';
import 'package:marketplace/domain/usecases/place_bid.dart';
import 'package:marketplace/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:marketplace/presentation/home/main_screen.dart';
import 'package:marketplace/presentation/login/bloc/login_bloc.dart';
import 'package:marketplace/presentation/products/bloc/product_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // DATA SOURCES
        RepositoryProvider<ProductRemoteDataSource>(
          create: (context) => ProductRemoteDataSourceImpl(),
        ),
        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(),
        ),
        RepositoryProvider<UserLocalDataSource>(
          create: (context) => UserLocalDataSourceImpl(),
        ),
        // REPOSITORIES
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            remoteDataSource: context.read<ProductRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
            localDataSource: context.read<UserLocalDataSource>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              getAuthStatus: GetAuthStatus(context.read<AuthRepository>()),
              logout: Logout(context.read<AuthRepository>()),
            )..add(AppStarted()),
          ),
          BlocProvider(
            create: (context) {
              final authRepository = context.read<AuthRepository>();
              return LoginBloc(
                authenticationBloc: context.read<AuthenticationBloc>(),
                googleLoginUseCase: GoogleLogin(authRepository),
                facebookLoginUseCase: FacebookLogin(authRepository),
                lineLoginUseCase: LineLogin(authRepository),
              );
            },
          ),
          BlocProvider(
            create: (context) {
              final bloc = ProductBloc(
                getProducts: GetProducts(context.read<ProductRepository>()),
                placeBid: PlaceBid(context.read<ProductRepository>()),
              );

              WidgetsBinding.instance.addPostFrameCallback((_) {
                bloc.add(LoadProducts());
              });
              return bloc;
            },
          ),
        ],
        child: MaterialApp(
          title: 'Product Bidding',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MainScreen(),
        ),
      ),
    );
  }
}
