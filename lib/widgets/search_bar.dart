import 'package:flutter/material.dart';
import '../core/theme.dart';

class MusicSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onCleared;
  final String hint;

  const MusicSearchBar({
    super.key,
    required this.onChanged,
    this.onCleared,
    this.hint = 'Search 90 million songs...',
  });

  @override
  State<MusicSearchBar> createState() => _MusicSearchBarState();
}

class _MusicSearchBarState extends State<MusicSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    widget.onCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt.withOpacity(0.85),
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: AppTheme.textSecondary, size: 18),
                  onPressed: _clear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }
}