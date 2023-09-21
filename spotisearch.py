from dotenv import load_dotenv
from requests import post, get
import os
import base64
import json
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-a", "--artist", type=str)
args = parser.parse_args()
artistParam = args.artist


load_dotenv()

clientId = os.getenv("CLIENT_ID")
clientSecret = os.getenv("CLIENT_SECRET")   

# ! Function to get the auth token to use for API requests
def getToken():
    authString = clientId + ":" + clientSecret
    authBytes = authString.encode('utf-8')
    authBase64 = str(base64.b64encode(authBytes), 'utf-8')

    url = "https://accounts.spotify.com/api/token"
    headers = {
        "Authorization": "Basic " + authBase64,
        "Content-Type": "application/x-www-form-urlencoded"   
    }
    data = {"grant_type": "client_credentials"}
    result = post(url, headers=headers, data=data)
    jsonResult = json.loads(result.content)
    token = jsonResult["access_token"]
    return token


def searchArtist(token, artist_name):
    url = "https://api.spotify.com/v1/search"
    header = {"Authorization": "Bearer " + token}
    query = f"?q={artist_name}&type=artist&limit=1"
    queryUrl = url + query
    result = get(queryUrl, headers=header)
    jsonResult = json.loads(result.content)["artists"]["items"]

    if len(jsonResult) == 0:
        print("No artist found...")
        return None
    
    return jsonResult[0]


def getArtistImage(token, artistId):

    url = f"https://api.spotify.com/v1/artists/{artistId}"
    headers = {"Authorization": "Bearer " + token}

    result = get(url, headers=headers)
    jsonResult = json.loads(result.content)["images"]
    imgUrl = jsonResult[0]['url']
    imageData = get(imgUrl).content

    with open ('artist.jpg', 'wb') as handler:
        handler.write(imageData)

    

token = getToken()

artistObj = searchArtist(token, artistParam)
artistID = artistObj["id"]

getArtistImage(token, artistID)