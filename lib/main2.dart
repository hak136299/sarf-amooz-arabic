import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const SarfAmoozApp());

class SarfAmoozApp extends StatelessWidget {
  const SarfAmoozApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'صرف‌آموز عربی',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF087F73), fontFamily: 'Arial'),
      home: const HomePage(),
    );
  }
}

class AppStats {
  static int exams = 0;
  static int correct = 0;
  static int answered = 0;
  static final List<String> mistakes = [];
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem('آموزش فعل ماضی', '۱۴ صیغه، ضمایر و روش ساخت', Icons.history, () => _go(context, const LessonPage(kind: LessonKind.mazi))),
      _MenuItem('آموزش فعل مضارع', 'حروف مضارعه و ۱۴ صیغه', Icons.autorenew, () => _go(context, const LessonPage(kind: LessonKind.mozare))),
      _MenuItem('فعل امر و نهی', '۶ صیغه امر و ۶ صیغه نهی', Icons.record_voice_over, () => _go(context, const LessonPage(kind: LessonKind.amr))),
      _MenuItem('تمرین', 'تمرین ضمیر، زمان و تبدیل فعل', Icons.edit_note, () => _go(context, const PracticePage())),
      _MenuItem('آزمون', 'سؤال تصادفی و زمان‌دار', Icons.timer_outlined, () => _go(context, const ExamPage())),
      _MenuItem('کارنامه', 'نمرات و اشتباهات قبلی', Icons.assessment, () => _go(context, const ReportPage())),
      _MenuItem('صرف فعل دلخواه', 'ورود ریشه سه‌حرفی بدون حرکت', Icons.spellcheck, () => _go(context, const CustomVerbPage())),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F8F7),
        appBar: AppBar(title: const Text('صرف‌آموز عربی'), centerTitle: true, backgroundColor: const Color(0xFF087F73), foregroundColor: Colors.white,
          actions: [IconButton(tooltip: 'درباره برنامه', onPressed: () => _go(context, const AboutPage()), icon: const Icon(Icons.info_outline))]),
        body: Column(children: [
          Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
            Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF087F73), Color(0xFF16A394)]), borderRadius: BorderRadius.circular(20)),
              child: const Column(children: [Icon(Icons.menu_book_rounded, color: Colors.white, size: 46), SizedBox(height: 8), Text('آموزش صرف افعال عربی', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)), SizedBox(height: 6), Text('ویژه پایه‌های هفتم، هشتم و نهم', style: TextStyle(color: Colors.white, fontSize: 15))])),
            const SizedBox(height: 16),
            ...items.map((item) => Card(elevation: 1, margin: const EdgeInsets.only(bottom: 9), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5), leading: CircleAvatar(backgroundColor: const Color(0xFFE1F2EF), child: Icon(item.icon, color: const Color(0xFF087F73))), title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), subtitle: Text(item.subtitle), trailing: const Icon(Icons.chevron_left), onTap: item.onTap))),
          ])),
          Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 10), color: const Color(0xFFE1F2EF), child: const Column(children: [Text('HAKnet', style: TextStyle(color: Color(0xFF087F73), fontSize: 19, fontWeight: FontWeight.bold)), SizedBox(height: 2), Text('نسخه 1.0.0', style: TextStyle(color: Colors.black54, fontSize: 12))]))
        ]),
      ),
    );
  }
  void _go(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

class _MenuItem {
  final String title, subtitle; final IconData icon; final VoidCallback onTap;
  _MenuItem(this.title, this.subtitle, this.icon, this.onTap);
}

enum LessonKind { mazi, mozare, amr }

class LessonPage extends StatelessWidget {
  final LessonKind kind;
  const LessonPage({super.key, required this.kind});
  String get title => kind == LessonKind.mazi ? 'آموزش فعل ماضی' : kind == LessonKind.mozare ? 'آموزش فعل مضارع' : 'آموزش فعل امر و نهی';
  @override
  Widget build(BuildContext context) {
    final mazi = kind == LessonKind.mazi;
    final mozare = kind == LessonKind.mozare;
    final rows = mazi ? VerbExamples.mazi : mozare ? VerbExamples.mozare : VerbExamples.amr;
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(14), children: [
      _InfoCard(title: mazi ? 'فعل ماضی' : mozare ? 'فعل مضارع' : 'امر و نهی', text: mazi ? 'فعل ماضی بر انجام کار در گذشته دلالت می‌کند. برای نمونه: كَتَبَ یعنی نوشت.' : mozare ? 'فعل مضارع بر انجام کار در زمان حال یا آینده دلالت می‌کند. برای نمونه: يَكْتُبُ یعنی می‌نویسد.' : 'امر برای درخواست انجام کار و نهی برای درخواست ترک کار به‌کار می‌رود. هرکدام در این آموزش ۶ صیغه مخاطب دارند.'),
      if (mozare) const _InfoCard(title: 'حروف مضارعه', text: 'حروف مضارعه عبارت‌اند از: أ، ن، ي، ت. این حروف در ابتدای فعل مضارع می‌آیند و با توجه به صیغه، پسوند نیز تغییر می‌کند.'),
      if (mazi) const _InfoCard(title: 'روش ساخت', text: 'در فعل ماضی، شناسه‌ها به پایان بن فعل افزوده می‌شوند. شناسه هر ضمیر را در جدول مشاهده کنید.'),
      if (kind == LessonKind.amr) const _InfoCard(title: 'روش ساخت', text: 'امر و نهی فقط برای شش صیغه مخاطب ساخته می‌شوند. نهی با «لا»ی نهی و فعل مضارع مجزوم ساخته می‌شود.'),
      const SizedBox(height: 8), Text(mazi ? 'جدول ۱۴ صیغه ماضی «كَتَبَ»' : mozare ? 'جدول ۱۴ صیغه مضارع «يَكْتُبُ»' : 'جدول امر و نهی فعل «كَتَبَ»', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), _VerbTable(rows: rows),
      const SizedBox(height: 12), const Text('نمونه آموزشی با فعل «كتب». برای فعل‌های دیگر، شکل درست فعل و قواعد آن باید بررسی شود.', style: TextStyle(color: Colors.black54, fontSize: 12)),
    ])));
  }
}

class VerbExamples {
  static const List<List<String>> mazi = [
    ['ضمیر', 'فعل', 'معنی'], ['هُوَ', 'كَتَبَ', 'او مرد نوشت'], ['هُما', 'كَتَبا', 'آن دو مرد نوشتند'], ['هُمْ', 'كَتَبُوا', 'آن مردان نوشتند'], ['هِيَ', 'كَتَبَتْ', 'او زن نوشت'], ['هُما', 'كَتَبَتا', 'آن دو زن نوشتند'], ['هُنَّ', 'كَتَبْنَ', 'آن زنان نوشتند'], ['أَنْتَ', 'كَتَبْتَ', 'تو مرد نوشتی'], ['أَنْتُما', 'كَتَبْتُما', 'شما دو نفر نوشتید'], ['أَنْتُمْ', 'كَتَبْتُمْ', 'شما مردان نوشتید'], ['أَنْتِ', 'كَتَبْتِ', 'تو زن نوشتی'], ['أَنْتُما', 'كَتَبْتُما', 'شما دو نفر نوشتید'], ['أَنْتُنَّ', 'كَتَبْتُنَّ', 'شما زنان نوشتید'], ['أَنا', 'كَتَبْتُ', 'من نوشتم'], ['نَحْنُ', 'كَتَبْنا', 'ما نوشتیم'],
  ];
  static const List<List<String>> mozare = [
    ['ضمیر', 'فعل', 'معنی'], ['هُوَ', 'يَكْتُبُ', 'او مرد می‌نویسد'], ['هُما', 'يَكْتُبانِ', 'آن دو مرد می‌نویسند'], ['هُمْ', 'يَكْتُبُونَ', 'آن مردان می‌نویسند'], ['هِيَ', 'تَكْتُبُ', 'او زن می‌نویسد'], ['هُما', 'تَكْتُبانِ', 'آن دو زن می‌نویسند'], ['هُنَّ', 'يَكْتُبْنَ', 'آن زنان می‌نویسند'], ['أَنْتَ', 'تَكْتُبُ', 'تو مرد می‌نویسی'], ['أَنْتُما', 'تَكْتُبانِ', 'شما دو نفر می‌نویسید'], ['أَنْتُمْ', 'تَكْتُبُونَ', 'شما مردان می‌نویسید'], ['أَنْتِ', 'تَكْتُبِينَ', 'تو زن می‌نویسی'], ['أَنْتُما', 'تَكْتُبانِ', 'شما دو نفر می‌نویسید'], ['أَنْتُنَّ', 'تَكْتُبْنَ', 'شما زنان می‌نویسید'], ['أَنا', 'أَكْتُبُ', 'من می‌نویسم'], ['نَحْنُ', 'نَكْتُبُ', 'ما می‌نویسیم'],
  ];
  static const List<List<String>> amr = [
    ['ضمیر مخاطب', 'امر', 'نهی'], ['أَنْتَ', 'اُكْتُبْ', 'لا تَكْتُبْ'], ['أَنْتُما (مذکر)', 'اُكْتُبا', 'لا تَكْتُبا'], ['أَنْتُمْ', 'اُكْتُبُوا', 'لا تَكْتُبُوا'], ['أَنْتِ', 'اُكْتُبِي', 'لا تَكْتُبِي'], ['أَنْتُما (مؤنث)', 'اُكْتُبا', 'لا تَكْتُبَا'], ['أَنْتُنَّ', 'اُكْتُبْنَ', 'لا تَكْتُبْنَ'],
  ];
}

class _VerbTable extends StatelessWidget {
  final List<List<String>> rows;
  const _VerbTable({required this.rows});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(headingRowColor: WidgetStateProperty.all(const Color(0xFFE1F2EF)), columns: rows.first.map((e) => DataColumn(label: Text(e, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(), rows: rows.skip(1).map((r) => DataRow(cells: r.map((e) => DataCell(Text(e))).toList())).toList()));
}

class _InfoCard extends StatelessWidget {
  final String title, text;
  const _InfoCard({required this.title, required this.text});
  @override
  Widget build(BuildContext context) => Card(color: Colors.white, child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF087F73))), const SizedBox(height: 7), Text(text, style: const TextStyle(height: 1.7))])));
}

class CustomVerbPage extends StatefulWidget {
  const CustomVerbPage({super.key});
  @override
  State<CustomVerbPage> createState() => _CustomVerbPageState();
}

class _CustomVerbPageState extends State<CustomVerbPage> {
  final controller = TextEditingController();
  String? selectedPattern;
  String message = '';
  Map<String, String>? result;
  // این فرهنگ کوچک نمونه است؛ برای صرف دقیق، فعل باید در فرهنگ معتبر ثبت شده باشد.
  static const dictionary = <String, Map<String, String>>{
    'كتب': {'past': 'كَتَبَ', 'present': 'يَكْتُبُ', 'meaning': 'نوشتن'},
    'نصر': {'past': 'نَصَرَ', 'present': 'يَنْصُرُ', 'meaning': 'یاری کردن'},
    'فتح': {'past': 'فَتَحَ', 'present': 'يَفْتَحُ', 'meaning': 'باز کردن'},
    'علم': {'past': 'عَلِمَ', 'present': 'يَعْلَمُ', 'meaning': 'دانستن'},
    'جلس': {'past': 'جَلَسَ', 'present': 'يَجْلِسُ', 'meaning': 'نشستن'},
    'ذهب': {'past': 'ذَهَبَ', 'present': 'يَذْهَبُ', 'meaning': 'رفتن'},
  };
  void search() {
    final root = controller.text.trim().replaceAll(' ', '').replaceAll('ك', 'ک').replaceAll('ي', 'ی');
    final normalized = root.replaceAll('ک', 'ك').replaceAll('ی', 'ي');
    setState(() {
      result = dictionary[normalized];
      message = result == null ? 'این فعل در فرهنگ فعلی برنامه موجود نیست. برای جلوگیری از صرف اشتباه، فعلاً نتیجه حدسی نمایش داده نمی‌شود.' : '';
    });
  }
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('صرف فعل دلخواه')), body: ListView(padding: const EdgeInsets.all(16), children: [
    const _InfoCard(title: 'ورود ریشه فعل', text: 'ریشه سه‌حرفی را بدون حرکت وارد کنید؛ مانند كتب، نصر یا فتح. برنامه در فرهنگ داخلی خود به دنبال فعل می‌گردد.'),
    const SizedBox(height: 12), TextField(controller: controller, textAlign: TextAlign.center, style: const TextStyle(fontSize: 26), decoration: const InputDecoration(labelText: 'ریشه سه‌حرفی', hintText: 'كتب', border: OutlineInputBorder())),
    const SizedBox(height: 12), FilledButton.icon(onPressed: search, icon: const Icon(Icons.search), label: const Text('جست‌وجو و صرف فعل')),
    if (result != null) ...[
      const SizedBox(height: 18), Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Text('ماضی: ${result!['past']}', style: const TextStyle(fontSize: 24)), const SizedBox(height: 8), Text('مضارع: ${result!['present']}', style: const TextStyle(fontSize: 24)), const SizedBox(height: 8), Text('معنی: ${result!['meaning']}')]))),
      const SizedBox(height: 8), const Text('در گام بعدی، جدول کامل ۱۴ صیغه و امر و نهی برای فعل‌های ثبت‌شده به این بخش متصل می‌شود.', style: TextStyle(color: Colors.black54)),
    ],
    if (message.isNotEmpty) ...[const SizedBox(height: 14), Text(message, style: const TextStyle(color: Colors.red))]
  ])));
}

class PracticePage extends StatefulWidget { const PracticePage({super.key}); @override State<PracticePage> createState() => _PracticePageState(); }
class _PracticePageState extends State<PracticePage> {
  int index = 0, score = 0; String? selected;
  final questions = const [
    _Question('كَتَبَ مربوط به کدام زمان است؟', ['ماضی', 'مضارع', 'امر'], 'ماضی'),
    _Question('معنی «يَكْتُبُ» چیست؟', ['نوشت', 'می‌نویسد', 'بنویس'], 'می‌نویسد'),
    _Question('«اُكْتُبْ» چه نوع فعلی است؟', ['ماضی', 'نهی', 'امر'], 'امر'),
    _Question('«لا تَكْتُبْ» چه معنایی دارد؟', ['بنویس', 'نمی‌نویسد', 'ننویس'], 'ننویس'),
  ];
  @override
  Widget build(BuildContext context) { final q = questions[index]; return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('تمرین')), body: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('سؤال ${index + 1} از ${questions.length}  |  امتیاز: $score'), const SizedBox(height: 20), Text(q.text, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)), const SizedBox(height: 16), ...q.options.map((o) => Padding(padding: const EdgeInsets.only(bottom: 8), child: OutlinedButton(onPressed: selected == null ? () => setState(() { selected = o; if (o == q.answer) score++; else AppStats.mistakes.add(q.text); AppStats.answered++; }) : null, child: Text(o)))), if (selected != null) Text(selected == q.answer ? 'آفرین! پاسخ درست است.' : 'پاسخ درست: ${q.answer}', style: TextStyle(color: selected == q.answer ? Colors.green : Colors.red, fontWeight: FontWeight.bold)), const Spacer(), FilledButton(onPressed: selected == null ? null : () { if (index == questions.length - 1) { AppStats.correct += score; Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultPage(score: score, total: questions.length))); } else { setState(() { index++; selected = null; }); } }, child: Text(index == questions.length - 1 ? 'پایان تمرین' : 'سؤال بعدی'))]))); }
}

class _Question { final String text; final List<String> options; final String answer; const _Question(this.text, this.options, this.answer); }

class ExamPage extends StatefulWidget { const ExamPage({super.key}); @override State<ExamPage> createState() => _ExamPageState(); }
class _ExamPageState extends State<ExamPage> {
  int seconds = 60, index = 0, score = 0; String? selected; Timer? timer;
  final questions = const [_Question('«ذَهَبَ» چه زمانی است؟', ['ماضی', 'مضارع', 'امر'], 'ماضی'), _Question('«تَكْتُبِينَ» برای کدام ضمیر است؟', ['أَنْتَ', 'أَنْتِ', 'هِيَ'], 'أَنْتِ'), _Question('امر فعل كتب برای «أَنْتَ» چیست؟', ['كَتَبَ', 'اُكْتُبْ', 'يَكْتُبُ'], 'اُكْتُبْ'), _Question('«نَكْتُبُ» برای کدام ضمیر است؟', ['أَنا', 'نَحْنُ', 'هُمْ'], 'نَحْنُ')];
  @override void initState() { super.initState(); timer = Timer.periodic(const Duration(seconds: 1), (t) { if (!mounted) return; if (seconds <= 1) { t.cancel(); finish(); } else { setState(() => seconds--); } }); }
  void finish() { timer?.cancel(); AppStats.exams++; AppStats.correct += score; AppStats.answered += index + (selected == null ? 0 : 1); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultPage(score: score, total: questions.length))); }
  @override void dispose() { timer?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context) { final q = questions[index]; return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('آزمون زمان‌دار'), actions: [Padding(padding: const EdgeInsets.all(14), child: Text('$seconds ثانیه'))]), body: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text('سؤال ${index + 1} از ${questions.length}'), const SizedBox(height: 20), Text(q.text, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)), const SizedBox(height: 16), ...q.options.map((o) => Padding(padding: const EdgeInsets.only(bottom: 8), child: OutlinedButton(onPressed: selected == null ? () => setState(() { selected = o; if (o == q.answer) score++; else AppStats.mistakes.add(q.text); }) : null, child: Text(o)))), const Spacer(), FilledButton(onPressed: selected == null ? null : () { if (index == questions.length - 1) { finish(); } else { setState(() { index++; selected = null; }); } }, child: Text(index == questions.length - 1 ? 'ثبت نتیجه' : 'بعدی'))]))); }
}

class ResultPage extends StatelessWidget { final int score, total; const ResultPage({super.key, required this.score, required this.total});
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('نتیجه')), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.emoji_events, size: 70, color: Colors.amber), const SizedBox(height: 16), Text('امتیاز شما: $score از $total', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 20), FilledButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: const Text('بازگشت به صفحه اصلی'))])));
}

class ReportPage extends StatelessWidget { const ReportPage({super.key});
  @override Widget build(BuildContext context) { final percent = AppStats.answered == 0 ? 0 : (AppStats.correct * 100 / AppStats.answered).round(); return Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('کارنامه')), body: ListView(padding: const EdgeInsets.all(16), children: [Card(child: ListTile(title: const Text('درصد پاسخ‌های صحیح'), trailing: Text('$percent٪', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)))), Card(child: ListTile(title: const Text('تعداد آزمون‌ها'), trailing: Text('${AppStats.exams}'))), Card(child: ListTile(title: const Text('تعداد پاسخ‌ها'), trailing: Text('${AppStats.answered}'))), const SizedBox(height: 12), const Text('اشتباهات ثبت‌شده', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), if (AppStats.mistakes.isEmpty) const Padding(padding: EdgeInsets.all(12), child: Text('هنوز اشتباهی ثبت نشده است.')) else ...AppStats.mistakes.map((m) => ListTile(leading: const Icon(Icons.error_outline, color: Colors.red), title: Text(m)))]))); }
}

class AboutPage extends StatelessWidget { const AboutPage({super.key});
  @override Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(appBar: AppBar(title: const Text('درباره برنامه')), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.menu_book, size: 76, color: Color(0xFF087F73)), const SizedBox(height: 18), const Text('صرف‌آموز عربی', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)), const SizedBox(height: 20), const Text('HAKnet', style: TextStyle(fontSize: 27, color: Color(0xFF087F73), fontWeight: FontWeight.bold)), const SizedBox(height: 12), const Text('سازنده: عبدالهی خسروشاهی', style: TextStyle(fontSize: 18)), const SizedBox(height: 12), const Text('نسخه 1.0.0'), const SizedBox(height: 18), const Text('ویژه آموزش صرف افعال عربی پایه‌های هفتم تا نهم', textAlign: TextAlign.center)])))));
}
