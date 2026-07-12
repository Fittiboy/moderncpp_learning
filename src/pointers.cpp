#include <iostream>

int main() {
  int x = 15;
  char *p = (char *)&x;
  // char *p = reinterpret_cast<char *>(&x);
  p += 1;
  *p = 19;
  std::cout << x << '\n';
}
