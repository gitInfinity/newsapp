import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:newsapp/model/newsmodel.dart';
import 'package:intl/intl.dart';
import 'package:newsapp/widgets/gradient.dart';

class ArticlePage extends StatefulWidget {
  final Article? article;
  final Gemini gemini;

  const ArticlePage({super.key, this.article, required this.gemini});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  bool summarised = false;
  late String displayedContent;
  String get formattedDate {
    if (widget.article?.publishedAt == null) return '';
    final date = DateTime.tryParse(widget.article!.publishedAt);
    return date != null
        ? DateFormat('MMMM, yyyy').format(date)
        : widget.article!.publishedAt;
  }

  String stripHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  @override
  void initState() {
    super.initState();
    displayedContent =
        'Content: ${stripHtmlTags(widget.article?.content ?? '')}';
  }

  void summariseArticle() async {
    setState(() {
      summarised = true;
      displayedContent = "Summarising...";
    });

    try {
      final response = await widget.gemini.prompt(
        model: "Summarise this article:",
        parts: [Part.text(widget.article?.content ?? '')],
      );

      // Optional: keep the loading visible for at least 700ms so the animation is noticeable
      await Future.delayed(const Duration(milliseconds: 700));

      final summary = (response?.output ?? "").trim();
      setState(() {
        displayedContent = summary.isNotEmpty
            ? summary
            : "No summary generated.";
      });
    } catch (e) {
      setState(() {
        displayedContent = "Error: $e";
      });
    } finally {
      // Always turn off the loading indicator
      setState(() {
        summarised = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: widget.article?.source.name.toString() ?? 'Article'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.article?.urlToImage != null &&
                widget.article!.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.article!.urlToImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              widget.article?.title ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.article?.description ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: summarised
                  ? Row(
                      key: const ValueKey("loading"),
                      children: const [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Summarising...",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    )
                  : Text(
                      displayedContent,
                      key: ValueKey(
                        displayedContent,
                      ), // key changes when content changes
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: summariseArticle,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Summarise by Gemini"),
            ),
            const SizedBox(height: 12),
            Text(
              'Published on: $formattedDate',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
