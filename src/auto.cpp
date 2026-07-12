#include <cmath>
#include <iostream>

auto g(auto x) { return std::pow(x, 32) - 1; }

int main() { std::cout << g(2) << '\n'; }
