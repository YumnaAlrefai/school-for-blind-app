import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/otp.dart';

class RegisterTeacher extends StatefulWidget {
  const RegisterTeacher({super.key});

  @override
  State<RegisterTeacher> createState() => _RegisterTeacherState();
}

class _RegisterTeacherState extends State<RegisterTeacher> {
  final _formKey = GlobalKey<FormState>();
  String selectedLevel = ""; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 362,
        height: 707,
        decoration: const BoxDecoration(
         color: AppColors.kBackgroundColor
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
             margin: const EdgeInsets.only(top: 40, bottom: 20), 
  
  width: MediaQuery.of(context).size.width * 0.88,
  padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 0.3),
            color: AppColors.kBackgroundColor,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                   
                  children: [
                    const Text(
                      "المعلومات الشخصية:",
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    
                   _buildTextField("الاسم الثلاثي", Icons.person),
                    const SizedBox(height: 15),
                    
                    _buildTextField("رقم الهاتف", Icons.smartphone_rounded, isPhone: true),
                    const SizedBox(height: 15),
                    
                    _buildTextField("المادة المعطاة", Icons.menu_book_rounded),
                    const SizedBox(height: 25),
                    const Text(
                      "المرحلة الدراسية:",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(height: 10),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLevelButton("تاسع"),
                        _buildLevelButton("بكالوريا"),
                      ],
                    ),
                    
                    const SizedBox(height: 25),
                    const Text(
                      "السيرة الذاتية:",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(height: 10),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 150,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD3FF54).withOpacity(0.5),width: 0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Icon(Icons.file_upload_outlined, color: Color(0xFFD3FF54)),
                             SizedBox(width: 10),
                             Text("إضافة ملف", style: TextStyle(color: Colors.white70,fontSize: 20)),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
Center(
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OtpScreen()),
      );
    },
    child: Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFD3FF54),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD3FF54).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "التالي",
          style: TextStyle(
            color: Colors.black, 
            fontSize: 40, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    ),
  ),
),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

 Widget _buildTextField(String hint, IconData icon, {bool isPhone = false}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        inputFormatters: isPhone ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] : [],
       decoration: InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: Colors.white38,fontSize: 22 ),
  
  prefixIcon: Padding(
    padding: const EdgeInsets.only(left: 10, right: 12),
    child: Icon(icon, color: const Color(0xFFD3FF54), size: 22),
  ),
  prefixIconConstraints: const BoxConstraints(
    minWidth: 40,
    minHeight: 0,
  ),

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: Color(0xFFD3FF54), 
      width: 0.5, 
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(
      color: Color(0xFFD3FF54), 
      width: 2.0, 
    ),
  ),

  filled: true,
  fillColor: Colors.black.withOpacity(0.1),
  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
),
      ),
    );
  }

 Widget _buildLevelButton(String label) {
    bool isSelected = selectedLevel == label;
    return GestureDetector(
      onTap: () => setState(() => selectedLevel = label),
      child: Container(
        
        width: 120,
        height: 55,
       decoration: BoxDecoration(
  color: AppColors.kBackgroundColor, 

  border: Border.all(
    color: AppColors.kPrimaryColor, 
    width: isSelected ? 2.5 : 1.0, 
  ),

  boxShadow: isSelected ? [
    BoxShadow(
      color:AppColors.kPrimaryColor,
      blurRadius: 10,
      spreadRadius: 1,
    )
  ] : [],
  
  borderRadius: BorderRadius.circular(12), 
),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFD3FF54) : Colors.white,
              fontSize: 20,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}