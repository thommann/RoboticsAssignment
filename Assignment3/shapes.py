import numpy as np
import cv2
#import imutils
from time import sleep

img = cv2.imread('er7-4.jpg')
width = img.shape[1]
height = img.shape[0]
#print(img.shape)
ratio = width/height
dim = (int(500*ratio), 500)
resized = cv2.resize(img, dim)
gray = cv2.cvtColor(resized, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(gray, (5, 5), 0)
ret, thresh = cv2.threshold(blurred, 200, 255, cv2.THRESH_BINARY)
contours, hierarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
print(len(contours))
cv2.drawContours(resized, contours, -1, (0,255,0), 3)

# loop over the contours

'''shapeDict = {
    "triangle" : 0,
    "circle" : 0,
    "line" : 0,
    "square" : 0
}

for c in contours:
    # compute the center of the contour, then detect the name of the
    # shape using only the contour
    M = cv2.moments(c)
    if M["m00"] == 0:
        continue
    cX = int(M["m10"] / M["m00"])
    cY = int(M["m01"] / M["m00"])
    cv2.circle(resized, (cX, cY), 5, (255, 0, 255), thickness=4)
    shape = sd.detect(c, 0.04)

    rect = cv2.minAreaRect(c)
    box = cv2.boxPoints(rect)
    box = np.int0(box)

    if shape == "circle":
        if len(box) == 4:
            (x, y), (w, h), rot = rect
            if w < h :
                ar = w / h
            else:
                ar = h / w
            shape = "circle" if ar >= 0.2 else "line"

    if shape == "triangle":
        shapeDict["triangle"] = shapeDict["triangle"] + 1
    elif shape == "square":
        shapeDict["square"] = shapeDict["square"] + 1
    elif shape == "circle":
        shapeDict["circle"] = shapeDict["circle"] + 1
    else:
        shapeDict["line"] = shapeDict["line"] + 1

    # multiply the contour (x, y)-coordinates by the resize ratio,
    # then draw the contours and the name of the shape on the image
    cv2.drawContours(resized, [c], -1, (0,255,0), 2)
    # print(shape)
    cv2.putText(resized, shape, (cX, cY), cv2.FONT_HERSHEY_SIMPLEX,\
        0.5, (255, 255, 0), 2)

    cv2.drawContours(resized, [box], 0, (0,0,255), 2)

print(shapeDict)
blank = np.zeros((512, 512, 3), np.uint8)

cv2.circle(blank, (80, 80), 30, (0, 0, 255), -1)
cv2.rectangle(blank, (50, 140), (110, 200), (0, 0, 255), -1)
cv2.line(blank, (80, 230), (80, 290), (0, 0, 255), 5)
pts = np.array([[80, 320], [50, 380], [110, 380]], np.int32)
pts = pts.reshape((-1, 1, 2))
cv2.fillPoly(blank, [pts], (0, 0, 255))

circleQty = shapeDict["circle"]
squareQty = shapeDict["square"]
triQty = shapeDict["triangle"]
lineQty = shapeDict["line"]
cv2.putText(blank, str(circleQty), (160, 95), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
cv2.putText(blank, str(squareQty), (160, 185), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
cv2.putText(blank, str(triQty), (160, 365), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
cv2.putText(blank, str(lineQty), (160, 275), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

cv2.imshow('blank',blank)
'''
cv2.imshow('resized', resized)
cv2.imshow('gray', gray)
#cv2.imshow('blurred', blurred)
cv2.imshow('threshold', thresh)

while True:
    k = cv2.waitKey(0)
    if k == 32:
      cv2.destroyAllWindows()

