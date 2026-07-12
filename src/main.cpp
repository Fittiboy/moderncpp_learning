#include <backprint.hpp>
#include <color_print.hpp>
#include <iostream>
#include <ostream>
#include <string_view>

int main() {
  printStringBackwards("There once was a ship that put to sea", std::cout);
  std::cout << std::endl;

  printStringBackwards("And the name of the ship was the Billy of Tea",
                       std::cout);
  std::cout << std::endl;

  std::string_view End = "The end.\n";
  if (colorPrint(End.length(), End.data(), false, true)) {
    std::cout << "\n\nSOMETHING WENT WRONG!!!\n\n";
  };

  return 0;
}
