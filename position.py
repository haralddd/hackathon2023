import serial
import pynmea2

# Open serial port
ser = serial.Serial('COM8', 9600)

# Create empty lists to store latitude and longitude data
latitudes = []
longitudes = []
altitudes = []

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