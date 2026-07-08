import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';
import 'package:cuevana7_movies_app_cv/shared/http_utils.dart';

class ErrorView extends StatelessWidget {
  final RequestError error;
  final VoidCallback? onRetry;
  final VoidCallback? onBack;

  const ErrorView({
    super.key,
    required this.error,
    this.onRetry,
    this.onBack,
  });

  IconData get _icon {
    switch (error.type) {
      case ErrorType.network:
        return Icons.wifi_off_rounded;
      case ErrorType.notFound:
        return Icons.search_off_rounded;
      case ErrorType.server:
        return Icons.cloud_off_rounded;
      case ErrorType.unknown:
        return Icons.error_outline_rounded;
    }
  }

  String get _title {
    switch (error.type) {
      case ErrorType.network:
        return 'Sin conexion';
      case ErrorType.notFound:
        return 'No encontrado';
      case ErrorType.server:
        return 'Error del servidor';
      case ErrorType.unknown:
        return 'Error inesperado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 250;
        final iconSize = compact ? 36.0 : 64.0;
        final titleSize = compact ? 16.0 : 22.0;
        final msgSize = compact ? 13.0 : 15.0;
        final gap = compact ? 8.0 : 20.0;
        final spacing = compact ? 6.0 : 12.0;
        final btnSpacing = compact ? 16.0 : 32.0;

        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icon, size: iconSize, color: AppColors.hint),
                  SizedBox(height: gap),
                  Text(
                    _title,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: titleSize,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: spacing),
                  Text(
                    error.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.hint,
                      fontSize: msgSize,
                      fontFamily: 'InclusiveSans',
                    ),
                  ),
                  SizedBox(height: btnSpacing),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onBack != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _Button(
                            label: 'Volver',
                            onTap: onBack!,
                            outlined: true,
                            compact: compact,
                          ),
                        ),
                      if (onRetry != null)
                        _Button(label: 'Reintentar', onTap: onRetry!, compact: compact),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Button extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlined;
  final bool compact;

  const _Button({
    required this.label,
    required this.onTap,
    this.outlined = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 16 : 24,
          vertical: compact ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : AppColors.primary,
          borderRadius: BorderRadius.circular(24),
          border: outlined ? Border.all(color: AppColors.hint) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: outlined ? AppColors.hint : AppColors.white,
            fontSize: compact ? 13 : 15,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }
}
