import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../domain/entities/movie.dart';

/// Genera un PDF con el listado de películas favoritas del usuario.
class FavoritesPdfService {
  /// Descarga la imagen del póster de una película. Si falla o no existe,
  /// devuelve null para que el PDF muestre un placeholder en su lugar.
  static Future<Uint8List?> _fetchImage(String url) async {
    if (url.isEmpty) return null;
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (_) {
      // Ignoramos errores de red: el póster simplemente no se mostrará.
    }
    return null;
  }

  static String _formatDate(DateTime date) {
    const meses = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${meses[date.month - 1]} ${date.year}';
  }

  /// Construye el documento PDF a partir de la lista de películas.
  static Future<Uint8List> generate(List<Movie> favorites) async {
    final doc = pw.Document();

    // Descargamos los pósters en paralelo antes de armar el documento.
    final posterBytes = await Future.wait(
      favorites.map((m) => _fetchImage(m.posterPath)),
    );

    const itemsPerPage = 6;
    final totalPages = (favorites.length / itemsPerPage).ceil().clamp(
      1,
      1 << 30,
    );

    for (var page = 0; page < totalPages; page++) {
      final start = page * itemsPerPage;
      final end = (start + itemsPerPage).clamp(0, favorites.length);
      final pageItems = favorites.sublist(start, end);
      final pageImages = posterBytes.sublist(start, end);

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (page == 0) ...[
                  pw.Text(
                    'Mis películas favoritas',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${favorites.length} película${favorites.length == 1 ? '' : 's'} guardada${favorites.length == 1 ? '' : 's'}',
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                  pw.SizedBox(height: 16),
                ],
                pw.Expanded(
                  child: pw.ListView.builder(
                    itemCount: pageItems.length,
                    itemBuilder: (context, index) {
                      final movie = pageItems[index];
                      final image = pageImages[index];

                      return pw.Container(
                        margin: const pw.EdgeInsets.only(bottom: 14),
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.grey300,
                            width: 0.5,
                          ),
                          borderRadius: pw.BorderRadius.circular(6),
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 60,
                              height: 90,
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey200,
                                borderRadius: pw.BorderRadius.circular(4),
                              ),
                              child: image != null
                                  ? pw.ClipRRect(
                                      horizontalRadius: 4,
                                      verticalRadius: 4,
                                      child: pw.Image(
                                        pw.MemoryImage(image),
                                        fit: pw.BoxFit.cover,
                                      ),
                                    )
                                  : pw.Center(
                                      child: pw.Text(
                                        'Sin\nimagen',
                                        textAlign: pw.TextAlign.center,
                                        style: const pw.TextStyle(
                                          fontSize: 7,
                                          color: PdfColors.grey600,
                                        ),
                                      ),
                                    ),
                            ),
                            pw.SizedBox(width: 12),
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    movie.title,
                                    style: pw.TextStyle(
                                      fontSize: 13,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  if (movie.originalTitle.isNotEmpty &&
                                      movie.originalTitle != movie.title)
                                    pw.Text(
                                      movie.originalTitle,
                                      style: pw.TextStyle(
                                        fontSize: 9,
                                        fontStyle: pw.FontStyle.italic,
                                        color: PdfColors.grey700,
                                      ),
                                    ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    'Estreno: ${_formatDate(movie.releaseDate)}',
                                    style: const pw.TextStyle(fontSize: 9),
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    'Puntuación: ${movie.voteAverage.toStringAsFixed(1)} / 10',
                                    style: const pw.TextStyle(fontSize: 9),
                                  ),
                                  if (movie.overview.isNotEmpty) ...[
                                    pw.SizedBox(height: 4),
                                    pw.Text(
                                      movie.overview,
                                      maxLines: 3,
                                      overflow: pw.TextOverflow.clip,
                                      style: const pw.TextStyle(
                                        fontSize: 8,
                                        color: PdfColors.grey800,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return doc.save();
  }

  /// Genera el PDF y abre el diálogo nativo de compartir / guardar / imprimir.
  static Future<void> generateAndShare(List<Movie> favorites) async {
    final bytes = await generate(favorites);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'mis_peliculas_favoritas.pdf',
    );
  }
}
