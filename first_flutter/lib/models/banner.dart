import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../core/config/api_config.dart';

/// Modelo de Banner para promociones y anuncios
class Banner extends Equatable {
  final int id;
  final String imagenUrl;
  final String imagenDesktopUrl;
  final String imagenTabletUrl;
  final String imagenMobileUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isLocal; // Indica si es un banner local (asset) o de API

  const Banner({
    required this.id,
    required this.imagenUrl,
    required this.imagenDesktopUrl,
    required this.imagenTabletUrl,
    required this.imagenMobileUrl,
    this.createdAt,
    this.updatedAt,
    this.isLocal = false,
  });

  /// Obtiene la URL de imagen más apropiada según el ancho de pantalla
  String getImageUrl(double width) {
    if (width >= 1200) {
      return imagenDesktopUrl.isNotEmpty ? imagenDesktopUrl : imagenUrl;
    } else if (width >= 768) {
      return imagenTabletUrl.isNotEmpty ? imagenTabletUrl : imagenUrl;
    } else {
      return imagenMobileUrl.isNotEmpty ? imagenMobileUrl : imagenUrl;
    }
  }

  factory Banner.fromJson(Map<String, dynamic> json) {
    debugPrint('=== DEBUG: Banner.fromJson ===');
    debugPrint('JSON recibido: $json');

    // Handle ID conversion
    int bannerId;
    if (json['id'] is String) {
      bannerId = int.tryParse(json['id']) ?? 0;
    } else {
      bannerId = json['id'] ?? 0;
    }

    // Procesar URLs de imágenes
    String processImageUrl(String? url) {
      if (url == null || url.isEmpty) return '';
      if (url.startsWith('http')) return url;
      
      // Es una ruta relativa, agregar base URL sin /api/v1
      final baseUrlWithoutApi = ApiConfig.baseUrl.replaceAll('/api/v1', '');
      return '$baseUrlWithoutApi$url';
    }

    final imagenUrl = processImageUrl(json['imagen_url']);
    final imagenDesktopUrl = processImageUrl(json['imagen_desktop_url']).isNotEmpty 
        ? processImageUrl(json['imagen_desktop_url']) 
        : imagenUrl;
    final imagenTabletUrl = processImageUrl(json['imagen_tablet_url']).isNotEmpty 
        ? processImageUrl(json['imagen_tablet_url']) 
        : imagenUrl;
    final imagenMobileUrl = processImageUrl(json['imagen_mobile_url']).isNotEmpty 
        ? processImageUrl(json['imagen_mobile_url']) 
        : imagenUrl;

    // Procesar fechas
    DateTime? parseDate(dynamic dateField) {
      if (dateField == null) return null;
      try {
        if (dateField is String) {
          return DateTime.parse(dateField);
        }
        return null;
      } catch (e) {
        debugPrint('Error parseando fecha: $e');
        return null;
      }
    }

    final banner = Banner(
      id: bannerId,
      imagenUrl: imagenUrl,
      imagenDesktopUrl: imagenDesktopUrl,
      imagenTabletUrl: imagenTabletUrl,
      imagenMobileUrl: imagenMobileUrl,
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );

    debugPrint('Banner creado: ID=${banner.id}');
    debugPrint('Imagen URL: ${banner.imagenUrl}');
    debugPrint('================================');

    return banner;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagen_url': imagenUrl,
      'imagen_desktop_url': imagenDesktopUrl,
      'imagen_tablet_url': imagenTabletUrl,
      'imagen_mobile_url': imagenMobileUrl,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        imagenUrl,
        imagenDesktopUrl,
        imagenTabletUrl,
        imagenMobileUrl,
        createdAt,
        updatedAt,
        isLocal,
      ];

  /// Crea banners por defecto desde assets locales
  static List<Banner> getDefaultBanners() {
    return [
      const Banner(
        id: 1,
        imagenUrl: 'assets/LogoText.png',
        imagenDesktopUrl: 'assets/LogoText.png',
        imagenTabletUrl: 'assets/LogoText.png',
        imagenMobileUrl: 'assets/LogoText.png',
        isLocal: true,
      ),
    ];
  }
}
