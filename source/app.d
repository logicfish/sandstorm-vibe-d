import vibe.vibe;

void main()
{
	auto settings = new HTTPServerSettings;
	settings.port = 8000;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	listenHTTP(settings, &hello);

	logInfo("Please open http://127.0.0.1:8000/ in your browser.");
	runApplication();
}

void hello(HTTPServerRequest req, HTTPServerResponse res)
{
	res.writeBody("Hello, World! "~req.headers["X-Sandstorm-Username"]);
}
