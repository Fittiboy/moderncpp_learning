#include <iostream>
#include <source_location>

void f(std::source_location s = std::source_location::current()) {
  std::cout << "function: " << s.function_name() << ", line: " << s.line()
            << '\n';
}

int main() { f(); }
