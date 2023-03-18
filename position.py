import serial
import pynmea2
import requests
import time
import asyncio

# Open serial port
ser = serial.Serial('COM8', 9600)

# Create empty lists to store latitude and longitude data
lat = 0
lon = 0
alt = 0

async def post(lat,long,alt):
    headers = {
            'Synx-Cat': '1',
        'Content-Type': 'application/x-www-form-urlencoded'
    }

    service_url = "https://group5.cioty.com/gps-data"
    base_body = "token=aToken_36d8715e3531fd8e8c01fcbfd26bf5af1908e14f15014d2d14817b568bc0bb0e&objectID=1&sender=NEO-M9N"
    myobj = {'lat': lat, 'long': lon, 'alt': alt}
    data = base_body + "&data=" + str(myobj)

    x = requests.post(service_url, headers = headers, data = data, verify=False)

    print(x.text)
    await asyncio.sleep(1)




# Continuously read data from serial port and update plot
while True:
    # Read a line of data from serial port
    line = ser.readline().decode().strip()

    # Parse the NMEA message
    try:
        msg = pynmea2.parse(line)
    except pynmea2.ParseError:
        continue

    # Extract latitude and longitude data from message
    if isinstance(msg, pynmea2.types.talker.GGA):
        lat = msg.latitude
        lon = msg.longitude
        alt = msg.altitude

        # Add latitude and longitude data to lists

        print("Altitude :", alt)
        print("Longtitude: ", lat)
        print("Latitude: ", lon)

        asyncio.run(post(lat,lon,alt))