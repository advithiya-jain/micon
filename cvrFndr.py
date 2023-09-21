import pylast
import argparse
from requests import get

parser = argparse.ArgumentParser()
parser.add_argument("-a", "--artist", type=str)
parser.add_argument("-al", "--album", type=str)
parser.add_argument("-op", "--option", type=int, help = "Choose whether to get album art (1) or artist art (2)")

args = parser.parse_args()

artist = args.artist
album = args.album
option = args.option


# You have to have your own unique two values for API_KEY and API_SECRET
# Obtain yours from https://www.last.fm/api/account/create for Last.fm
API_KEY = "bfc1f84f01aa66e8aa111abaf8844e47"  # this is the micon key
API_SECRET = "196e5e2b0d47c5daa8cf3b7df6977349"

network = pylast.LastFMNetwork(
    api_key=API_KEY,
    api_secret=API_SECRET,
    username="micon_api",
    password_hash=pylast.md5("AiPyM55GD&tp"),
)

# Getting album object from last.fm
albumObj = network.get_album(artist, album)    
# Getting cover album_art url from last.fm
album_art = albumObj.get_cover_image()

albumObj = network.get_album(artist, album)
artistName = albumObj.get_artist()
attributes=dir(artistName)
print(attributes)
artistObj = network.get_artist(artistName)
# Getting cover artist_art url from last.fm
artist_art = artistObj.get_cover_image()
# getting artist_art data from artist_art url

def albumArt():
    # getting album_art data from album_art url
    img_data = get(album_art).content
    # writing album_art data to file
    with open('cover.jpg', 'wb') as handler:
        handler.write(img_data)


def artistArt():

    artist_image_data = get(artist_art).content
    # Writing artist_art data to file
    with open('artist.jpg', 'wb') as handler:
        handler.write(artist_image_data)

if option == 1:
    albumArt()
else:
    artistArt()
