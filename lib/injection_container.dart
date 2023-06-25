import 'package:get_it/get_it.dart';
import 'package:scribble/bloc/register_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => RegisterBloc());
}