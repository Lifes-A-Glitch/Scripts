# Author: Alex (Kali)
# Date: 5/28/2022
# Will have to install pip to install pandas
# Command for pip: pip install pandas

# Python program to convert
# JSON file to CSV

# import json
# import csv


# Opening JSON file and loading the data
# into the variable data

# TODO: allow user to input file name
# jsonPath = input("What is the file path of the JSON file?: ")
# csvPath = input("What is the file path of the CSV file you want?: ")

with open("J:\\Spotify Account\\my_spotify_data\\MyData\\Playlist1.json") as json_file:
	data = json.load(json_file)

playlist_name = data['playlists']

# now we will open a file for writing
# data_file = open('data_file.csv', 'w')
data_file = open("C:\\Users\\balex\\Desktop\\spotify.csv", 'w')

# create the csv writer object
csv_writer = csv.writer(data_file)

# Counter variable used for writing
# headers to the CSV file
count = 0

for ptn in playlist_name:
	if count == 0:

		# Writing headers of CSV file
		header = ptn.keys()
		csv_writer.writerow(header)
		count += 1

	# Writing data of CSV file
	csv_writer.writerow(ptn.values())

data_file.close()