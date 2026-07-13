#include <iostream>

void f([[maybe_unused]] int p) {
  std::cout << __FILE__ << ":" << __LINE__ << '\n';
  std::cout << __FUNCTION__ << '\n';
  std::cout << __func__ << '\n';
}

template <typename T> float g([[maybe_unused]] T p) {
  std::cout << __PRETTY_FUNCTION__ << '\n';
  return 0.0f;
}

void g1() { g(3); }

int main() {
  f(0);
  g1();
}
