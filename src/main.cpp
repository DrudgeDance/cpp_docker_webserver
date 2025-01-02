#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio.hpp>
#include <iostream>
#include <chrono>
#include <cstdlib>
#include <memory>
#include <string>

namespace beast = boost::beast;
namespace http = beast::http;
namespace net = boost::asio;
using tcp = boost::asio::ip::tcp;

int main() {
    try {
        auto const address = net::ip::make_address("0.0.0.0");
        unsigned short port = 8080;

        net::io_context ioc{1};
        tcp::acceptor acceptor{ioc, {address, port}};

        std::cout << "Server started at http://localhost:" << port << std::endl;
        std::cout.flush();

        while (true) {
            tcp::socket socket{ioc};
            acceptor.accept(socket);

            std::string response_body = "Hello, World!\n";

            http::response<http::string_body> res{
                http::status::ok, 11
            };
            res.set(http::field::server, "Beast");
            res.set(http::field::content_type, "text/plain");
            res.body() = response_body;
            res.prepare_payload();

            // Log each request
            std::cout << "Received request from " << socket.remote_endpoint() << std::endl;
            std::cout.flush();

            http::write(socket, res);
        }
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
} 