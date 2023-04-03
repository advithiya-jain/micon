import pylast
import argparse
from requests import get

parser = argparse.ArgumentParser()
parser.add_argument("-a", "--artist", type=str)
parser.add_argument("-al", "--album", type=str)

args = parser.parse_args()

artist = args.artist
album = args.album

# You have to have your own unique two values for API_KEY and API_SECRET
# Obtain yours from https://www.last.fm/api/account/create for Last.fm
API_KEY = "bfc1f84f01aa66e8aa111abaf8844e47"  # this is the micon key
API_SECRET = "196e5e2b0d47c5daa8cf3b7df6977349"

network = pylast.LastFMNetwork(
    api_key=API_KEY,
    api_secret=API_SECRET,
)

# Getting album object from last.fm
album = network.get_album(artist, album)

# Getting cover image url from last.fm
image = album.get_cover_image()
print(image)

# getting image data from image url
img_data = get(image).content

# writing image data to file
with open('cover.jpg', 'wb') as handler:
    handler.write(img_data)
