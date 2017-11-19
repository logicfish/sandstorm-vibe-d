import vibe.d;
import vibelog.controller;
import vibelog.web;
import vibelog.webadmin;
void main()
{
	auto router = new URLRouter;

	auto blogsettings = new VibeLogSettings;
	blogsettings.configName = "vibelog";
	blogsettings.siteURL = URL("http://localhost:8000/");
	blogsettings.blogName = "VibeLog";
	blogsettings.blogDescription = "Publishing software utilizing the vibe.d framework";


	auto ctrl = new VibeLogController(blogsettings);
	router.registerVibeLogWeb(ctrl);
	router.registerVibeLogWebAdmin(ctrl);

	auto settings = new HTTPServerSettings;
	settings.port = 8000;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	settings.sessionStore = new MemorySessionStore;

	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8000/ in your browser.");
//	runApplication();
}

