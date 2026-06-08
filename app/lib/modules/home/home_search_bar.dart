import 'package:flutter/material.dart';

class HomeSearchBar extends StatefulWidget {
  final Widget title;
  final List<Widget> actions;

  const HomeSearchBar({
    super.key,
    required this.title,
    this.actions = const [],
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  static const int _minLength = 3;

  final TextEditingController _controller = TextEditingController();
  bool _open = false;

  String get _text => _controller.text.trim();
  bool get _ready => _text.length >= _minLength;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _open = !_open;
      if (!_open) _controller.clear();
    });
  }

  void _onChanged(String value) {
    setState(() {});
  }

  void _search() {
    if (!_ready) {
      _showMessage('Digite ao menos $_minLength letras');
      return;
    }
    _showMessage('Buscando: $_text');
  }

  void _clear() {
    setState(() => _controller.clear());
    _showMessage('Campo limpo');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: _open ? _buildSearch() : _buildTitleRow(),
    );
  }

  Widget _buildTitleRow() {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.title,
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                iconSize: 28,
                onPressed: _toggleSearch,
              ),
              ...widget.actions,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    final count = _text.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 56,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Close',
                onPressed: _toggleSearch,
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: _onChanged,
                  onSubmitted: (_) => _search(),
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search',
                onPressed: _ready ? _search : null,
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear',
                onPressed: _clear,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8),
            child: Text(
              _ready
                  ? 'Pronto para buscar ($count letras)'
                  : '$count/$_minLength letras',
              style: TextStyle(
                fontSize: 12,
                color: _ready ? Colors.green.shade700 : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
