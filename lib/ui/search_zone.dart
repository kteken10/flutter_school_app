import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'input_field.dart';

class SearchZone extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onMicPressed;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final bool showSearchIcon;
  final double spacing;
  final bool autofocus;

  const SearchZone({
    super.key,
    required this.controller,
    this.onCameraPressed,
    this.onMicPressed,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search',
    this.showSearchIcon = true,
    this.spacing = 12.0,
    this.autofocus = false,
  });

  @override
  State<SearchZone> createState() => _SearchZoneState();
}

class _SearchZoneState extends State<SearchZone> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateClearButtonVisibility);
    _updateClearButtonVisibility();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearButtonVisibility);
    super.dispose();
  }

  void _updateClearButtonVisibility() {
    setState(() {
      _showClearButton = widget.controller.text.isNotEmpty;
    });
  }

  void _onClearPressed() {
    widget.controller.clear();
    if (widget.onChanged != null) {
      widget.onChanged!('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Champ de recherche étendu
          Expanded(
            child: InputField(
              controller: widget.controller,
              keyboardType: TextInputType.text,
              obscureText: false,
              showSearchIcon: widget.showSearchIcon,
              hintText: widget.hintText,
              borderColor: Colors.transparent,
              // autofocus: widget.autofocus,
              // onChanged: widget.onChanged,
              // onSubmitted: widget.onSubmitted,
              suffixIcon: _buildSuffixIcons(),
            ),
          ),

          // Espacement
          SizedBox(width: widget.spacing),

          // Bouton caméra parfaitement aligné
          if (widget.onCameraPressed != null)
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(top: 8),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 20, color: AppColors.textSecondary),
                onPressed: widget.onCameraPressed,
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.textSecondary.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: AppColors.textSecondary, width: 1),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget? _buildSuffixIcons() {
    final List<Widget> icons = [];

    if (_showClearButton) {
      icons.add(
        IconButton(
          icon: const Icon(Icons.clear, size: 20, color: AppColors.textSecondary),
          onPressed: _onClearPressed,
          padding: EdgeInsets.zero,
        ),
      );
    }

    if (widget.onMicPressed != null) {
      icons.add(
        IconButton(
          icon: const Icon(Icons.mic, color: AppColors.textSecondary),
          onPressed: widget.onMicPressed,
          padding: EdgeInsets.zero,
        ),
      );
    }

    if (icons.isEmpty) return null;
    if (icons.length == 1) return icons.first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons,
    );
  }
}