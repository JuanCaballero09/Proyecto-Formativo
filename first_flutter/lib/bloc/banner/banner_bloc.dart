import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../service/api_service.dart';
import '../../core/errors/exceptions.dart';
import '../base_state.dart';
import '../../models/banner.dart';

/// Cubit que maneja el estado de los banners
/// Se carga una vez al inicio y mantiene el estado durante toda la app
class BannerCubit extends Cubit<BaseState> {
  final ApiService apiService;
  bool _isLoaded = false;

  BannerCubit({ApiService? apiService})
      : apiService = apiService ?? ApiService(),
        super(const InitialState()) {
    debugPrint('🎬 BannerCubit: Constructor ejecutado');
  }

  /// Carga los banners desde la API
  /// Solo carga una vez, las siguientes llamadas usan caché
  Future<void> loadBanners({bool forceRefresh = false}) async {
    // Si ya está cargado y no es refresh forzado, no hacer nada
    if (_isLoaded && !forceRefresh) {
      debugPrint('📦 BannerCubit: Banners ya cargados, no se vuelven a cargar');
      return;
    }

    debugPrint('🔄 BannerCubit: Cargando banners...');
    emit(const LoadingState(message: 'Cargando banners...'));
    try {
      final banners = await apiService.getBanners();
      debugPrint('📡 BannerCubit: API retornó ${banners.length} banners');
      
      if (banners.isEmpty) {
        // Si no hay banners en la API, usar los por defecto
        debugPrint('⚠️ BannerCubit: No hay banners, cargando por defecto');
        _loadDefaultBanners();
        return;
      }
      
      debugPrint('✅ BannerCubit: Emitiendo ${banners.length} banners');
      emit(SuccessState<List<Banner>>(banners));
      _isLoaded = true;
    } on NetworkException {
      // Si hay error de red, cargar banners por defecto
      debugPrint('❌ BannerCubit: NetworkException, cargando banners por defecto');
      _loadDefaultBanners();
    } on DataException {
      // Si hay error de datos, cargar banners por defecto
      debugPrint('❌ BannerCubit: DataException, cargando banners por defecto');
      _loadDefaultBanners();
    } catch (e) {
      // Cualquier otro error, cargar banners por defecto
      debugPrint('❌ BannerCubit: Error desconocido ($e), cargando banners por defecto');
      _loadDefaultBanners();
    }
  }

  /// Carga los banners por defecto desde assets
  void _loadDefaultBanners() {
    final defaultBanners = Banner.getDefaultBanners();
    debugPrint('🎨 BannerCubit: Cargando ${defaultBanners.length} banner(es) por defecto');
    debugPrint('   Banner default: ${defaultBanners[0].imagenUrl}');
    emit(SuccessState<List<Banner>>(defaultBanners));
    _isLoaded = true;
  }

  /// Refresca los banners (útil para pull-to-refresh)
  Future<void> refreshBanners() async {
    await loadBanners(forceRefresh: true);
  }
}
