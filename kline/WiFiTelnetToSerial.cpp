#include <WiFi.h>
#include <WiFiMulti.h>

WiFiMulti wifiMulti;

//how many clients should be able to telnet to this ESP32
//#define MAX_SRV_CLIENTS 1
const char* ssid = "Prog";
const char* password = "skynetltd";

WiFiServer gWiFiServer(23);
WiFiClient gWiFiClient;
//WiFiClient serverClients[MAX_SRV_CLIENTS];

//HardwareSerial Serial1(2);  // UART1/Serial1 pins 16,17

HardwareSerial& gUartSerial = Serial;//Serial2;

void setup()
{
	Serial.begin(115200);
	Serial.println("\nConnecting");

	wifiMulti.addAP(ssid, password);
	//  wifiMulti.addAP("ssid_from_AP_2", "your_password_for_AP_2");
	//  wifiMulti.addAP("ssid_from_AP_3", "your_password_for_AP_3");

	Serial.println("Connecting Wifi ");
	for (int loops = 10; loops > 0; loops--)
	{
		if (wifiMulti.run() == WL_CONNECTED)
		{
			Serial.println("");
			Serial.print("WiFi connected ");
			Serial.print("IP address: ");
			Serial.println(WiFi.localIP());
			break;
		}
		else
		{
			Serial.println(loops);
			delay(1000);
		}
	}
	if (wifiMulti.run() != WL_CONNECTED)
	{
		Serial.println("WiFi connect failed");
		delay(1000);
		ESP.restart();
	}

	//start UART and the server
	//gUartSerial.begin(9600);

	gWiFiServer.begin();
	gWiFiServer.setNoDelay(true);

	Serial.print("Ready! Use 'telnet ");
	Serial.print(WiFi.localIP());
	Serial.println(" 23' to connect");
}

void loop()
{
	if (wifiMulti.run() == WL_CONNECTED)
	{
		if(gWiFiClient.connected() == false)
		{
			if (gWiFiServer.hasClient())
				gWiFiClient = gWiFiServer.available();
		}

		if(gWiFiClient.connected())
		{
			while(gWiFiClient.available())
			{
				gUartSerial.write(gWiFiClient.read());
			}

			{
				int len = gUartSerial.available();
				if(len > 0)
				{
					Serial.write(len);
					uint8_t sbuf[len];
					size_t rb = gUartSerial.readBytes(sbuf, len);
					Serial.write(rb);
					if (gWiFiClient.connected())
					{
						gWiFiClient.write(sbuf, rb);
						delay(1);
					}
				}
			}
		}
	}
}
