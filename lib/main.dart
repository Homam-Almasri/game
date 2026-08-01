import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ============================================================================
// 1. APP ENTRY POINT
// ============================================================================
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => GameController(),
      child: const WerewolfApp(),
    ),
  );
}

class WerewolfApp extends StatelessWidget {
  const WerewolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أسرار القرية | لعبة المستذئب والمافيا 🐺',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const PlayerSetupPage(),
    );
  }
}

// ============================================================================
// 2. THEME & COLORS
// ============================================================================
class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color accent = Color(0xFFF43F5E);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        error: AppColors.accent,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
        titleLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
        bodyLarge: GoogleFonts.cairo(fontSize: 16, color: AppColors.textPrimaryDark),
        bodyMedium: GoogleFonts.cairo(fontSize: 14, color: AppColors.textSecondaryDark),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
        error: AppColors.accent,
      ),
      textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
        titleLarge: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryLight),
        bodyLarge: GoogleFonts.cairo(fontSize: 16, color: AppColors.textPrimaryLight),
        bodyMedium: GoogleFonts.cairo(fontSize: 14, color: AppColors.textSecondaryLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

// ============================================================================
// 3. SHARED WIDGETS
// ============================================================================
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isSecondary;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isSecondary = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          gradient: isSecondary ? null : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
          color: isSecondary ? AppColors.darkSurface : null,
          boxShadow: [
            if (!isSecondary)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(20.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDark ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// ============================================================================
// 4. DOMAIN MODELS & ROLES DATA
// ============================================================================
enum Team { villagers, werewolves, neutral }

class RoleModel {
  final String id;
  final String name;
  final String icon;
  final Team team;
  final String description;
  final String nightActionPrompt;
  final int nightPriority;
  final Color color;

  const RoleModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.team,
    required this.description,
    required this.nightActionPrompt,
    required this.nightPriority,
    required this.color,
  });
}

class PlayerModel {
  final String id;
  final String name;
  RoleModel role;
  bool isAlive;
  bool isProtected;
  bool isTargetedByWolves;
  bool isTargetedBySerialKiller;
  bool isTargetedByWitchPoison;
  bool isLinkedByCupid;
  bool isMayor;

  PlayerModel({
    required this.id,
    required this.name,
    required this.role,
    this.isAlive = true,
    this.isProtected = false,
    this.isTargetedByWolves = false,
    this.isTargetedBySerialKiller = false,
    this.isTargetedByWitchPoison = false,
    this.isLinkedByCupid = false,
    this.isMayor = false,
  });

  void resetNightStates() {
    isProtected = false;
    isTargetedByWolves = false;
    isTargetedBySerialKiller = false;
    isTargetedByWitchPoison = false;
  }
}

class RolesData {
  static const RoleModel villager = RoleModel(
    id: 'villager',
    name: 'قروي عادي',
    icon: '🧑‍🌾',
    team: Team.villagers,
    description: 'لا تملك قدرة خاصة ليلاً. قوتك تكمن في النقاش والتصويت في النهار كشف المستذئبين.',
    nightActionPrompt: 'أنت تنام بسلام هذه الليلة.',
    nightPriority: 99,
    color: Color(0xFF10B981),
  );

  static const RoleModel seer = RoleModel(
    id: 'seer',
    name: 'العرّاف / المحقق',
    icon: '🔮',
    team: Team.villagers,
    description: 'تستيقظ كل ليلة وتختار لاعباً لتكشف هويته السرية (هل هو ذئب أم بريء).',
    nightActionPrompt: 'اختر لاعباً لكشف هويته السرية:',
    nightPriority: 2,
    color: Color(0xFF8B5CF6),
  );

  static const RoleModel doctor = RoleModel(
    id: 'doctor',
    name: 'الطبيب / الحارس',
    icon: '🩺',
    team: Team.villagers,
    description: 'تختار لاعباً كل ليلة لحمايته من هجوم المستذئبين والتسبب في نجاته.',
    nightActionPrompt: 'اختر لاعباً لحمايته هذه الليلة:',
    nightPriority: 1,
    color: Color(0xFF06B6D4),
  );

  static const RoleModel witch = RoleModel(
    id: 'witch',
    name: 'الساحرة',
    icon: '🧪',
    team: Team.villagers,
    description: 'تملك جرعة شفاء واحدة لإنقاذ ضحية الليل، وجرعة سم واحدة لقتل أي لاعب.',
    nightActionPrompt: 'اختر إجراء الساحرة لهذه الليلة:',
    nightPriority: 4,
    color: Color(0xFFA855F7),
  );

  static const RoleModel hunter = RoleModel(
    id: 'hunter',
    name: 'الصياد',
    icon: '🏹',
    team: Team.villagers,
    description: 'إذا تم قتلك ليلاً أو إعدامك نهاراً، يمكنك إطلاق رصاصة أخيرة وأخذ لاعب معك للموت.',
    nightActionPrompt: 'أنت تترقب في الظلام بنندقيتك.',
    nightPriority: 98,
    color: Color(0xFFD97706),
  );

  static const RoleModel mayor = RoleModel(
    id: 'mayor',
    name: 'المختار / العمدة',
    icon: '🎖️',
    team: Team.villagers,
    description: 'صوتك في تصويت الإعدام نهاراً يُحسب بصوتين بدلاً من صوت واحد عند التعادل.',
    nightActionPrompt: 'أنت تنام استعداداً لقيادة القرية نهاراً.',
    nightPriority: 97,
    color: Color(0xFF3B82F6),
  );

  static const RoleModel werewolf = RoleModel(
    id: 'werewolf',
    name: 'مستذئب عادي',
    icon: '🐺',
    team: Team.werewolves,
    description: 'تستيقظ مع الذئاب كل ليلة لاختيار والتصويت على ضحية واحدة لقتلها.',
    nightActionPrompt: 'اختر الضحية التي تلتهمها الذئاب الليلة:',
    nightPriority: 3,
    color: Color(0xFFEF4444),
  );

  static const RoleModel alphaWolf = RoleModel(
    id: 'alpha_wolf',
    name: 'الذئب الألفا / الزعيم',
    icon: '👑',
    team: Team.werewolves,
    description: 'قائد الذئاب، صوته حاسم ليلاً ويظهر كقروي بريء عند فحص العراف.',
    nightActionPrompt: 'اقد قطيع الذئاب واختر الضحية:',
    nightPriority: 3,
    color: Color(0xFFB91C1C),
  );

  static const RoleModel wolfSeer = RoleModel(
    id: 'wolf_seer',
    name: 'الذئب الخائن / الجاسوس',
    icon: '👁️',
    team: Team.werewolves,
    description: 'تستيقظ ليلاً لتكشف دور أحد القرويين وتساعد القطيع في قنص الأدوار القوية.',
    nightActionPrompt: 'اختر لاعباً لتكشف دوره للذئاب:',
    nightPriority: 2,
    color: Color(0xFFDC2626),
  );

  static const RoleModel wolfCub = RoleModel(
    id: 'wolf_cub',
    name: 'الذئب الصغير',
    icon: '🐾',
    team: Team.werewolves,
    description: 'إذا تم إعدامك نهاراً، يغضب القطيع وينتقم بأخذ ضحيتين في الليلة التالية.',
    nightActionPrompt: 'أنت تختبئ مع قطيعك.',
    nightPriority: 3,
    color: Color(0xFFF97316),
  );

  static const RoleModel fool = RoleModel(
    id: 'fool',
    name: 'الجوكر / المجنون',
    icon: '🤡',
    team: Team.neutral,
    description: 'هدفك الخفي أن تقنع القرويين بإعدامك نهاراً! إذا أُعدمت تفوز بمفردك فوراً.',
    nightActionPrompt: 'تفكّر في خطتك الخبيثة لإقناعهم بإعدامك.',
    nightPriority: 96,
    color: Color(0xFFEC4899),
  );

  static const RoleModel serialKiller = RoleModel(
    id: 'serial_killer',
    name: 'القاتل المتسلسل',
    icon: '🔪',
    team: Team.neutral,
    description: 'تلعب بمفردك! تستيقظ كل ليلة وتقتل لاعباً. تفوز إذا بقيت آخر شخص حي.',
    nightActionPrompt: 'اختر ضحيتك المستقلة لهذه الليلة:',
    nightPriority: 5,
    color: Color(0xFF6B7280),
  );

  static const RoleModel cupid = RoleModel(
    id: 'cupid',
    name: 'كيوبيد / العاشقان',
    icon: '💘',
    team: Team.neutral,
    description: 'في الليلة الأولى فقط، تختار لاعبين ليرتبطا بالحب. إذا مات أحدهما يموت الآخر حزناً.',
    nightActionPrompt: 'اختر لاعبين لتربطهما بعاطفة الحب الأبدي:',
    nightPriority: 0,
    color: Color(0xFFF43F5E),
  );

  static List<RoleModel> get allRoles => [
        villager,
        seer,
        doctor,
        witch,
        hunter,
        mayor,
        werewolf,
        alphaWolf,
        wolfSeer,
        wolfCub,
        fool,
        serialKiller,
        cupid,
      ];
}

// ============================================================================
// 5. GAME STATE CONTROLLER (COMPREHENSIVE ROLE INTERACTIONS)
// ============================================================================
class GameController extends ChangeNotifier {
  List<PlayerModel> _players = [];
  List<RoleModel> _selectedRoles = [];
  int _currentNightStepIndex = 0;
  List<RoleModel> _activeNightRoles = [];

  List<String> _morningEvents = [];
  String? _winnerTeamMessage;
  bool _isGameOver = false;

  bool witchHasHealPotion = true;
  bool witchHasPoisonPotion = true;
  bool cupidActionDone = false;
  bool wolfCubRevengeActive = false;

  PlayerModel? doctorTarget;
  PlayerModel? wolfTarget;
  PlayerModel? wolfSecondTarget;
  PlayerModel? serialKillerTarget;
  PlayerModel? witchPoisonTarget;
  bool witchUsedHealTonight = false;
  PlayerModel? seerCheckedPlayer;

  List<PlayerModel> get players => _players;
  List<PlayerModel> get alivePlayers => _players.where((p) => p.isAlive).toList();
  List<RoleModel> get selectedRoles => _selectedRoles;
  List<String> get morningEvents => _morningEvents;
  String? get winnerTeamMessage => _winnerTeamMessage;
  bool get isGameOver => _isGameOver;
  int get currentNightStepIndex => _currentNightStepIndex;
  List<RoleModel> get activeNightRoles => _activeNightRoles;

  RoleModel get currentNightRole => _activeNightRoles[_currentNightStepIndex];

  void setupGame(List<String> playerNames, List<RoleModel> chosenRoles) {
    _selectedRoles = List.from(chosenRoles);
    _players.clear();
    _morningEvents.clear();
    _isGameOver = false;
    _winnerTeamMessage = null;
    witchHasHealPotion = true;
    witchHasPoisonPotion = true;
    cupidActionDone = false;
    wolfCubRevengeActive = false;

    List<RoleModel> shuffledRoles = List.from(_selectedRoles)..shuffle(Random());

    for (int i = 0; i < playerNames.length; i++) {
      _players.add(
        PlayerModel(
          id: 'player_$i',
          name: playerNames[i],
          role: shuffledRoles[i],
        ),
      );
    }
    notifyListeners();
  }

  void startNightPhase() {
    _currentNightStepIndex = 0;
    doctorTarget = null;
    wolfTarget = null;
    wolfSecondTarget = null;
    serialKillerTarget = null;
    witchPoisonTarget = null;
    witchUsedHealTonight = false;
    seerCheckedPlayer = null;

    for (var p in _players) {
      p.resetNightStates();
    }

    Set<String> aliveRoleIds = alivePlayers.map((p) => p.role.id).toSet();

    _activeNightRoles = RolesData.allRoles.where((r) {
      if (r.id == RolesData.cupid.id && cupidActionDone) return false;
      return aliveRoleIds.contains(r.id) && r.nightPriority < 90;
    }).toList();

    _activeNightRoles.sort((a, b) => a.nightPriority.compareTo(b.nightPriority));
    notifyListeners();
  }

  bool nextNightStep() {
    if (_currentNightStepIndex < _activeNightRoles.length - 1) {
      _currentNightStepIndex++;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setDoctorTarget(PlayerModel target) {
    doctorTarget = target;
    target.isProtected = true;
  }

  void setWolfTarget(PlayerModel target, {PlayerModel? secondTarget}) {
    wolfTarget = target;
    target.isTargetedByWolves = true;
    if (secondTarget != null) {
      wolfSecondTarget = secondTarget;
      secondTarget.isTargetedByWolves = true;
    }
  }

  void setSerialKillerTarget(PlayerModel target) {
    serialKillerTarget = target;
    target.isTargetedBySerialKiller = true;
  }

  void setWitchPoisonTarget(PlayerModel target) {
    witchPoisonTarget = target;
    target.isTargetedByWitchPoison = true;
    witchHasPoisonPotion = false;
  }

  void useWitchHeal() {
    if (wolfTarget != null) {
      wolfTarget!.isTargetedByWolves = false;
      witchUsedHealTonight = true;
      witchHasHealPotion = false;
    }
  }

  void linkLovers(PlayerModel p1, PlayerModel p2) {
    p1.isLinkedByCupid = true;
    p2.isLinkedByCupid = true;
    cupidActionDone = true;
  }

  void resolveNightPhase() {
    _morningEvents.clear();
    List<PlayerModel> killedTonight = [];

    // 1. Doctor vs Werewolf attack
    if (wolfTarget != null && wolfTarget!.isTargetedByWolves) {
      if (wolfTarget!.isProtected) {
        _morningEvents.add('🛡️ نجح الطبيب/الحارس في حماية أحد القرويين من هجوم المستذئبين!');
      } else {
        killedTonight.add(wolfTarget!);
      }
    }

    if (wolfSecondTarget != null && wolfSecondTarget!.isTargetedByWolves) {
      if (!wolfSecondTarget!.isProtected && !killedTonight.contains(wolfSecondTarget)) {
        killedTonight.add(wolfSecondTarget!);
      }
    }

    // 2. Doctor vs Serial Killer attack
    if (serialKillerTarget != null && serialKillerTarget!.isTargetedBySerialKiller) {
      if (serialKillerTarget!.isProtected) {
        _morningEvents.add('🛡️ نجح الحارس في التصدي لهجوم القاتل المتسلسل!');
      } else {
        if (!killedTonight.contains(serialKillerTarget)) {
          killedTonight.add(serialKillerTarget!);
        }
      }
    }

    // 3. Witch Poison Attack
    if (witchPoisonTarget != null && witchPoisonTarget!.isTargetedByWitchPoison) {
      if (!killedTonight.contains(witchPoisonTarget)) {
        killedTonight.add(witchPoisonTarget!);
      }
    }

    // Apply casualties and lovers heartbreak
    for (var victim in killedTonight) {
      victim.isAlive = false;
      _morningEvents.add('❌ للأسف، قُتل اللاعب [${victim.name}] (${victim.role.name}) خلال الليل!');

      if (victim.isLinkedByCupid) {
        var partner = _players.firstWhere(
          (p) => p.isLinkedByCupid && p.id != victim.id && p.isAlive,
          orElse: () => victim,
        );
        if (partner.id != victim.id && partner.isAlive) {
          partner.isAlive = false;
          _morningEvents.add('💔 قُتل اللاعب [${partner.name}] فوراً حزناً على مقتل شريكه الحبيب!');
        }
      }
    }

    if (killedTonight.isEmpty && _morningEvents.isEmpty) {
      _morningEvents.add('✨ صباح آمن ومشرق! لم يمت أي لاعب خلال هذه الليلة.');
    }

    wolfCubRevengeActive = false; // Reset wolf cub revenge after night
    checkWinConditions();
    notifyListeners();
  }

  void executePlayer(PlayerModel suspect) {
    suspect.isAlive = false;
    _morningEvents.clear();
    _morningEvents.add('⚖️ قرر القرويون إعدام [${suspect.name}] وكانت هويته الحقيقية: (${suspect.role.name} ${suspect.role.icon}).');

    // Rule: If Fool is executed -> Fool wins instantly
    if (suspect.role.id == RolesData.fool.id) {
      _isGameOver = true;
      _winnerTeamMessage = '🤡 فاز الجوكر (المجنون) باللعبة! نجح بإقناع القرويين بإعدامه!';
      notifyListeners();
      return;
    }

    // Rule: If Wolf Cub is executed -> Werewolves get revenge double kill next night
    if (suspect.role.id == RolesData.wolfCub.id) {
      wolfCubRevengeActive = true;
      _morningEvents.add('🐾 غضب قطيع المستذئبين لمقتل الذئب الصغير! سينتقمون بأخذ ضحيتين الليلة القادمة.');
    }

    // Rule: Lovers Heartbreak
    if (suspect.isLinkedByCupid) {
      var partner = _players.firstWhere(
        (p) => p.isLinkedByCupid && p.id != suspect.id && p.isAlive,
        orElse: () => suspect,
      );
      if (partner.id != suspect.id && partner.isAlive) {
        partner.isAlive = false;
        _morningEvents.add('💔 مات اللاعب [${partner.name}] فوراً حزناً على إعدام شريكه!');
      }
    }

    checkWinConditions();
    notifyListeners();
  }

  void checkWinConditions() {
    int aliveWolves = alivePlayers.where((p) => p.role.team == Team.werewolves).length;
    int aliveVillagers = alivePlayers.where((p) => p.role.team == Team.villagers).length;
    int aliveNeutrals = alivePlayers.where((p) => p.role.team == Team.neutral).length;

    var aliveSerialKillers = alivePlayers.where((p) => p.role.id == RolesData.serialKiller.id);
    if (aliveSerialKillers.length == 1 && alivePlayers.length <= 2) {
      _isGameOver = true;
      _winnerTeamMessage = '🔪 فاز القاتل المتسلسل باللعبة بوقوفه كآخر ناجٍ في القرية!';
      return;
    }

    if (alivePlayers.length == 2 && alivePlayers.every((p) => p.isLinkedByCupid)) {
      _isGameOver = true;
      _winnerTeamMessage = '💘 فاز العاشقان باللعبة ونجحا في البقاء معاً حتى النهاية!';
      return;
    }

    if (aliveWolves > 0 && aliveWolves >= (aliveVillagers + aliveNeutrals)) {
      _isGameOver = true;
      _winnerTeamMessage = '🐺 فاز فريق المستذئبين باللعبة! سيطروا على القرية بالكامل.';
      return;
    }

    if (aliveWolves == 0) {
      _isGameOver = true;
      _winnerTeamMessage = '🛡️ فاز فريق القرويين باللعبة! تم القضاء على جميع المستذئبين.';
      return;
    }
  }
}

// ============================================================================
// 6. PLAYER SETUP PAGE
// ============================================================================
class PlayerSetupPage extends StatefulWidget {
  const PlayerSetupPage({super.key});

  @override
  State<PlayerSetupPage> createState() => _PlayerSetupPageState();
}

class _PlayerSetupPageState extends State<PlayerSetupPage> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _playerNames = ['أحمد', 'سارة', 'محمد', 'فاطمة', 'علي', 'ريم'];

  final List<RoleModel> _selectedRoles = [
    RolesData.villager,
    RolesData.villager,
    RolesData.villager,
    RolesData.seer,
    RolesData.doctor,
    RolesData.werewolf,
  ];

  void _addPlayer() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        _playerNames.add(name);
        _selectedRoles.add(RolesData.villager);
        _nameController.clear();
      });
    }
  }

  void _removePlayer(int index) {
    if (_playerNames.length > 4) {
      setState(() {
        _playerNames.removeAt(index);
        _selectedRoles.removeLast();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدنى عدد للاعبين هو 4 لاعبين!'), behavior: SnackBarBehavior.floating),
      );
    }
  }

  void _addRoleCount(RoleModel role) {
    setState(() {
      if (_selectedRoles.length < _playerNames.length) {
        _selectedRoles.add(role);
      } else {
        int idx = _selectedRoles.indexWhere((r) => r.id == RolesData.villager.id && role.id != RolesData.villager.id);
        if (idx != -1) {
          _selectedRoles[idx] = role;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('عدد الأدوار (${_selectedRoles.length}) يطابق عدد اللاعبين! أضف لاعباً جديداً لزيادة الأدوار.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    });
  }

  void _removeRoleCount(RoleModel role) {
    setState(() {
      int count = _selectedRoles.where((r) => r.id == role.id).length;
      if (count > 0) {
        int idx = _selectedRoles.indexWhere((r) => r.id == role.id);
        if (idx != -1) {
          _selectedRoles.removeAt(idx);
        }
      }
    });
  }

  void _startGame() {
    if (_playerNames.length != _selectedRoles.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('عدد الأدوار (${_selectedRoles.length}) يجب أن يطابق عدد اللاعبين (${_playerNames.length})!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    int wolvesCount = _selectedRoles.where((r) => r.team == Team.werewolves).length;
    if (wolvesCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب إدراج دور مستذئب واحد على الأقل في اللعبة!'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    context.read<GameController>().setupGame(_playerNames, _selectedRoles);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RoleRevealPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('تجهيز اللعبة واللاعبين 🐺')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('إضافة لاعبين 👤', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'اسم اللاعب...',
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.08),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              ),
                              onSubmitted: (_) => _addPlayer(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addPlayer,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.all(14)),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('قائمة اللاعبين (${_playerNames.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('الأدوار: ${_selectedRoles.length}', style: const TextStyle(fontSize: 14, color: AppColors.secondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: List.generate(_playerNames.length, (index) {
                    return Chip(
                      avatar: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                        child: Text('${index + 1}', style: const TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                      label: Text(_playerNames[index]),
                      backgroundColor: AppColors.darkSurface,
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removePlayer(index),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                const Text('اختر وتكرار الأدوار المشاركة في الجولة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: RolesData.allRoles.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                    childAspectRatio: 1.15,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final role = RolesData.allRoles[index];
                    final count = _selectedRoles.where((r) => r.id == role.id).length;
                    final isSelected = count > 0;

                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? role.color.withValues(alpha: 0.2) : AppColors.darkSurface.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? role.color : Colors.white10, width: isSelected ? 2 : 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(role.icon, style: const TextStyle(fontSize: 24)),
                              Text(
                                role.team == Team.werewolves ? 'شر 🐺' : role.team == Team.villagers ? 'خير 🛡️' : 'محايد 🎭',
                                style: TextStyle(fontSize: 11, color: role.color, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(role.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => _removeRoleCount(role),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.remove, size: 16, color: Colors.white),
                                ),
                              ),
                              Text(
                                '$count',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: count > 0 ? role.color : Colors.white70),
                              ),
                              InkWell(
                                onTap: () => _addRoleCount(role),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: role.color.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'بدء اللعبة وتوزيع الأدوار 🚀',
                  icon: Icons.play_arrow_rounded,
                  onPressed: _startGame,
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// 7. ROLE REVEAL PAGE
// ============================================================================
class RoleRevealPage extends StatefulWidget {
  const RoleRevealPage({super.key});

  @override
  State<RoleRevealPage> createState() => _RoleRevealPageState();
}

class _RoleRevealPageState extends State<RoleRevealPage> {
  int _currentPlayerIndex = 0;
  bool _isRoleRevealed = false;

  void _nextPlayer(int totalPlayers) {
    if (_currentPlayerIndex < totalPlayers - 1) {
      setState(() {
        _currentPlayerIndex++;
        _isRoleRevealed = false;
      });
    } else {
      context.read<GameController>().startNightPhase();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NightPhasePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final players = controller.players;
    final currentPlayer = players[_currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('كشف الأوراق السرية (${_currentPlayerIndex + 1}/${players.length})'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              const Text('مرّر الهاتف إلى:', style: TextStyle(fontSize: 16, color: AppColors.textSecondaryDark)),
              const SizedBox(height: 4),
              Text(currentPlayer.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber)),
              const SizedBox(height: 16),
              Expanded(
                child: GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isRoleRevealed
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                key: const ValueKey('revealed'),
                                children: [
                                  Text(currentPlayer.role.icon, style: const TextStyle(fontSize: 70)),
                                  const SizedBox(height: 12),
                                  Text(
                                    currentPlayer.role.name,
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: currentPlayer.role.color),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: currentPlayer.role.color.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'الفريق: ${currentPlayer.role.team.name}',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: currentPlayer.role.color),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(currentPlayer.role.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, height: 1.4)),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                key: const ValueKey('hidden'),
                                children: const [
                                  Icon(Icons.lock_outline_rounded, size: 70, color: AppColors.primary),
                                  SizedBox(height: 16),
                                  Text('تأكد أن اللاعبين الآخرين لا ينظرون لشاشتك!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.4)),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!_isRoleRevealed)
                CustomButton(text: 'اضغط لرؤية دورك السرّي 👁️', onPressed: () => setState(() => _isRoleRevealed = true))
              else
                CustomButton(
                  text: _currentPlayerIndex < players.length - 1 ? 'إخفاء وتمرير الهاتف للاعب التالي 📲' : 'إخفاء وبدء مرحلة الليل الأولى 🌙',
                  isSecondary: true,
                  onPressed: () => _nextPlayer(players.length),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 8. NIGHT PHASE PAGE (SMART ROLE INTERACTION UI)
// ============================================================================
class NightPhasePage extends StatefulWidget {
  const NightPhasePage({super.key});

  @override
  State<NightPhasePage> createState() => _NightPhasePageState();
}

class _NightPhasePageState extends State<NightPhasePage> {
  PlayerModel? _selectedTarget;
  PlayerModel? _secondSelectedTarget;

  void _onConfirmAction(GameController controller) {
    final role = controller.currentNightRole;

    if (role.id == RolesData.doctor.id && _selectedTarget != null) {
      controller.setDoctorTarget(_selectedTarget!);
    } else if ((role.id == RolesData.werewolf.id || role.id == RolesData.alphaWolf.id) && _selectedTarget != null) {
      controller.setWolfTarget(_selectedTarget!, secondTarget: _secondSelectedTarget);
    } else if (role.id == RolesData.serialKiller.id && _selectedTarget != null) {
      controller.setSerialKillerTarget(_selectedTarget!);
    } else if (role.id == RolesData.seer.id && _selectedTarget != null) {
      _showSeerDialog(context, _selectedTarget!);
      return;
    } else if (role.id == RolesData.wolfSeer.id && _selectedTarget != null) {
      _showWolfSeerDialog(context, _selectedTarget!);
      return;
    } else if (role.id == RolesData.cupid.id && _selectedTarget != null && _secondSelectedTarget != null) {
      controller.linkLovers(_selectedTarget!, _secondSelectedTarget!);
    }

    _advanceTurn(controller);
  }

  void _advanceTurn(GameController controller) {
    setState(() {
      _selectedTarget = null;
      _secondSelectedTarget = null;
    });

    bool hasNext = controller.nextNightStep();
    if (!hasNext) {
      controller.resolveNightPhase();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DayPhasePage()),
      );
    }
  }

  void _showSeerDialog(BuildContext context, PlayerModel target) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // Alpha wolf shows as Villager to Seer!
        final isWolf = target.role.team == Team.werewolves && target.role.id != RolesData.alphaWolf.id;
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('نتيجة كشف العرّاف 🔮', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('اللاعب [${target.name}] ينتمي إلى:'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isWolf ? Colors.red.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isWolf ? 'فريق المستذئبين/الشر 🐺' : 'فريق القرويين/الخير 🛡️',
                  style: TextStyle(fontWeight: FontWeight.bold, color: isWolf ? Colors.red : Colors.green),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _advanceTurn(context.read<GameController>());
              },
              child: const Text('فهمت وإغلاق'),
            ),
          ],
        );
      },
    );
  }

  void _showWolfSeerDialog(BuildContext context, PlayerModel target) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('كشف الذئب الجاسوس 👁️', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('الدور الحقيقي للاعب [${target.name}] هو:'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: target.role.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${target.role.icon} ${target.role.name}',
                  style: TextStyle(fontWeight: FontWeight.bold, color: target.role.color, fontSize: 18),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _advanceTurn(context.read<GameController>());
              },
              child: const Text('فهمت وإغلاق'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final role = controller.currentNightRole;
    final alivePlayers = controller.alivePlayers;

    return Scaffold(
      appBar: AppBar(
        title: Text('حلول الليل 🌙 (${controller.currentNightStepIndex + 1}/${controller.activeNightRoles.length})'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              GlassCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Text(role.icon, style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('دور: ${role.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: role.color)),
                          const SizedBox(height: 2),
                          Text(role.nightActionPrompt, style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (role.id == RolesData.witch.id) ...[
                GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      if (controller.wolfTarget != null)
                        Text('ضحية المستذئبين الليلة هي: [${controller.wolfTarget!.name}]', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: controller.witchHasHealPotion && controller.wolfTarget != null
                                ? () {
                                    controller.useWitchHeal();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم استخدام جرعة الشفاء لإنقاذ الضحية!')));
                                    setState(() {});
                                  }
                                : null,
                            icon: const Icon(Icons.favorite, size: 18),
                            label: const Text('جرعة الشفاء 🧪'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Expanded(
                child: ListView.builder(
                  itemCount: alivePlayers.length,
                  itemBuilder: (context, index) {
                    final player = alivePlayers[index];
                    final isSelected = _selectedTarget?.id == player.id;
                    final isSecondSelected = _secondSelectedTarget?.id == player.id;

                    return Card(
                      color: isSelected || isSecondSelected ? role.color.withValues(alpha: 0.25) : AppColors.darkSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: isSelected || isSecondSelected ? role.color : Colors.white10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: role.color.withValues(alpha: 0.2),
                          child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: isSelected || isSecondSelected ? Icon(Icons.check_circle_rounded, color: role.color) : null,
                        onTap: () {
                          setState(() {
                            if (role.id == RolesData.cupid.id || (role.team == Team.werewolves && controller.wolfCubRevengeActive)) {
                              if (_selectedTarget == null) {
                                _selectedTarget = player;
                              } else if (_secondSelectedTarget == null && player.id != _selectedTarget!.id) {
                                _secondSelectedTarget = player;
                              } else {
                                _selectedTarget = player;
                                _secondSelectedTarget = null;
                              }
                            } else {
                              _selectedTarget = player;
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: _selectedTarget != null ? 'تأكيد القرار والتحويل 📲' : 'تخطي / لا يوجد حركة',
                onPressed: () => _onConfirmAction(controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 9. DAY PHASE PAGE
// ============================================================================
class DayPhasePage extends StatefulWidget {
  const DayPhasePage({super.key});

  @override
  State<DayPhasePage> createState() => _DayPhasePageState();
}

class _DayPhasePageState extends State<DayPhasePage> {
  PlayerModel? _selectedSuspect;
  Timer? _timer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    _startDiscussionTimer();
  }

  void _startDiscussionTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _executeLynch(GameController controller) {
    if (_selectedSuspect == null) return;

    final suspect = _selectedSuspect!;
    controller.executePlayer(suspect);

    if (controller.isGameOver) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const GameOverPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إعدام [${suspect.name}] وكانت هويته (${suspect.role.name})!'), behavior: SnackBarBehavior.floating),
      );

      controller.startNightPhase();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NightPhasePage()),
      );
    }
  }

  void _skipLynch(GameController controller) {
    controller.startNightPhase();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NightPhasePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final alivePlayers = controller.alivePlayers;
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');

    if (controller.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GameOverPage()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('حلول النهار والنقاش ☀️'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.timer_outlined, color: Colors.amber),
                        SizedBox(width: 8),
                        Text('وقت النقاش:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text('$minutes:$seconds', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('أحداث الليلة الماضية 📜', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ...controller.morningEvents.map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(e, style: const TextStyle(fontSize: 13, height: 1.3)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('اختر اللاعب الذي صوّتت القرية لإعدامه:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: alivePlayers.length,
                  itemBuilder: (context, index) {
                    final player = alivePlayers[index];
                    final isSelected = _selectedSuspect?.id == player.id;

                    return Card(
                      color: isSelected ? Colors.red.withValues(alpha: 0.25) : AppColors.darkSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: isSelected ? Colors.red : Colors.white10),
                      ),
                      child: ListTile(
                        leading: Text(player.role.icon, style: const TextStyle(fontSize: 24)),
                        title: Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: isSelected ? const Icon(Icons.gavel_rounded, color: Colors.red) : null,
                        onTap: () => setState(() => _selectedSuspect = player),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'إعدام المشتبه به ⚖️',
                      onPressed: _selectedSuspect != null ? () => _executeLynch(controller) : () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _skipLynch(controller),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkSurface,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('تخطي الإعدام 🕊️', style: TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 10. GAME OVER PAGE
// ============================================================================
class GameOverPage extends StatelessWidget {
  const GameOverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    final allPlayers = controller.players;
    final victoryMsg = controller.winnerTeamMessage ?? 'انتهت اللعبة!';

    return Scaffold(
      appBar: AppBar(
        title: const Text('نهاية اللعبة 🏆'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 50)),
                    const SizedBox(height: 8),
                    Text(
                      victoryMsg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('كشف هويات وصفوف جميع اللاعبين:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: allPlayers.length,
                  itemBuilder: (context, index) {
                    final player = allPlayers[index];
                    return Card(
                      color: player.isAlive ? AppColors.darkSurface : Colors.red.withValues(alpha: 0.15),
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: Text(player.role.icon, style: const TextStyle(fontSize: 26)),
                        title: Text(
                          player.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: player.isAlive ? null : TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Text('الدور: ${player.role.name}', style: TextStyle(color: player.role.color, fontSize: 13)),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: player.isAlive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            player.isAlive ? 'حي 💚' : 'ميت 💀',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: player.isAlive ? Colors.green : Colors.red),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'جولة جديدة 🔄',
                icon: Icons.refresh_rounded,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const PlayerSetupPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
