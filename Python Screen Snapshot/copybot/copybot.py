import pyautogui
from PIL import Image
import time

a = pyautogui
page = 1
while page < 211:
    print("Getting page number: " + str(page))
    image = a.screenshot(region=(800,94,1200,1229))
    path = 'C:\\Users\\balex\\Desktop\\copybot\\page' + str(page) + '.png'
    image.save(path)
    a.moveTo(x=2524, y=753, duration = 2)
    a.click(x=2528, y=686)
    time.sleep(3)
    page = page + 1
print("Pages copied!")
