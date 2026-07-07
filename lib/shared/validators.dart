class EmailValidationResult {
  final bool isValid;
  final String? error;
  final List<EmailCheck> checks;

  const EmailValidationResult({
    this.isValid = false,
    this.error,
    this.checks = const [],
  });
}

class EmailCheck {
  final String label;
  final bool satisfied;

  const EmailCheck(this.label, this.satisfied);
}

final RegExp _emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9][a-zA-Z0-9.-]*\.[a-zA-Z]{2,}$',
);

bool _tieneSegmentosRepetidos(String dominio) {
  final partes = dominio.split('.');
  if (partes.length > 3) return true;
  for (int i = 0; i < partes.length; i++) {
    int count = partes.where((p) => p == partes[i]).length;
    if (count > 1 && partes.length > 2) return true;
  }
  return false;
}

bool _tienePuntoDoble(String email) {
  return email.contains('..');
}

String? validateEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'El correo es obligatorio';
  v = v.trim();

  if (_tienePuntoDoble(v)) return 'El correo no puede contener ".."';

  final despuesArroba = v.contains('@') ? v.split('@').last : '';
  if (despuesArroba.startsWith('.')) {
    return 'El dominio no puede empezar con un punto';
  }
  if (despuesArroba.endsWith('.')) {
    return 'El dominio no puede terminar con un punto';
  }

  if (!_emailRegex.hasMatch(v)) {
    if (!v.contains('@')) return 'Falta el @ en el correo';
    if (!despuesArroba.contains('.')) {
      return 'Falta un dominio válido (ej. .com, .org)';
    }
    return 'Formato de correo inválido';
  }

  final dominio = v.split('@').last;
  if (_tieneSegmentosRepetidos(dominio)) {
    return 'El dominio del correo no es válido';
  }

  return null;
}

List<EmailCheck> emailChecks(String value) {
  if (value.isEmpty) return [];
  final v = value.trim();

  return [
    EmailCheck('Contiene @', v.contains('@')),
    EmailCheck('Texto antes del @', v.contains('@') && v.split('@').first.isNotEmpty),
    EmailCheck('Dominio después del @', v.contains('@') && v.split('@').last.isNotEmpty),
    EmailCheck(
      'Sin puntos dobles (..)',
      !_tienePuntoDoble(v),
    ),
    EmailCheck(
      'Dominio no empieza con punto',
      !v.contains('@') || !v.split('@').last.startsWith('.'),
    ),
    EmailCheck(
      'Dominio no termina con punto',
      !v.contains('@') || !v.split('@').last.endsWith('.'),
    ),
    EmailCheck(
      'Sin segmentos repetidos',
      !v.contains('@') || !_tieneSegmentosRepetidos(v.split('@').last),
    ),
  ];
}
