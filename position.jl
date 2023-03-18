# Filtering GPS signals for locating elderly people out on a walk
# Mind you this is voluntarily
using Pkg; Pkg.add("NMEAParser"); Pkg.add("Gadfly"); Pkg.add("CircuitsIO");


using GadFly
using DataFrames
using NMEAParser
using CircuitsIO

function live_plot_nmea(port::AbstractString)
    # Create an empty DataFrame to hold the GPS data
    nmea_df = DataFrame(latitude=[], longitude=[])

    # Define a function to update the DataFrame with new GPS data
    function update_nmea_data(sentence::String)
        if sentence[1:6] == "\$GPGGA"
            # Parse the sentence into a DataFrame
            new_data = DataFrame(NMEAParser.parse_sentence(sentence))

            # Convert the latitude and longitude columns from strings to floats
            new_data[!, :latitude] = parse(Float64, new_data.latitude[1:end-1])
            new_data[!, :longitude] = parse(Float64, new_data.longitude[1:end-1])

            # Add the new data to the existing DataFrame
            push!(nmea_df, new_data[:, [:latitude, :longitude]])
        end
    end

    # Create a serial port object to read data from the GPS device
    s = Serial(port)

    # Continuously read data from the GPS device and update the map
    while true
        sentence = readline(s)

        update_nmea_data(sentence)

        p = plot(nmea_df, x=:longitude, y=:latitude, Geom.point)

        draw(SVGJS(10cm, 10cm), p)
    end
end

live_plot_nmea("/dev/ttyUSB0")