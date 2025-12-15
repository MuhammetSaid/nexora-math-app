import 'dart:math';
import 'package:flutter/material.dart';

import 'dart:async';
import '../../l10n/app_localizations.dart';
import '../../services/api/level_service.dart';
import '../../services/api/bot_service.dart';
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

  // Yarış sistemi için
  bool _botSolving = false; // Bot çözüyor mu?
  bool _questionSolved = false; // Soru çözüldü mü? (ilk çözen için)
  String? _botAnswer; // Bot'un cevabı
  double _botSolveTime = 0.0; // Bot'un çözüm süresi
  Timer? _botTimer; // Bot çözüm timer'ı
  Future<Map<String, dynamic>?>? _botSolveFuture; // Bot çözüm future'ı
  String _botCurrentMessage = ''; // Bot'un şu anki mesajı
  List<String> _botThinkingMessages = []; // Bot'un düşünme mesajları
  String _botSolvedMessage = ''; // Bot'un çözdükten sonraki mesajı

  @override
  void initState() {
    super.initState();
    _loadRandomLevel();
  }

  @override
  void dispose() {
    _answer.dispose();
    _botTimer?.cancel();
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
          _questionSolved = false; // Yeni soru için sıfırla
          _botSolving = false;
          _botAnswer = null;
          _botSolveTime = 0.0;
          _botCurrentMessage = '';
          _botThinkingMessages = [];
          _botSolvedMessage = '';
          _answer.clear();
        });
        print('✅ Level $_currentLevel başarıyla yüklendi');
        print('📝 Cevap: ${levelData['answer_value']}');

        // Bot çözümünü başlat (yarış başlıyor!)
        try {
          _startBotSolving();
        } catch (e, stackTrace) {
          print('❌ Bot çözüm başlatma hatası: $e');
          print('Stack trace: $stackTrace');
          // Hata olsa bile oyun devam etsin
        }
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
    try {
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
    } catch (e, stackTrace) {
      print('❌ Build hatası: $e');
      print('Stack trace: $stackTrace');
      // Hata durumunda basit bir hata ekranı göster
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Bir hata oluştu: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Text('Geri Dön'),
              ),
            ],
          ),
        ),
      );
    }
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
              Flexible(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _botSolving
                            ? widget.difficultyColor.withOpacity(0.4)
                            : widget.difficultyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: _botSolving
                            ? Border.all(
                                color: widget.difficultyColor,
                                width: 2,
                              )
                            : null,
                      ),
                      child: _botSolving
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.difficultyColor,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.smart_toy_rounded,
                              color: widget.difficultyColor,
                              size: 20,
                            ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Bot',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_botSolving && _botCurrentMessage.isNotEmpty)
                            Text(
                              _botCurrentMessage,
                              style: AppTextStyles.caption.copyWith(
                                color: widget.difficultyColor,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          else if (_botCurrentMessage.isNotEmpty &&
                              !_botSolving)
                            Text(
                              _botCurrentMessage,
                              style: AppTextStyles.caption.copyWith(
                                color: widget.difficultyColor,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  /// Bot çözümünü başlatır (yarış başlar!)
  void _startBotSolving() {
    if (_levelData == null) {
      print('⚠️ Level data null, bot çözümü başlatılamıyor');
      return;
    }

    try {
      if (!mounted) return;

      setState(() {
        _botSolving = true;
        _botCurrentMessage = 'Soruyu inceliyorum... 🤖';
      });

      print('🤖 Bot çözümü başlatıldı...');

      // Bot çözümünü başlat
      _botSolveFuture = BotService.solveQuestion(
        levelId: _levelData!['level_id'] ?? '',
        difficulty: widget.difficulty,
        hint1: _levelData!['hint1'] ?? '',
        hint2: _levelData!['hint2'] ?? '',
        solutionExplanation: _levelData!['solution_explanation'] ?? '',
        answerValue: _levelData!['answer_value']?.toString() ?? '',
      );

      // Bot çözümünü dinle - düşünme mesajlarını göster
      _simulateBotThinking();

      // Bot çözümünü dinle
      _botSolveFuture!
          .then((result) {
            if (result != null && mounted && !_questionSolved) {
              // Soru henüz çözülmediyse bot'un cevabını kontrol et
              _handleBotAnswer(result);
            }
          })
          .catchError((error, stackTrace) {
            print('❌ Bot çözüm hatası: $error');
            print('Stack trace: $stackTrace');
            if (mounted) {
              setState(() {
                _botSolving = false;
                _botCurrentMessage = '';
              });
            }
          });
    } catch (e, stackTrace) {
      print('❌ _startBotSolving exception: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _botSolving = false;
          _botCurrentMessage = '';
        });
      }
    }
  }

  /// Bot'un düşünme sürecini simüle eder (mesajları gösterir)
  void _simulateBotThinking() {
    // Düşünme mesajları backend'den gelecek, şimdilik timer ile simüle et
    int messageIndex = 0;
    const thinkingMessages = [
      'Hmm, ilginç bir soru... 🤔',
      'Bir dakika, düşüneyim... 💭',
      'Bu biraz zormuş gibi görünüyor 😅',
      'İpuçlarına bakayım... 🔍',
      'Bekle, çözüyorum... ⚙️',
      'Ah, şimdi anladım! 💡',
    ];

    _botTimer?.cancel();
    _botTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted || !_botSolving || _questionSolved) {
        timer.cancel();
        return;
      }

      if (messageIndex < thinkingMessages.length) {
        setState(() {
          _botCurrentMessage = thinkingMessages[messageIndex];
        });
        messageIndex++;
      }
    });
  }

  /// Bot'un cevabını işler
  void _handleBotAnswer(Map<String, dynamic> botResult) {
    if (_questionSolved) return; // Soru zaten çözüldü

    _botTimer?.cancel(); // Timer'ı durdur

    final String botAnswer = botResult['answer']?.toString() ?? '';
    final String correctAnswer = _levelData!['answer_value']?.toString() ?? '';
    final double solveTime = (botResult['solve_time'] ?? 0.0).toDouble();

    // Backend'den gelen mesajları al
    final List<dynamic> thinkingMsgs = botResult['thinking_messages'] ?? [];
    final String solvedMsg = botResult['solved_message']?.toString() ?? '';

    print('🤖 Bot cevap verdi: $botAnswer');
    print('🤖 Bot çözüm süresi: ${solveTime}s');

    if (botAnswer == correctAnswer) {
      // Bot doğru cevabı buldu!
      setState(() {
        _questionSolved = true;
        _botSolving = false;
        _botAnswer = botAnswer;
        _botSolveTime = solveTime;
        _botCurrentMessage = solvedMsg.isNotEmpty
            ? solvedMsg
            : 'Çözdüm! $solveTime saniyede! 🎉';
        _botThinkingMessages = thinkingMsgs.map((e) => e.toString()).toList();
        _botSolvedMessage = solvedMsg;
        _botScore++;
        _currentRound++;
      });

      print('🤖 Bot DOĞRU cevabı buldu!');
      print('🤖 Bot mesajı: ${_botCurrentMessage}');
      print(
        '📊 YENİ SKOR - Oyuncu: $_playerScore, Bot: $_botScore, Tur: $_currentRound',
      );

      // Bot kazandı dialogunu göster
      _showResultDialog(false, botWon: true);
    } else {
      // Bot yanlış cevap verdi, çözüm devam ediyor
      setState(() {
        _botSolving = false;
        _botAnswer = botAnswer;
        _botCurrentMessage = '';
      });
      print('🤖 Bot yanlış cevap verdi, yarış devam ediyor...');
    }
  }

  /// Kullanıcı cevabını işler (yarış mantığı ile)
  void _handleAnswer() {
    print('🔵 _handleAnswer() ÇAĞRILDI!');
    print(
      '   Mevcut skor - Oyuncu: $_playerScore, Bot: $_botScore, Tur: $_currentRound',
    );

    if (_levelData == null) {
      print('⚠️ Level verisi yok!');
      return;
    }

    if (_questionSolved) {
      print('⚠️ Soru zaten çözüldü!');
      return;
    }

    final String correctAnswer = _levelData!['answer_value']?.toString() ?? '';
    final String userAnswer = _answer.value.trim();

    print('🎯 Cevap kontrol ediliyor...');
    print('   Kullanıcı cevabı: "$userAnswer"');
    print('   Doğru cevap: "$correctAnswer"');

    if (userAnswer.isEmpty) {
      print('⚠️ Boş cevap!');
      return;
    }

    // Cevabı hemen temizle
    _answer.clear();
    print('🧹 Cevap temizlendi');

    // Cevap kontrolü
    if (userAnswer == correctAnswer) {
      // Doğru cevap - Oyuncu ilk çözdü ve puan kazandı!
      print('✅ OYUNCU DOĞRU CEVAP VERDİ!');

      setState(() {
        _questionSolved = true; // Soru çözüldü, bot artık cevap veremez
        _botSolving = false;
        _playerScore++;
        _currentRound++;
      });

      print(
        '📊 YENİ SKOR - Oyuncu: $_playerScore, Bot: $_botScore, Tur: $_currentRound',
      );
      print('🎭 Dialog gösteriliyor...');

      _showResultDialog(true, playerWon: true);
    } else {
      // Yanlış cevap - Bot hala çözebilir, oyuncu tekrar deneyebilir
      print('❌ YANLIŞ CEVAP! Bot çözmeye devam ediyor...');

      // Yanlış cevap dialogu göster ama puan kazanma!
      _showWrongAnswerDialog();
    }
  }

  /// Yanlış cevap dialogu (puan kazanılmaz, yarış devam eder)
  void _showWrongAnswerDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: Colors.redAccent, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close, color: Colors.redAccent, size: 64),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Yanlış Cevap!',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Tekrar deneyin! Bot hala çözmeye çalışıyor...',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: AppSpacing.md,
                    ),
                  ),
                  child: Text(
                    'Devam Et',
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: Colors.white,
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

  /// Sonuç dialogu (doğru cevap veya bot kazandı)
  void _showResultDialog(
    bool isPlayerCorrect, {
    bool playerWon = false,
    bool botWon = false,
  }) {
    final bool actualWin = playerWon || (isPlayerCorrect && !botWon);

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
                color: actualWin
                    ? const Color(0xFF4CAF50)
                    : widget.difficultyColor,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  actualWin ? Icons.check_circle : Icons.smart_toy_rounded,
                  color: actualWin
                      ? const Color(0xFF4CAF50)
                      : widget.difficultyColor,
                  size: 64,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  actualWin ? 'Kazandınız! 🎉' : 'Bot Kazandı! 🤖',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  actualWin
                      ? 'Bir puan kazandınız!'
                      : 'Bot soruyu sizden önce çözdü!',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (botWon && _botSolvedMessage.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: widget.difficultyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: widget.difficultyColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _botSolvedMessage,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ] else if (botWon && _botSolveTime > 0) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Bot ${_botSolveTime.toStringAsFixed(1)} saniyede çözdü',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.mutedText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
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
