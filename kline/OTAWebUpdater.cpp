#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
//#include <ESPmDNS.h>
#include <Update.h>

////const char* host = "esp32";
//const char* ssid = "QW_SML_WLAN";
//const char* password = "WirelessSml";

////WiFiServer wifiServer(80);

extern const char jquery_min_js_res[];

WebServer gWebServer(80);


const char* serverIndex =
		//"<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>"
		"<script src='/jquery.min.js'></script>"
		"<form method='POST' action='#' enctype='multipart/form-data' id='upload_form'>"
		"<input type='file' name='update'>"
		"<input type='submit' value='Update'>"
		"</form>"
		"<div id='prg'>progress: 0%</div>"
		"<script>"
		"$('form').submit(function(e){"
		"e.preventDefault();"
		"var form = $('#upload_form')[0];"
		"var data = new FormData(form);"
		" $.ajax({"
		"url: '/update',"
		"type: 'POST',"
		"data: data,"
		"contentType: false,"
		"processData:false,"
		"xhr: function() {"
		"var xhr = new window.XMLHttpRequest();"
		"xhr.upload.addEventListener('progress', function(evt) {"
		"if (evt.lengthComputable) {"
		"var per = evt.loaded / evt.total;"
		"$('#prg').html('progress: ' + Math.round(per*100) + '%');"
		"}"
		"}, false);"
		"return xhr;"
		"},"
		"success:function(d, s) {"
		"console.log('success!')"
		"},"
		"error: function (a, b, c) {"
		"}"
		"});"
		"});"
		"</script>";

void setup(void) {
	Serial.begin(115200);

	Serial.println();
	Serial.println("Configuring access point...");

	// You can remove the password parameter if you want the AP to be open.
	WiFi.softAP("e32w", "wsadwsad");
	IPAddress myIP = WiFi.softAPIP();
	Serial.print("AP IP address: ");
	Serial.println(myIP);
	//  wifiServer.begin();

	Serial.println("Server started");

	//Serial.print(jquery_min_js_res);

	// Connect to WiFi network
//	WiFi.begin(ssid, password);
//	Serial.println("");

//	// Wait for connection
//	while (WiFi.status() != WL_CONNECTED) {
//		delay(500);
//		Serial.print(".");
//	}
//	Serial.println("");
//	Serial.print("Connected to ");
//	Serial.println(ssid);
//	Serial.print("IP address: ");
//	Serial.println(WiFi.localIP());

	/*use mdns for host name resolution*/
	//  if (!MDNS.begin(host)) { //http://esp32.local
	//    Serial.println("Error setting up MDNS responder!");
	//    while (1) {
	//      delay(1000);
	//    }
	//  }
	//  Serial.println("mDNS responder started");
	/*return index page which is stored in serverIndex */

//	gWebServer.on("/", HTTP_GET, []() {
//		gWebServer.sendHeader("Connection", "close");
//		gWebServer.send(200, "text/html", loginIndex);
//	});
	gWebServer.on("/", HTTP_GET, []() {
		gWebServer.sendHeader("Connection", "close");
		gWebServer.send(200, "text/html", serverIndex);
	});

	gWebServer.on("/jquery.min.js", HTTP_GET, []() {
		gWebServer.sendHeader("Connection", "close");
		gWebServer.send_P(200, "application/javascript", jquery_min_js_res);
	});

	/*handling uploading firmware file */
	gWebServer.on("/update", HTTP_POST, []() {
		gWebServer.sendHeader("Connection", "close");
		gWebServer.send(200, "text/plain", (Update.hasError()) ? "FAIL" : "OK");
		ESP.restart();
	}, []() {
		HTTPUpload& upload = gWebServer.upload();
		if (upload.status == UPLOAD_FILE_START) {
			Serial.printf("Update: %s\n", upload.filename.c_str());
			if (!Update.begin(UPDATE_SIZE_UNKNOWN)) { //start with max available size
				Update.printError(Serial);
			}
		} else if (upload.status == UPLOAD_FILE_WRITE) {
			/* flashing firmware to ESP*/
			if (Update.write(upload.buf, upload.currentSize) != upload.currentSize) {
				Update.printError(Serial);
			}
		} else if (upload.status == UPLOAD_FILE_END) {
			if (Update.end(true)) { //true to set the size to the current progress
				Serial.printf("Update Success: %u\nRebooting...\n", upload.totalSize);
			} else {
				Update.printError(Serial);
			}
		}
	});
	gWebServer.begin();
}


void loop(void)
{
	unsigned long currTime = millis();

	gWebServer.handleClient();

	delay(1);

	{
		static unsigned long dbgTime = currTime;
		if(abs(currTime - dbgTime) > 1000)
		{
			dbgTime = currTime;
			Serial.print("tick:");
			Serial.print(currTime);
			Serial.print("\r\n");
		}
	}
}

