#include <backprint.hpp>
#include <chrono>
#include <iostream>
#include <ostream>
#include <string_view>
#include <thread>

/// Prints `String`, character by character, starting from the end.
/// This means it will carriage-return after every characters, and
/// print one additional character on the next iteration, until
/// all characters are printed.
/// Caller is responsible for flushing.
std::ostream &printStringBackwards(std::string_view View, std::ostream &Sink) {
  for (size_t I{1}; I <= View.length(); I++) {
    Sink << '\r' << View.subview(View.length() - I);
    std::flush(Sink);
    std::this_thread::sleep_for(std::chrono::milliseconds(37));
  }
  return Sink;
}
