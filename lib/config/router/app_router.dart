// importamos go router para manejar la navegacion de la app
import 'package:cuevana7_movies_app_cv/presentation/screens/movies/home_screen.dart';
import 'package:go_router/go_router.dart';

// usar GoRouter nos ayuda a que nosotros no tengamos que hacer configuraciones especiales si lo queremos usar en la web
// creamos la configuracon global del router 
// define como navegamos entre pantallas

final appRouter = GoRouter(
    
    initialLocation: '/',
    
    routes: 
[
    GoRoute(
        // Url de la ruta
        path: '/',
        // nombre de la rutas
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen()
        )
]); 