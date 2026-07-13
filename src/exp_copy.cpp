#include <iostream>

struct A {
  A() {}
  A([[maybe_unused]] const A &obj) { std::cout << "expensive copy" << '\n'; }
};

struct B : A {
  B() {}
  B([[maybe_unused]] const B &obj) { std::cout << "cheap copy" << '\n'; }
};

void f1([[maybe_unused]] B a) {}
void f2([[maybe_unused]] A a) {}

int main() {
  B b1;
  f1(b1);
  f2(b1);
}
