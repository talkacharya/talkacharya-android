import 'package:bloc/bloc.dart'; mixin M on Cubit<int> { void foo() { emit(1); } } class A extends Cubit<int> with M { A() : super(0); }
