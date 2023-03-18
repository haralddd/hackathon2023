# using Pkg; Pkg.add("CSV"); Pkg.add("DataFrames"); Pkg.add("HTTP"); Pkg.add("JSON"); Pkg.add("JSONTables")
using HTTP, CSV, DataFrames, JSON, JSONTables

#= 
Though there is a good number of wearables in the market that provide care for older adults, most of them only focus on fall detection and not prediction. Some wearables proposed are able to detect trips and slips but not specifically fall. So, cStick, a calm stick to monitor falls in older adults is proposed. cStick has been designed in such a way that it can assist both visually and hearing-impaired older adults. cStick has an ability to not only detect falls but to also predict the incident of fall so as to reduce their occurrences. cStick can monitor the surroundings, warn the user if there was a previous fall detected at a certain location, and update the location and its surroundings to the user. Based on the changes in the monitored parameters, the decision of fall i.e., a prediction, warning or detection of fall is made with an accuracy of approximately 95%.

The cStick.csv file that is presented here has parameters- distance, pressure (0-small, 1- medium and 2- high pressures), HRV, Sugar Levels, SpO2 levels and accelerometer reading (<+-3g, i.e., threshold is 0 and >Threshold is 1) in relationship to the decision of falls (0- no fall detected, 1- person slipped/tripped/prediction of fall and 2- definite fall)
If this research or the dataset provided help you in anyway, please cite:

L. Rachakonda, A. Sharma, S. P. Mohanty, and E. Kougianos, "Good-Eye: A Combined Computer-Vision and Physiological-Sensor based Device for Full-Proof Prediction and Detection of Fall of Adults", in Proceedings of the 2nd IFIP International Internet of Things (IoT) Conference (IFIP-IoT), 2019, pp. 273--288.
L. Rachakonda, S. P. Mohanty, and E. Kougianos, “Good-Eye: A Device for Automatic Prediction and Detection of Elderly Falls in Smart Homes”, in Proceedings of the 6th IEEE International Symposium on Smart Electronic Systems (iSES), 2020, pp. 202--203.
L. Rachakonda, S. P. Mohanty, and E. Kougianos, “cStick: A Calm Stick for Fall Prediction, Detection and Control in the IoMT Framework”, in Proceedings of the 4th IFIP International Internet of Things (IoT) Conference (IFIP-IoT), 2021, pp. Accepted on 02 Sep 2021.

=#

df = DataFrame(CSV.File("cStick.csv"))

wait_time = 1.0 # seconds


# Send HTTP POST
headers = [
    "Synx-Cat" => "1",
    "Content-Type" => "application/x-www-form-urlencoded",
]

service_url = "https://group5.cioty.com/health-status"
base_body = "token=aToken_36d8715e3531fd8e8c01fcbfd26bf5af1908e14f15014d2d14817b568bc0bb0e&objectID=1&sender=haralg"
while true
    for i in 1:size(df, 1)
        # get row i
        chunk = df[i, :]
        data_send = base_body * "&data=" * string(objecttable(chunk))
        resp = HTTP.post("https://group5.cioty.com/health-status"; headers = headers, body = data_send, verify=false)
        display(resp.status)
        sleep(wait_time)
    end
end
