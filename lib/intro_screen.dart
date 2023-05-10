// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:kozarni_ecome/screen/home_screen.dart';
//
// class OnBoardingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => SafeArea(
//         child: IntroductionScreen(
//           pages: [
//             PageViewModel(
//               title: "",
//               body: '''Delux Beauti''',
//               image: buildImage('assets/logo.png'),
//               decoration: getPageDecoration(),
//             ),
//             PageViewModel(
//               title: "",
//               body: '''❤ Authentic Korea,
//
// USA and UK products များကို
//
// ယုံကြည်စိတ်ချစွာ
//
// ဝယ်ယူအားပေးနိုင်ပါတယ်ရှင် ❤️''',
//               image: buildImage('assets/logo.png'),
//               decoration: getPageDecoration(),
//             ),
//             PageViewModel(
//               title: '',
//               body: '''🏠 ဆိုင်လိပ်စာလေးကတော့….
//
// ဥက္ကာလမ်း ၊ ဥက္ကာ ၅x၆ လမ်း ၊
// မြောက်ဥက္ကလာပမြို့နယ် ၊ ရန်ကုန်မြို့။''',
//               image: buildImage('assets/logo.png'),
//               decoration: getPageDecoration(),
//             ),
//             PageViewModel(
//               title: "",
//               body: '''☎ ဆက်သွယ်ရန် ဖုန်းနံပါတ်လေးကတော့
//
//   09 884 911 962''',
//               image: buildImage('assets/logo.png'),
//               decoration: getPageDecoration(),
//             ),
//             PageViewModel(
//               title: '',
//               body:
//                   ''' ❝  အခုလိုမျိုး ရွေးချယ်စရာတွေအများကြီးရှိတဲ့ အထဲကမှ မင်မင်တို့ရဲ့ " Delux Beauti " တံဆိပ်ကို ယုံယုံကြည်ကြည်နဲ့ ရွေးချယ်ပေးခဲ့လို့ ကျေးဇူးအထူးတင်ပါတယ် ❞ ''',
//               footer: Padding(
//                 padding: const EdgeInsets.only(top: 0),
//                 child: ButtonWidget(
//                   text: "LET'S GET STARTED",
//                   onClicked: () => goToHome(context),
//                 ),
//               ),
//               image: buildImage('assets/logo.png'),
//               decoration: getPageDecoration(),
//             ),
//           ],
//           done: Text("", style: TextStyle(fontWeight: FontWeight.w600)),
//           onDone: () => goToHome(context),
//           showSkipButton: true,
//           skip: Text(
//             'SKIP',
//             style: TextStyle(fontSize: 16, color: Colors.orange),
//           ),
//           onSkip: () => goToHome(context),
//           next: Icon(Icons.forward_outlined, size: 30, color: Colors.orange),
//           dotsDecorator: getDotDecoration(),
//           onChange: (index) => print('Page $index selected'),
//           globalBackgroundColor: Colors.white,
//           skipFlex: 0,
//           nextFlex: 0,
//           // isProgressTap: false,
//           // isProgress: false,
//           // showNextButton: true,
//           // freeze: true,
//           // animationDuration: 1000,
//         ),
//       );
//
//   void goToHome(context) => Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => HomeScreen()),
//       );
//
//   Widget buildImage(String path) =>
//       Center(child: Image.asset(path, width: 250));
//
//   DotsDecorator getDotDecoration() => DotsDecorator(
//         color: Colors.indigo,
//         activeColor: Colors.orange,
//         size: Size(10, 10),
//         activeSize: Size(22, 10),
//         activeShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//       );
//
//   PageDecoration getPageDecoration() => PageDecoration(
//         titleTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//         titlePadding: EdgeInsets.only(top: 0),
//         descriptionPadding: EdgeInsets.only(top: 30).copyWith(bottom: 0),
//         imagePadding: EdgeInsets.only(top: 30),
//         pageColor: Colors.white,
//       );
// }
//
// class ButtonWidget extends StatelessWidget {
//   final String text;
//   final VoidCallback onClicked;
//
//   const ButtonWidget({
//     Key? key,
//     required this.text,
//     required this.onClicked,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => ElevatedButton(
//         onPressed: onClicked,
//         style: ElevatedButton.styleFrom(
//           primary: Colors.orangeAccent,
//           shape: StadiumBorder(),
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(color: Colors.white, fontSize: 16),
//         ),
//       );
// }
