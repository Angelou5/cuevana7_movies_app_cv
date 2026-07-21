import 'package:flutter/material.dart';
import 'package:cuevana7_movies_app_cv/resources/colors/colors.dart';

/// Formulario para crear/editar una reseña de usuario.
/// Se muestra como bottom sheet o inline.
class ReviewForm extends StatefulWidget {
  final String? initialContent;
  final int? initialRating;
  final String submitLabel;
  final Future<bool> Function(String content, int? rating) onSubmit;

  const ReviewForm({
    super.key,
    this.initialContent,
    this.initialRating,
    this.submitLabel = 'Publicar reseña',
    required this.onSubmit,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  late final TextEditingController _controller;
  int? _rating;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent ?? '');
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_controller.text.trim().isEmpty) return;
    if (_rating != null && (_rating! < 1 || _rating! > 5)) return;
    setState(() => _isSubmitting = true);
    final ok = await widget.onSubmit(_controller.text.trim(), _rating);
    if (mounted && ok) Navigator.of(context).pop();
    if (mounted) setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        decoration: const BoxDecoration(
          color: Color(0xFF1B1B1B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.hint,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tu reseña',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontFamily: 'InclusiveSans',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // ── Selector de estrellas ──
            Row(
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = _rating == starValue ? null : starValue;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      _rating != null && starValue <= _rating!
                          ? Icons.star
                          : Icons.star_border,
                      color: const Color(0xFFF0BB58),
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            if (_rating != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '$_rating de 5',
                  style: const TextStyle(
                    color: AppColors.hint,
                    fontSize: 12,
                    fontFamily: 'InclusiveSans',
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // ── Campo de texto ──
            TextField(
              controller: _controller,
              maxLines: 5,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontFamily: 'InclusiveSans',
              ),
              decoration: InputDecoration(
                hintText: 'Escribe tu opinión...',
                hintStyle: const TextStyle(
                  color: AppColors.hint,
                  fontFamily: 'InclusiveSans',
                ),
                filled: true,
                fillColor: const Color(0xFF282828),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Botón publicar ──
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        widget.submitLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'InclusiveSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
