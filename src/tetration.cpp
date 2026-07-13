#include <climits>
#include <cmath>
#include <iostream>

int pow(int base, int exp) {
  int ret = 1;
  for (int i = 0; i < exp; i++) {
    if (INT_MAX / base < ret)
      return -1;
    ret *= base;
  }
  return ret;
}

int tetrate(int base, int height) {
  if (height == 0)
    return 1;
  int exponent = tetrate(base, height - 1);
  if (exponent < 0)
    return -1;
  return pow(base, exponent);
}

int main() {
  for (int i = 0;; i++) {
    int res = tetrate(2, i);
    std::cout << "2_" << i << " = ";
    if (res < 0) {
      std::cout << "https://sites.google.com/site/largenumbers/home/appendix/a/"
                   "ulnl/265536\n";
      break;
    }
    std::cout << res << '\n';
  }

  return 0;
}
