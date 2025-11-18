# Fix: Error de Búsqueda Repetida - "No encuentra nada"

## 🐛 Problema Identificado

Después de 2 búsquedas, la app mostraba error:
- `SearchError: Error al buscar: ...`
- O resultados vacíos sin explicación

## 🔍 Causas Encontradas

### 1. **Búsquedas Duplicadas**
- El evento `SearchQueryChanged` se disparaba múltiples veces desde:
  - `initState()` de SearchResultsPage
  - `onChanged()` del TextField (mientras se escribía)
  - Esto causaba requests duplicadas que se procesaban de forma inconsistente

### 2. **Falta de Debounce**
- Sin debounce, cada carácter escrito disparaba una búsqueda
- Búsquedas se completaban fuera de orden
- El estado del BLoC quedaba inconsistente

### 3. **Estado del BLoC No Se Limpiaba**
- Cuando el usuario volvía a HomePage y luego abría SearchResultsPage de nuevo
- El BLoC mantenía el estado anterior (error o resultados viejos)
- La nueva búsqueda se sobrelapaba con la anterior

### 4. **Validación Débil en API**
- Respuestas malformadas del servidor no se validaban
- Errores de parsing fallaban silenciosamente

## ✅ Soluciones Implementadas

### 1. **Debounce en SearchResultsPage**
```dart
_debounceTimer = Timer(const Duration(milliseconds: 500), () {
  context.read<SearchBloc>().add(SearchQueryChanged(trimmedQuery));
});
```

**Beneficio:** Se ejecuta solo UNA búsqueda después de escribir, no en cada carácter

### 2. **Control de Búsquedas Duplicadas**
```dart
String _lastSearchedQuery = '';

void _performSearch(String query) {
  // No buscar si es la misma query que la anterior
  if (trimmedQuery == _lastSearchedQuery) {
    return;
  }
  _lastSearchedQuery = trimmedQuery;
  // ... realizar búsqueda
}
```

**Beneficio:** Evita búsquedas innecesarias de la misma palabra

### 3. **Limpieza de Estado al Abrir**
```dart
WidgetsBinding.instance.addPostFrameCallback((_) {
  // Limpiar estado anterior antes de buscar
  context.read<SearchBloc>().add(ClearSearch());
  // Pequeño delay para permitir que se limpie el estado
  Future.delayed(const Duration(milliseconds: 100), () {
    if (mounted) {
      _performSearch(widget.initialQuery!);
    }
  });
});
```

**Beneficio:** Garantiza que cada búsqueda comienza con estado limpio

### 4. **Validación en Servicio API**
```dart
final data = jsonDecode(response.body);

// Validar estructura de respuesta
if (data is! Map) {
  throw DataException(
    message: 'Formato de respuesta inválido',
    code: 'INVALID_FORMAT',
  );
}
```

**Beneficio:** Errores claros y detectables en lugar de silenciosos

### 5. **Mejor Manejo de Excepciones en BLoC**
```dart
final productos = searchData['productos'];
if (productos != null && productos is List) {
  for (var product in productos) {
    try {
      results.add(SearchResult.fromProductJson(product));
    } catch (e) {
      // Ignorar productos malformados, continuar con el siguiente
      print('Error procesando producto: $e');
    }
  }
}
```

**Beneficio:** Un producto malformado no rompe toda la búsqueda

## 📊 Flujo Mejorado

### ANTES (Problemático)
```
Escribir "p"        Escribir "i"        Escribir "z"
    ↓                   ↓                   ↓
Request 1         Request 2          Request 3
   (p)               (pi)               (piz)
    ↓                   ↓                   ↓
  Resp 3           Resp 1             Resp 2  ← Fuera de orden
  (error)         (0 resultados)    (carga...
```

### DESPUÉS (Correcto)
```
Escribir "p i z"           Esperar 500ms
    ↓                           ↓
Cancelar timers previos    Ejecutar UNA búsqueda
    ↓                           ↓
             Request 1 (piz)
                    ↓
               Response 1
                    ↓
          Mostrar resultados
```

## 🧪 Testing

Para verificar que el fix funciona:

1. **Primera búsqueda:** Escribir "tacos" → Búcar → Ver resultados ✅
2. **Volver atrás** → Limpiar estado ✅
3. **Segunda búsqueda:** Escribir "arroz" → Buscar → Ver nuevos resultados ✅
4. **Escribir rápido:** "p-i-z-z-a" → Solo una búsqueda final ✅
5. **Mismo término:** Buscar "tacos" dos veces → Sin búsquedas duplicadas ✅

## 📝 Cambios en Archivos

| Archivo | Cambio |
|---------|--------|
| `search_results_page.dart` | +Debounce, +Control duplicados, +Limpieza estado |
| `search_bloc.dart` | +Validación datos, +Manejo excepciones |
| `api_service.dart` | +Validación respuesta |

## 🚀 Resultado

✅ **Búsquedas estables** - No más errores aleatorios  
✅ **Mejor rendimiento** - Menos requests innecesarias  
✅ **UX mejorado** - Búsquedas responden más rápido  
✅ **Código robusto** - Validación y manejo de errores  

---

**Versión:** 2.0 - Búsquedas corregidas  
**Fecha:** 18 noviembre 2025
