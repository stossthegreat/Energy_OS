import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/energy_provider.dart';
import '../providers/user_provider.dart';
import '../utils/theme.dart';
import 'gradient_button.dart';

class CoachAskWidget extends ConsumerStatefulWidget {
  final String tabType; // 'mind', 'train', 'fuel'
  final String placeholder;
  final List<String> gradientColors;

  const CoachAskWidget({
    Key? key,
    required this.tabType,
    required this.placeholder,
    required this.gradientColors,
  }) : super(key: key);

  @override
  ConsumerState<CoachAskWidget> createState() => _CoachAskWidgetState();
}

class _CoachAskWidgetState extends ConsumerState<CoachAskWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _response;
  bool _showResponse = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _showResponse = false;
    });

    try {
      final api = ref.read(energyAPIProvider);
      final response = await api.askCoach(widget.tabType, _controller.text);

      setState(() {
        _response = response;
        _showResponse = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleSave() async {
    if (_response == null) return;

    try {
      final db = ref.read(databaseServiceProvider);
      final user = await ref.read(userDataProvider.future);

      if (user != null) {
        await db.createRecommendation({
          'user_id': user.id,
          'tab': widget.tabType,
          'query': _controller.text,
          'output_json': _response,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved to your planner! ✓'),
            backgroundColor: Color(0xFF34d399),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input Panel
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology_outlined,
                    color: Colors.white.withOpacity(0.6),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Ask the Coach',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.mic_outlined,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    onPressed: () {
                      // TODO: Open voice input screen
                    },
                  ),
                ),
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              GradientButton(
                text: _isLoading ? 'Thinking...' : 'Ask Coach',
                onPressed: _handleSubmit,
                gradientColors: widget.gradientColors,
                icon: Icons.send,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),

        // Response Card
        if (_showResponse && _response != null) ...[
          const SizedBox(height: 24),
          _buildResponseCard(),
        ],
      ],
    );
  }

  Widget _buildResponseCard() {
    if (_response == null) return const SizedBox();

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.createGradient(widget.gradientColors).scale(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.hexToColor(widget.gradientColors[0]).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Gradient top bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: AppTheme.createGradient(widget.gradientColors),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppTheme.createGradient(widget.gradientColors),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _response!['title'] ?? 'Recommendation',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (_response!['subtitle'] != null)
                            Text(
                              _response!['subtitle'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Steps or content
                if (_response!['steps'] != null)
                  ..._buildSteps(_response!['steps'] as List),

                const SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: 'Save to Planner',
                        onPressed: _handleSave,
                        gradientColors: widget.gradientColors,
                        icon: Icons.bookmark_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showResponse = false;
                        });
                      },
                      icon: const Icon(Icons.close),
                      color: Colors.white.withOpacity(0.6),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSteps(List steps) {
    return steps.asMap().entries.map((entry) {
      final index = entry.key;
      final step = entry.value;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppTheme.createGradient(widget.gradientColors),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                step.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

extension _GradientScale on Gradient {
  Gradient scale(double opacity) {
    if (this is LinearGradient) {
      final linear = this as LinearGradient;
      return LinearGradient(
        colors: linear.colors.map((c) => c.withOpacity(opacity)).toList(),
        begin: linear.begin,
        end: linear.end,
      );
    }
    return this;
  }
}

