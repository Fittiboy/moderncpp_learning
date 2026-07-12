#include <iostream>
#include <limits>
int main() {
  int y = std::numeric_limits<int>::min() * -1;
  std::cout << y << '\n';
}
