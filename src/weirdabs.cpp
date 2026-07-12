#include <bit>
#include <iostream>

float weirdabs(float x) {
  unsigned uvalue = std::bit_cast<unsigned>(x);
  unsigned tmp = uvalue & 0x7FFFFFFF;
  return std::bit_cast<float>(tmp);
}

int main() { std::cout << weirdabs(-0.15f) << '\n'; }
