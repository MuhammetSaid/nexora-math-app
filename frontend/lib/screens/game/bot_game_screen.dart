import 'dart:math';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/game/puzzle.dart';
import '../../services/game/puzzle_repository.dart';
import '../../services/api/level_service.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';
import '../../utils/constants.dart';
import '../../widgets/game/answer_bar.dart';
import '../../widgets/game/nexora_background.dart';
import '../../widgets/game/numeric_keypad.dart';
import '../../widgets/game/puzzle_card.dart';
import '../settings/settings_screen.dart';
import 'question_screen.dart';

class BotGameScreen extends StatefulWidget {
  const BotGameScreen({
    super.key,
    required this.difficulty,
    required this.difficultyName,
    required this.difficultyColor,
  });

  final int difficulty; // 1-5 arası zorluk seviyesi
  final String difficultyName; // Başlangıç, Amatör, vb.
  final Color difficultyColor;

  @override
  State<BotGameScreen> createState() => _BotGameScreenState();
}

class _BotGameScreenState extends State<BotGameScreen> {
  final AnswerController _answer = AnswerController();
  final Random _random = Random();
  final Set<int> _usedLevels = {}; // Kullanılmış level'lar

  int _playerScore = 0; // Kullanıcının skoru
  int _botScore = 0; // Botun skoru
  int _currentRound = 1; // Kaçıncı tur (1-5)
  int _currentLevel = 1; // Mevcut level numarası

  Map<String, dynamic>? _levelData; // Backend'den gelen level verisi
  bool _isLoading = true; // Yükleniyor mu?
  bool _hasError = false; // Hata var mı?

  @override
  void initState() {
    super.initState();
    _loadRandomLevel();
  }

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  /// 1-50 arası rastgele bir level seçer ve yükler
  Future<void> _loadRandomLevel() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Kullanılmamış level seç
      int newLevel;
      int attempts = 0;
      do {
        newLevel = _random.nextInt(7) + 1; // 1-50 arası
        attempts++;
        // Sonsuz döngüyü önle (50 deneme sonra sıfırla)
        if (attempts > 100) {
          _usedLevels.clear();
        }
      } while (_usedLevels.contains(newLevel) && _usedLevels.length < 7);

      _currentLevel = newLevel;
      _usedLevels.add(newLevel);
      print(
        '🎲 Seçilen level: $_currentLevel (Kullanılan: ${_usedLevels.length})',
      );

      // Backend'den level bilgisini çek
      final levelData = await LevelService.getLevel(_currentLevel);

      if (levelData != null) {
        setState(() {
          _levelData = levelData;
          _isLoading = false;
        });
        print('✅ Level $_currentLevel başarıyla yüklendi');
        print('📝 Cevap: ${levelData['answer_value']}');
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
        print('❌ Level $_currentLevel yüklenemedi');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print('❌ Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      body: NexoraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              children: <Widget>[
                // Özel Bot AppBar
                _buildBotAppBar(),
                const SizedBox(height: AppSpacing.md),

                // Skor Göstergesi (5 kutu)
                _buildScoreIndicator(),
                const SizedBox(height: AppSpacing.lg),

                // Puzzle Card
                Expanded(
                  child: _isLoading
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColors.panel.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.difficultyColor,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Soru yükleniyor...',
                                  style: AppTextStyles.body.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _hasError
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColors.panel.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                  size: 48,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  'Soru yüklenemedi',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                ElevatedButton(
                                  onPressed: _loadRandomLevel,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widget.difficultyColor,
                                  ),
                                  child: const Text('Tekrar Dene'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : PuzzleCard(
                          lines: const [], // Backend'den gelecek
                          imagePath: _levelData?['image_path'] ?? '',
                          level: _currentLevel,
                        ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Answer Bar
                AnswerBar(
                  answerListenable: _answer,
                  onClearLast: _answer.removeLast,
                  onClearAll: _answer.clear,
                  onHint: () => _showHintDialog(context),
                  onEnter: _handleAnswer,
                  answerLabel: l10n.answerLabel,
                  enterLabel: l10n.enter,
                  hintLabel: l10n.hint,
                  answer: _levelData?['answer_value']?.toString() ?? '',
                  hint1: _levelData?['hint1']?.toString() ?? '',
                  hint2: _levelData?['hint2']?.toString() ?? '',
                  solutionExplanation:
                      _levelData?['solution_explanation']?.toString() ?? '',
                  useCustomHandler: true, // Bot oyunu için özel handler
                ),
                const SizedBox(height: AppSpacing.sm),

                // Numeric Keypad
                NumericKeypad(
                  layout: const <List<String>>[
                    <String>['1', '2', '3', '4', '5'],
                    <String>['6', '7', '8', '9', '0'],
                  ],
                  highlightedValues: const <String>{},
                  onKeyTap: _answer.append,
                ),
                const SizedBox(height: AppSpacing.md),

                // Footer
                _FooterMetaBar(
                  onSettingsTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBotAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: widget.difficultyColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Geri butonu
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.keypadTile,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.goldAccent,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Bot ikonu
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.difficultyColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(
              Icons.smart_toy_rounded,
              color: widget.difficultyColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Zorluk seviyesi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bot Mücadelesi',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.mutedText,
                    fontSize: 11,
                  ),
                ),
                Text(
                  widget.difficultyName,
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Yıldız göstergesi
          Row(
            children: List.generate(
              widget.difficulty,
              (index) => Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Icon(
                  Icons.star,
                  color: const Color(0xFFFFD700),
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Column(
        children: [
          // Üst kısım - Bot vs Oyuncu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Bot
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: widget.difficultyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.smart_toy_rounded,
                      color: widget.difficultyColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bot',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Skor
              Text(
                '$_botScore - $_playerScore',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Oyuncu
              Row(
                children: [
                  Text(
                    'Siz',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF4CAF50),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 5 Kutulu Gösterge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              // Skoru belirle
              Color boxColor;
              IconData? icon;

              if (index < _playerScore) {
                // Oyuncu kazandı
                boxColor = const Color(0xFF4CAF50);
                icon = Icons.check;
              } else if (index < _botScore) {
                // Bot kazandı
                boxColor = widget.difficultyColor;
                icon = Icons.close;
              } else if (index == _currentRound - 1) {
                // Aktif tur
                boxColor = AppColors.goldAccent;
                icon = Icons.sports_esports;
              } else {
                // Henüz oynanmadı
                boxColor = AppColors.keypadTile;
                icon = null;
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: boxColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: boxColor, width: 2),
                ),
                child: Center(
                  child: icon != null
                      ? Icon(icon, color: boxColor, size: 24)
                      : Text(
                          '${index + 1}',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.mutedText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void _handleAnswer() {
    print('🔵 _handleAnswer() ÇAĞRILDI!');
    print(
      '   Mevcut skor - Oyuncu: $_playerScore, Bot: $_botScore, Tur: $_currentRound',
    );

    if (_levelData == null) {
      print('⚠️ Level verisi yok!');
      return;
    }

    final String correctAnswer = _levelData!['answer_value']?.toString() ?? '';
    final String userAnswer = _answer.value.trim();

    print('🎯 Cevap kontrol ediliyor...');
    print('   Kullanıcı cevabı: "$userAnswer"');
    print('   Doğru cevap: "$correctAnswer"');
    print(
      '   Uzunluklar - Kullanıcı: ${userAnswer.length}, Doğru: ${correctAnswer.length}',
    );

    if (userAnswer.isEmpty) {
      print('⚠️ Boş cevap!');
      return;
    }

    // Cevabı hemen temizle
    _answer.clear();
    print('🧹 Cevap temizlendi');

    // Cevap kontrolü
    if (userAnswer == correctAnswer) {
      // Doğru cevap - Oyuncu puan kazandı
      print('✅ DOĞRU CEVAP!');
      print('   Önceki skor: $_playerScore, Önceki tur: $_currentRound');

      setState(() {
        _playerScore++;
        _currentRound++;
      });

      print(
        '📊 YENİ SKOR - Oyuncu: $_playerScore, Bot: $_botScore, Tur: $_currentRound',
      );
      print('🎭 Dialog gösteriliyor...');

      _showResultDialog(true);
    } else {
      // Yanlış cevap - Bot puan kazandı
      print('❌ YANLIŞ CEVAP!');
      print('   Önceki skor: $_botScore, Önceki tur: $_currentRound');

      setState(() {
        _botScore++;
        _currentRound++;
      });

      print(
        '📊 YENİ SKOR - Oyuncu: $_playerScore, Bot: $_botScore, Tur: $_currentRound',
      );
      print('🎭 Dialog gösteriliyor...');

      _showResultDialog(false);
    }
  }

  void _showResultDialog(bool isCorrect) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: isCorrect
                    ? const Color(0xFF4CAF50)
                    : widget.difficultyColor,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect
                      ? const Color(0xFF4CAF50)
                      : widget.difficultyColor,
                  size: 64,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  isCorrect ? 'Doğru Cevap!' : 'Yanlış Cevap!',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  isCorrect ? 'Bir puan kazandınız!' : 'Bot bir puan kazandı!',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.mutedText,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () async {
                    print('▶️ "Devam Et" butonuna basıldı');
                    print(
                      '   Mevcut durum - Oyuncu: $_playerScore, Bot: $_botScore, Tur: $_currentRound',
                    );

                    Navigator.pop(context);
                    print('🚪 Dialog kapatıldı');

                    // 5 tur tamamlandıysa oyunu bitir
                    if (_currentRound > 5) {
                      print('🏁 5 tur tamamlandı, oyun bitiyor...');
                      _showGameOverDialog();
                    } else {
                      // Yeni soru yükle
                      print('📥 Yeni soru yükleniyor...');
                      await _loadRandomLevel();
                      print('✅ Yeni soru yüklendi');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: Text(
                    _currentRound > 5 ? 'Sonuçları Gör' : 'Devam Et',
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showGameOverDialog() {
    final bool playerWon = _playerScore > _botScore;
    final bool isDraw = _playerScore == _botScore;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.goldAccent, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  playerWon
                      ? Icons.emoji_events
                      : isDraw
                      ? Icons.handshake
                      : Icons.sentiment_dissatisfied,
                  color: AppColors.goldAccent,
                  size: 64,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  playerWon
                      ? 'Tebrikler!'
                      : isDraw
                      ? 'Berabere!'
                      : 'Kaybettiniz!',
                  style: AppTextStyles.heading1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$_playerScore - $_botScore',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.goldAccent,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (playerWon && widget.difficulty == 5) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9C27B0).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '+5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset('assets/elmas.png', width: 24, height: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.panelBorder),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: Text(
                          'Çıkış',
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          // Skorları ve level geçmişini sıfırla
                          setState(() {
                            _playerScore = 0;
                            _botScore = 0;
                            _currentRound = 1;
                            _usedLevels.clear();
                          });
                          // Yeni soru yükle
                          await _loadRandomLevel();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldAccent,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: Text(
                          'Tekrar Oyna',
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: AppColors.background,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showHintDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.goldAccent, width: 1.4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'İpucu Kullan',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Bot oyununda ipucu kullanılamaz!',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                  ),
                  child: Text(
                    'Tamam',
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FooterMetaBar extends StatelessWidget {
  const _FooterMetaBar({this.onSettingsTap});

  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.keypadSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const _FooterMeta(icon: Icons.emoji_events_outlined, label: 'Trophy'),
          const _FooterMeta(icon: Icons.person_outline, label: 'Profile'),
          _FooterMeta(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: onSettingsTap,
          ),
        ],
      ),
    );
  }
}

class _FooterMeta extends StatelessWidget {
  const _FooterMeta({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: AppColors.goldAccent, size: 22),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.mutedText,
            fontSize: 12,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}
