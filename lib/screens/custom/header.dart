// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:plywood_admin/screens/custom/popup.dart';
// import 'package:provider/provider.dart';

// import '../../controllers/MenuAppController.dart';
// import '../../responsive.dart';

// class Header extends StatefulWidget {
//   final String title;
//   const Header({
//     super.key,
//     required this.title,
//   });

//   @override
//   State<Header> createState() => _HeaderState();
// }

// class _HeaderState extends State<Header> {
//   void _showAddItemPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           backgroundColor: Colors.brown,
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             height: MediaQuery.of(context).size.height * 0.9,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 Text(
//                   "Add Item",
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: PopupCustom(
//                       onSubmitSuccess: () {
//                         Navigator.of(context).pop(); // Close the dialog
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDesktop = Responsive.isDesktop(context);
//     final isMobile = Responsive.isMobile(context);

//     return Column(
//       children: [
//         Row(
//           children: [
//             if (!isDesktop)
//               IconButton(
//                 icon: const Icon(Icons.menu),
//                 onPressed: context.read<MenuAppController>().controlMenu,
//               ),
//             if (!isMobile)
//               Text(
//                 widget.title,
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             if (!isMobile) Spacer(flex: isDesktop ? 2 : 1),
//             // Adjust button size based on screen size
//             Expanded(
//               child: Align(
//                 alignment:
//                     isMobile ? Alignment.centerLeft : Alignment.centerRight,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: isDesktop
//                         ? 20.0
//                         : 10.0, // Adjust padding for larger screens
//                   ),
//                   child: ElevatedButton.icon(
//                     onPressed: _showAddItemPopup,
//                     icon: const Icon(
//                       Icons.add,
//                       color: Colors.white,
//                     ),
//                     label: Text(
//                       "Add Item",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: isDesktop
//                             ? 16.0
//                             : 14.0, // Adjust font size for mobile screens
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xff903642),
//                       padding: EdgeInsets.symmetric(
//                         vertical: isDesktop
//                             ? 16.0
//                             : 12.0, // Adjust padding for mobile screens
//                         horizontal: isDesktop
//                             ? 24.0
//                             : 16.0, // Adjust padding for mobile screens
//                       ),
//                       minimumSize: Size(isDesktop ? 150.0 : 120.0,
//                           50.0), // Adjust button size for mobile screens
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             if (!isMobile) Spacer(flex: isDesktop ? 2 : 1),
//             const Expanded(child: SearchField()),
//           ],
//         ),
//         const SizedBox(height: 50),
//       ],
//     );
//   }
// }

// class SearchField extends StatelessWidget {
//   const SearchField({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: InputDecoration(
//         hintText: "Search",
//         fillColor: const Color(0xFF2A2D3E),
//         filled: true,
//         border: const OutlineInputBorder(
//           borderSide: BorderSide.none,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         suffixIcon: InkWell(
//           onTap: () {},
//           child: Container(
//             padding: const EdgeInsets.all(12),
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             decoration: const BoxDecoration(
//               color: Color(0xFF2697FF),
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             child: SvgPicture.asset("assets/icons/Search.svg"),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plywood_admin/screens/custom/popup.dart';
import 'package:provider/provider.dart';

import '../../controllers/MenuAppController.dart';
import '../../responsive.dart';

class Header extends StatefulWidget {
  final String title;
  const Header({
    super.key,
    required this.title,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  void _showAddItemPopup() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.brown[50],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.brown[700],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add New Item",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: PopupCustom(
                        onSubmitSuccess: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.brown[100],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement submit logic here
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Cancle",
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    return Column(
      children: [
        Row(
          children: [
            if (!isDesktop)
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: context.read<MenuAppController>().controlMenu,
              ),
            if (!isMobile)
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            if (!isMobile) Spacer(flex: isDesktop ? 2 : 1),
            Expanded(
              child: Align(
                alignment:
                    isMobile ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 20.0 : 10.0,
                  ),
                  child: MouseRegion(
                    onEnter: (event) {},
                    onExit: (event) {},
                    child: ElevatedButton.icon(
                      onPressed: _showAddItemPopup,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Add Item",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 16.0 : 14.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff903642),
                        padding: EdgeInsets.symmetric(
                          vertical: isDesktop ? 16.0 : 12.0,
                          horizontal: isDesktop ? 24.0 : 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(isDesktop ? 150.0 : 120.0, 50.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!isMobile) Spacer(flex: isDesktop ? 2 : 1),
            const Expanded(child: SearchField()),
          ],
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: const Color(0xFF2A2D3E),
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF2697FF),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
